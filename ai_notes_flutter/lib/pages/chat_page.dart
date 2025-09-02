import 'package:flutter/material.dart';
import 'notes_list_page.dart';
import 'profile_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 1; // Chat tab is selected by default
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure Chat tab is selected when this page is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedIndex != 1) {
        setState(() {
          _selectedIndex = 1;
        });
      }
    });
  }

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi there! How can I help you today?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatMessage(
      text: "Can you summarize my notes on the history of artificial intelligence?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    ChatMessage(
      text: "Certainly! Here's a summary of your notes on the history of AI: AI's roots trace back to the mid-20th century, with key figures like Alan Turing laying the theoretical groundwork. The Dartmouth Workshop in 1956 is considered the birth of AI as a field. Early AI research focused on symbolic reasoning and expert systems, achieving some successes but facing limitations in handling complex, real-world problems. The field experienced an 'AI winter' due to these challenges and funding cuts. Renewed interest in AI emerged in the 1980s with the development of neural networks and machine learning algorithms. This period saw advancements in areas like speech recognition and natural language processing. However, another AI winter followed in the late 1980s and early 1990s. The late 2000s and 2010s witnessed a resurgence of AI, driven by increased computing power, the availability of large datasets, and breakthroughs in deep learning. This led to significant progress in areas like image recognition, natural language understanding, and autonomous systems. Today, AI is integrated into various aspects of our lives, from virtual assistants to medical diagnostics, and research continues to push the boundaries of what's possible.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'AI Note Assistant',
                      style: TextStyle(
                        color: Color(0xFF0D141B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showChatHistory();
                      },
                      icon: const Icon(
                        Icons.access_time,
                        color: Color(0xFF0D141B),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Input Area
            Container(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFE7EDF3),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(
                            color: Color(0xFF4C739A),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF0D141B),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (text) {
                          _sendMessage(text);
                        },
                      ),
                    ),
                    // Action Buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _attachNote();
                          },
                          icon: const Icon(
                            Icons.note_outlined,
                            color: Color(0xFF4C739A),
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _startVoiceInput();
                          },
                          icon: const Icon(
                            Icons.mic_outlined,
                            color: Color(0xFF4C739A),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _sendMessage(_messageController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1380EC),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(84, 32),
                            ),
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE7EDF3), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) {
              // Navigate back to home
              Navigator.pop(context);
            } else if (index == 2) {
              // Navigate to notes page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotesListPage(),
                ),
              );
            } else if (index == 3) {
              // Navigate to profile page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFF1F5F9),
          selectedItemColor: const Color(0xFF0D141B),
          unselectedItemColor: const Color(0xFF4C739A),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.015,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.015,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_outlined),
              activeIcon: Icon(Icons.note),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            // AI Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.purple.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.isUser ? 'User' : 'AI Assistant',
                  style: const TextStyle(
                    color: Color(0xFF4C739A),
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  decoration: BoxDecoration(
                    color: message.isUser ? const Color(0xFF1380EC) : const Color(0xFFE7EDF3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : const Color(0xFF0D141B),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            // User Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.withOpacity(0.8),
                    Colors.red.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _generateAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });

      // Scroll to bottom again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  String _generateAIResponse(String userMessage) {
    // Simple AI response simulation
    if (userMessage.toLowerCase().contains('help')) {
      return "I'm here to help! I can assist you with summarizing your notes, answering questions about your content, organizing information, and much more. What would you like to work on?";
    } else if (userMessage.toLowerCase().contains('note')) {
      return "I can help you with your notes! I can summarize them, find specific information, organize them by topics, or answer questions based on their content. What specific notes would you like me to help with?";
    } else if (userMessage.toLowerCase().contains('thank')) {
      return "You're welcome! I'm always here to help with your notes and questions. Is there anything else you'd like to know?";
    } else {
      return "I understand you're asking about \"$userMessage\". Let me help you with that. Could you provide more context or specify what aspect you'd like me to focus on?";
    }
  }

  void _attachNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attach Note'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Meeting Notes'),
                subtitle: Text('12 notes'),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Project Ideas'),
                subtitle: Text('8 notes'),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Personal Journal'),
                subtitle: Text('5 notes'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note attached to conversation'),
                    backgroundColor: Color(0xFF1380EC),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1380EC),
                foregroundColor: Colors.white,
              ),
              child: const Text('Attach'),
            ),
          ],
        );
      },
    );
  }

  void _startVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input feature coming soon!'),
        backgroundColor: Color(0xFF1380EC),
      ),
    );
  }

  void _showChatHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat History'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Today'),
                subtitle: Text('AI History Discussion'),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Yesterday'),
                subtitle: Text('Note Organization Help'),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('2 days ago'),
                subtitle: Text('Research Questions'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
