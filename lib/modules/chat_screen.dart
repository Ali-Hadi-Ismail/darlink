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
  bool show = false;
  FocusNode focusNode = FocusNode();

  final TextEditingController _controller = TextEditingController();

  bool _showAttachmentOptions = false;

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
    connect();
    focusNode.addListener(() {
      super.initState();
      if (focusNode.hasFocus) {
        setState(() {
          _showAttachmentOptions = false;
        });
      }
    });
  }

  void connect() {
    socket = IO.io(
      "http://192.168.1.104:5000", // Replace X with your actual local IP
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableForceNew()
          .setTimeout(5000)
          .build(),
    );

    socket.connect();

    socket.onConnect((data) {
      print('Connected to socket server');
      socket.emit("test", "Hello from Flutter");
    });
    print(socket.connected);
    socket.onConnectError((error) {
      print('Connection error: $error');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.on("test", (data) {
      print('Received test message: $data');
    });
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
