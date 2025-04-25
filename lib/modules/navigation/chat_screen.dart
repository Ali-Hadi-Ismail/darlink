import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/models/contact.dart';
import 'package:darlink/models/message.dart';
import 'package:darlink/shared/widgets/chat_widget/attachment_option.dart';
import 'package:darlink/shared/widgets/chat_widget/message_bubble.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode =
      FocusNode(); // Added focus node to detect keyboard focus
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  bool _showAttachmentOptions = false;
  Contact contact = Contact(
    name: 'Ervin Crouse',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    isOnline: true,
    typingStatus: null,
  );

  List<Message> messages = [];

  late AnimationController _attachmentAnimationController;
  late Animation<double> _attachmentAnimation;

  @override
  void initState() {
    super.initState();

    _attachmentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _attachmentAnimation = CurvedAnimation(
      parent: _attachmentAnimationController,
      curve: Curves.easeInOut,
    );

    // Simulate the other person typing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          contact = Contact(
            name: contact.name,
            avatarUrl: contact.avatarUrl,
            isOnline: contact.isOnline,
            typingStatus: 'typing...',
          );
        });

        // Stop typing after a few seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              contact = Contact(
                name: contact.name,
                avatarUrl: contact.avatarUrl,
                isOnline: contact.isOnline,
                typingStatus: null,
              );
            });

            // Add a new message from the contact
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  messages.add(
                    Message(
                      content: 'By the way, did you see the latest report?',
                      isMe: false,
                      timestamp: DateTime.now(),
                      status: MessageStatus.delivered,
                    ),
                  );
                });
                _scrollToBottom();
              }
            });
          }
        });
      }
    });

    _controller.addListener(_onTextChanged);

    // Add listeners for focus and tap to dismiss attachment options
    _focusNode.addListener(_onFocusChange);

    // Scroll to bottom initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _recordingTimer?.cancel();
    _attachmentAnimationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onFocusChange() {
    // Hide attachment options when keyboard appears
    if (_focusNode.hasFocus && _showAttachmentOptions) {
      _hideAttachmentOptions();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration =
            Duration(seconds: _recordingDuration.inSeconds + 1);
      });
    });
  }

  void _stopRecording() {
    _recordingTimer?.cancel();

    // Add the voice message
    setState(() {
      _isRecording = false;
      messages.add(
        Message(
          content: '',
          isMe: true,
          timestamp: DateTime.now(),
          isVoiceMessage: true,
          voiceDuration: _recordingDuration,
          status: MessageStatus.sending,
        ),
      );
    });

    // Simulate sending process
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          messages.last = Message(
            content: messages.last.content,
            isMe: messages.last.isMe,
            timestamp: messages.last.timestamp,
            isVoiceMessage: messages.last.isVoiceMessage,
            voiceDuration: messages.last.voiceDuration,
            status: MessageStatus.sent,
          );
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              messages.last = Message(
                content: messages.last.content,
                isMe: messages.last.isMe,
                timestamp: messages.last.timestamp,
                isVoiceMessage: messages.last.isVoiceMessage,
                voiceDuration: messages.last.voiceDuration,
                status: MessageStatus.delivered,
              );
            });
          }
        });
      }
    });

    _scrollToBottom();
  }

  void _toggleAttachmentOptions() {
    if (_showAttachmentOptions) {
      _hideAttachmentOptions();
    } else {
      _showAttachmentPanel();
    }
  }

  void _showAttachmentPanel() {
    setState(() {
      _showAttachmentOptions = true;
    });
    _attachmentAnimationController.forward();
    // Clear focus to hide keyboard when showing attachments
    FocusScope.of(context).unfocus();
  }

  void _hideAttachmentOptions() {
    setState(() {
      _showAttachmentOptions = false;
    });
    _attachmentAnimationController.reverse();
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    final newMessage = Message(
      content: _controller.text,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      messages.add(newMessage);
      _controller.clear();
    });

    _scrollToBottom();

    // Simulate message sending process
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          messages.last = Message(
            content: messages.last.content,
            isMe: messages.last.isMe,
            timestamp: messages.last.timestamp,
            status: MessageStatus.sent,
          );
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              messages.last = Message(
                content: messages.last.content,
                isMe: messages.last.isMe,
                timestamp: messages.last.timestamp,
                status: MessageStatus.delivered,
              );
            });

            // Simulate contact typing
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  contact = Contact(
                    name: contact.name,
                    avatarUrl: contact.avatarUrl,
                    isOnline: contact.isOnline,
                    typingStatus: 'typing...',
                  );
                });

                // Add reply after typing
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      contact = Contact(
                        name: contact.name,
                        avatarUrl: contact.avatarUrl,
                        isOnline: contact.isOnline,
                        typingStatus: null,
                      );

                      // Auto-reply based on user's message
                      String reply = '';
                      if (newMessage.content.toLowerCase().contains('hello') ||
                          newMessage.content.toLowerCase().contains('hi')) {
                        reply = 'Hi there! How are you doing today?';
                      } else if (newMessage.content
                          .toLowerCase()
                          .contains('how are you')) {
                        reply =
                            'I\'m doing great, thanks for asking! How about you?';
                      } else if (newMessage.content
                              .toLowerCase()
                              .contains('thanks') ||
                          newMessage.content
                              .toLowerCase()
                              .contains('thank you')) {
                        reply =
                            'You\'re welcome! Anything else I can help with?';
                      } else {
                        reply = 'That\'s interesting! Tell me more about it.';
                      }

                      messages.add(
                        Message(
                          content: reply,
                          isMe: false,
                          timestamp: DateTime.now(),
                          status: MessageStatus.delivered,
                        ),
                      );
                    });
                    _scrollToBottom();
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_showAttachmentOptions) {
          _hideAttachmentOptions();
        }
      },
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: backGroundColor,
          leadingWidth: 80,
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              const SizedBox(width: 5),
            ],
          ),
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (contact.typingStatus != null)
                    Text(
                      contact.typingStatus!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone,
                  color: Colors.purple), // Changed to violet
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.videocam,
                  color: Colors.purple), // Changed to violet
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800]!.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    // ! need to handel if another day or old date
                    'Today',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                // Add another gesture detector to handle taps inside ListView
                onTap: () {
                  if (_showAttachmentOptions) {
                    _hideAttachmentOptions();
                  }
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final showTime = index == messages.length - 1 ||
                        messages[index + 1].isMe != message.isMe;

                    return MessageBubble(
                      message: message,
                      showTime: showTime,
                    );
                  },
                ),
              ),
            ),
            _isRecording
                ? _buildRecordingUI()
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    color: const Color(0xFF1A1A2E),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode:
                                        _focusNode, // Assigned focus node
                                    decoration: const InputDecoration(
                                      hintText: 'Type something...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: null,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.grey),
                                  onPressed: _toggleAttachmentOptions,
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.emoji_emotions_outlined,
                                      color: Colors.grey),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .deepPurple, // Changed from blue to violet
                          ),
                          child: IconButton(
                            icon: Icon(
                              _controller.text.isEmpty
                                  ? Icons.mic
                                  : Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (_controller.text.isEmpty) {
                                _startRecording();
                              } else {
                                _sendMessage();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            // The attachment panel now appears immediately above the input container
            if (_showAttachmentOptions)
              AttachmentOptions(animation: _attachmentAnimation),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF2C2C44),
      child: Row(
        children: [
          const Icon(
            Icons.mic,
            color: Colors.red,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recording...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_recordingDuration.inMinutes.toString().padLeft(2, '0')}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              _recordingTimer?.cancel();
              setState(() {
                _isRecording = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.send,
                color: Colors.deepPurple), // Changed to violet
            onPressed: _stopRecording,
          ),
        ],
      ),
    );
  }
}
