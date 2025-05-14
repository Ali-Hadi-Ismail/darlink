import 'package:darlink/models/contact.dart';
import 'package:darlink/models/message.dart';
import 'package:darlink/shared/widgets/card/message/own_message_card.dart';
import 'package:darlink/shared/widgets/card/message/reply_message_card.dart';
import 'package:darlink/shared/widgets/chat_widget/attachment_option.dart';
import 'package:darlink/shared/widgets/chat_widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  bool _showAttachmentOptions = false;
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<Message> messages = [];
  late IO.Socket socket;
  Contact contact = Contact(
    name: 'Ervin Crouse',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    isOnline: true,
    typingStatus: null,
  );

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    connect();
  }
// In chat_screen.dart, replace the connect() method with this updated version:

  void connect() {
    // Try different connection approaches
    try {
      // Option 1: Use your computer's IP on your local network
      // Change this to your actual IP address on your local network
      final String serverUrl =
          "http://10.0.2.2:5000"; // For Android emulator connecting to localhost
      // Alternative IPs to try:
      // "http://localhost:5000" - might work depending on your setup
      // "http://127.0.0.1:5000" - localhost IP
      // "http://YOUR_ACTUAL_IP:5000" - replace with your computer's IP on your network

      print("Attempting to connect to: $serverUrl");

      socket = IO.io(
        serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(5000)
            .setTimeout(10000) // Increase timeout to 10 seconds
            .build(),
      );

      socket.connect();

      socket.onConnect((_) {
        print('Connected to socket server at $serverUrl');
        socket.emit("test", "Hello from Flutter");
      });

      print("Socket connected status: ${socket.connected}");

      socket.onConnectError((error) {
        print('Connection error: $error');
        // You could show a snackbar or alert here
      });

      socket.onDisconnect((_) {
        print('Disconnected from socket server');
      });

      socket.on("test_response", (data) {
        print('Received test response: $data');
      });

      // Add error handling for socket errors
      socket.onError((error) {
        print('Socket error: $error');
      });
    } catch (e) {
      print('Error initializing socket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {},
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
            appBar: _chatAppBar(theme, context),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: ListView(
                      reverse: true,
                      shrinkWrap: true,
                      children: [
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomTyping(context, theme),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _chatAppBar(ThemeData theme, BuildContext context) {
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
            backgroundImage: NetworkImage(contact.avatarUrl),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Last seen: 2 hours ago",
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
            _makePhoneCall('+96181932662');
          },
        ),
      ],
    );
  }

  Row _buildBottomTyping(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 55,
          child: Card(
            margin: const EdgeInsets.only(left: 10, right: 5, bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
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
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {},
                    ),
                  ],
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    setState(() {
                      _showAttachmentOptions = !_showAttachmentOptions;
                    });
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
              onPressed: () {
                // Handle send button press
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _controller.clear();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
