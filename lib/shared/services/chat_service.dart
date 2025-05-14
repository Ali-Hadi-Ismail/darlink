import 'package:darlink/models/message.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService with ChangeNotifier {
  // Singleton instance
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // Socket instance
  late IO.Socket socket;
  bool isConnected = false;
  String? currentUserEmail;
  String? currentUserName;

  // Connected users
  final Map<String, bool> _onlineUsers = {};
  Map<String, bool> get onlineUsers => _onlineUsers;

  // Message listeners
  final Map<String, List<Function(Message)>> _messageListeners = {};
  final List<Function(String, String, DateTime)> _newMessageListeners = [];
  final List<Function(List<dynamic>)> _conversationsListeners = [];

  // Connect to socket server
  Future<void> connect() async {
    if (!isConnected) {
      final prefs = await SharedPreferences.getInstance();
      currentUserEmail = prefs.getString('userEmail') ?? '';
      currentUserName = prefs.getString('userName') ?? '';

      if (currentUserEmail!.isEmpty) {
        debugPrint('Cannot connect: No user email found');
        return;
      }

      socket = IO.io(
        "http://192.168.1.104:5000", // Replace with your server IP
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setTimeout(5000)
            .build(),
      );

      socket.connect();

      socket.onConnect((_) {
        debugPrint('Connected to socket server');
        isConnected = true;

        // Register user with socket server
        socket.emit("user_connected", {
          "email": currentUserEmail,
          "name": currentUserName,
        });

        notifyListeners();
      });

      // Handle received messages
      socket.on("receive_message", (data) {
        debugPrint('Message received: $data');

        final message = Message(
          content: data['content'],
          isMe: false,
          timestamp: DateTime.parse(data['timestamp']),
          status: MessageStatus.delivered,
        );

        // Notify specific chat listeners
        final sender = data['sender'];
        if (_messageListeners.containsKey(sender)) {
          for (var listener in _messageListeners[sender]!) {
            listener(message);
          }
        }

        // Notify about new message (for updating recent conversations)
        for (var listener in _newMessageListeners) {
          listener(sender, data['content'], DateTime.parse(data['timestamp']));
        }
      });

      // Handle message sent confirmation
      socket.on("message_sent", (data) {
        debugPrint('Message sent confirmation: $data');
        // Implementation for updating message status
      });

      // Handle user status updates
      socket.on("user_status", (data) {
        debugPrint('User status update: $data');
        _onlineUsers[data['email']] = data['status'] == 'online';
        notifyListeners();
      });

      // Handle chat history response
      socket.on("chat_history", (data) {
        debugPrint('Received chat history with ${data.length} messages');

        // Process and emit messages to the appropriate listener
        final List<Message> messages = [];
        for (var msg in data) {
          final isMe = msg['sender'] == currentUserEmail;

          messages.add(Message(
            content: msg['content'],
            isMe: isMe,
            timestamp: DateTime.parse(msg['timestamp']),
            isRead: msg['isRead'],
            status: isMe
                ? (msg['isRead'] ? MessageStatus.read : MessageStatus.delivered)
                : MessageStatus.sent,
          ));
        }

        // Notify all interested parties about the conversation
        final otherUser = data.isNotEmpty
            ? (data[0]['sender'] == currentUserEmail
                ? data[0]['receiver']
                : data[0]['sender'])
            : null;

        if (otherUser != null && _messageListeners.containsKey(otherUser)) {
          // Add all messages at once
          for (var listener in _messageListeners[otherUser]!) {
            for (var message in messages) {
              listener(message);
            }
          }
        }
      });

      // Handle recent conversations
      socket.on("recent_conversations", (data) {
        debugPrint('Received recent conversations: $data');
        for (var listener in _conversationsListeners) {
          listener(data);
        }
      });

      socket.onDisconnect((_) {
        debugPrint('Disconnected from socket server');
        isConnected = false;
        notifyListeners();
      });

      socket.onConnectError((error) {
        debugPrint('Connection error: $error');
        isConnected = false;
        notifyListeners();
      });
    }
  }

  // Send a message
  void sendMessage(String receiverEmail, String content) {
    if (!isConnected) {
      debugPrint('Cannot send message: Not connected');
      return;
    }

    socket.emit("send_message", {
      "sender": currentUserEmail,
      "receiver": receiverEmail,
      "content": content,
    });

    // Create local message object
    final message = Message(
      content: content,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Notify listeners about this message
    if (_messageListeners.containsKey(receiverEmail)) {
      for (var listener in _messageListeners[receiverEmail]!) {
        listener(message);
      }
    }
  }

  // Get chat history
  void getChatHistory(String otherUserEmail) {
    if (!isConnected) {
      debugPrint('Cannot get chat history: Not connected');
      return;
    }

    socket.emit("get_chat_history", {
      "user1": currentUserEmail,
      "user2": otherUserEmail,
    });
  }

  // Get recent conversations
  void getRecentConversations() {
    if (!isConnected) {
      debugPrint('Cannot get recent conversations: Not connected');
      return;
    }

    socket.emit("get_recent_conversations", {
      "email": currentUserEmail,
    });
  }

  // Mark messages as read
  void markMessagesAsRead(String senderEmail) {
    if (!isConnected) return;

    socket.emit("mark_as_read", {
      "sender": senderEmail,
      "receiver": currentUserEmail,
    });
  }

  // Add message listener for a specific chat
  void addMessageListener(String otherUserEmail, Function(Message) onMessage) {
    if (!_messageListeners.containsKey(otherUserEmail)) {
      _messageListeners[otherUserEmail] = [];
    }
    _messageListeners[otherUserEmail]!.add(onMessage);
  }

  // Remove message listener
  void removeMessageListener(
      String otherUserEmail, Function(Message) listener) {
    if (_messageListeners.containsKey(otherUserEmail)) {
      _messageListeners[otherUserEmail]!.remove(listener);
    }
  }

  // Add listener for new messages (to update UI)
  void addNewMessageListener(Function(String, String, DateTime) listener) {
    _newMessageListeners.add(listener);
  }

  // Remove new message listener
  void removeNewMessageListener(Function(String, String, DateTime) listener) {
    _newMessageListeners.remove(listener);
  }

  // Add listener for conversations updates
  void addConversationsListener(Function(List<dynamic>) listener) {
    _conversationsListeners.add(listener);
  }

  // Remove conversations listener
  void removeConversationsListener(Function(List<dynamic>) listener) {
    _conversationsListeners.remove(listener);
  }

  // Disconnect socket
  void disconnect() {
    if (isConnected) {
      socket.disconnect();
      isConnected = false;
      _messageListeners.clear();
      _newMessageListeners.clear();
      _conversationsListeners.clear();
    }
  }
}
