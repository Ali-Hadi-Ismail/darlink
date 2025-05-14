import 'package:darlink/models/chat.dart';
import 'package:darlink/modules/chat_screen.dart';
import 'package:darlink/shared/services/chat_service.dart';
import 'package:darlink/shared/widgets/card/contact_card.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ChatService _chatService = ChatService();
  List<dynamic> _conversations = [];
  List<dynamic> _filteredConversations = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initChatService();
    _searchController.addListener(_filterConversations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterConversations);
    _searchController.dispose();
    super.dispose();
  }

  void _filterConversations() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredConversations = List.from(_conversations);
      });
    } else {
      setState(() {
        _filteredConversations = _conversations
            .where((conversation) => conversation['email']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _initChatService() async {
    // Ensure connection
    if (!_chatService.isConnected) {
      await _chatService.connect();
    }

    // Add listener for conversations updates
    _chatService.addConversationsListener(_updateConversations);

    // Request recent conversations
    _chatService.getRecentConversations();

    // Add listener for new messages to update the list
    _chatService.addNewMessageListener(_onNewMessage);
  }

  void _updateConversations(List<dynamic> conversations) {
    setState(() {
      _conversations = conversations;
      _filteredConversations = List.from(conversations);
      _isLoading = false;
    });
  }

  void _onNewMessage(String sender, String content, DateTime timestamp) {
    // Update conversations list when a new message is received
    _chatService.getRecentConversations();
  }

  void _navigateToChat(String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(userEmail: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchRow(context),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredConversations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          _searchController.text.isNotEmpty
                              ? "No conversations match your search"
                              : "No conversations yet",
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _filteredConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _filteredConversations[index];
                          return ContactCard(
                            email: conversation['email'],
                            lastMessage: conversation['lastMessage'] ??
                                "No messages yet",
                            time: _formatDateTime(
                                DateTime.parse(conversation['timestamp'])),
                            isOnline: _chatService
                                    .onlineUsers[conversation['email']] ??
                                false,
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}";
    }
  }

  Widget _buildSearchRow(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search contacts...",
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDarkMode ? Colors.white : Colors.grey[600],
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          )),
        ],
      ),
    );
  }
}
