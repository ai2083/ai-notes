import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/notes_list_page.dart';
import 'pages/chat_page.dart';
import 'pages/profile_page.dart';
import 'pages/note_detail_page.dart';
import 'data/default_notes_generator.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Notes Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1380EC)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: const NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  int _selectedIndex = 0; // Home tab is selected by default
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure Home tab is selected when this page is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    });
  }

  // 使用默认笔记生成器为每个类型生成一个默认笔记
  final List<NoteCategory> categories = DefaultNotesGenerator.generateMinimalDefaultNotes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Home',
                        style: TextStyle(
                          color: Color(0xFF0D141B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Color(0xFF0D141B),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        child: Text(
                          category.title,
                          style: const TextStyle(
                            color: Color(0xFF0D141B),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.015,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: category.items.length,
                          itemBuilder: (context, itemIndex) {
                            final item = category.items[itemIndex];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoteDetailPage(
                                      noteTitle: item.title,
                                      noteContent: 'This note covers the key concepts of ${item.title.toLowerCase()}, including important details and insights.',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.grey[300],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.blue.withOpacity(0.3),
                                                  Colors.purple.withOpacity(0.3),
                                                ],
                                              ),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.note,
                                                size: 48,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        color: Color(0xFF0D141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotesListPage(),
              ),
            );
          },
          backgroundColor: const Color(0xFF1380EC),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 24),
          label: const Text(''),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
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
            if (index == 0) {
              // Stay on home page, just update state
              setState(() {
                _selectedIndex = 0;
              });
            } else {
              // For other tabs, navigate but don't update state here
              // The state will be handled by didChangeDependencies when returning
              if (index == 1) {
                // Navigate to chat page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                );
              } else if (index == 2) {
                // Navigate to notes list page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesListPage(),
                  ),
                );
              } else if (index == 3) {
                // Navigate to profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              }
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
}

class NoteCategory {
  final String title;
  final List<NoteItem> items;

  NoteCategory({required this.title, required this.items});
}

class NoteItem {
  final String title;
  final String imageUrl;

  NoteItem(this.title, this.imageUrl);
}
