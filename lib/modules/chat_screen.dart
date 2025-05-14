import 'package:darlink/models/message.dart';
import 'package:darlink/shared/services/chat_service.dart';
import 'package:darlink/shared/widgets/card/message/own_message_card.dart';
import 'package:darlink/shared/widgets/card/message/reply_message_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String userEmail;

  const ChatScreen({
    required this.userEmail,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  bool _showAttachmentOptions = false;
  bool _isOnline = false;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _initChat();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showAttachmentOptions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    // Remove the message listener when the chat screen is closed
    _chatService.removeMessageListener(widget.userEmail, _onNewMessage);
    super.dispose();
  }

  void _initChat() {
    // Ensure the chat service is connected
    if (!_chatService.isConnected) {
      _chatService.connect().then((_) => _setupChat());
    } else {
      _setupChat();
    }
  }

  void _setupChat() {
    // Register this chat's message listener
    _chatService.addMessageListener(widget.userEmail, _onNewMessage);

    // Get chat history
    _chatService.getChatHistory(widget.userEmail);

    // Mark messages as read
    _chatService.markMessagesAsRead(widget.userEmail);

    // Check if user is online
    setState(() {
      _isOnline = _chatService.onlineUsers[widget.userEmail] ?? false;
    });
  }

  void _onNewMessage(Message message) {
    setState(() {
      _messages.add(message);
    });

    // Scroll to the bottom of the chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // If receiving a message, mark it as read
    if (!message.isMe) {
      _chatService.markMessagesAsRead(widget.userEmail);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _chatService.sendMessage(widget.userEmail, message);
    _messageController.clear();

    // Return focus to input field
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/message_background.jpg',
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildChatAppBar(theme, context),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return message.isMe
                            ? OwnMessageCard(
                                message: message.content,
                                time: _formatTime(message.timestamp),
                                status: message.status,
                              )
                            : ReplyMessageCard(
                                message: message.content,
                                time: _formatTime(message.timestamp),
                              );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildMessageInput(context, theme),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  AppBar _buildChatAppBar(ThemeData theme, BuildContext context) {
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.secondary,
            child: Text(
              widget.userEmail[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userEmail,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _isOnline ? "Online" : "Offline",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.white),
          onPressed: () {
            // Implement call functionality if needed
          },
        ),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 60,
          child: Card(
            margin: const EdgeInsets.only(left: 10, right: 5, bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: _messageController,
              focusNode: _focusNode,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () {
                        // Implement camera functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        setState(() {
                          _showAttachmentOptions = !_showAttachmentOptions;
                          _focusNode.unfocus();
                        });
                      },
                    ),
                  ],
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    // Implement emoji selector
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 0),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: theme.colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ),
      ],
    );
  }
}
