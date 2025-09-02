import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/notes_list_page.dart';
import 'pages/chat_page.dart';
import 'pages/profile_page.dart';
import 'pages/note_detail_page.dart';

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

  final List<NoteCategory> categories = [
    NoteCategory(
      title: 'Academic/Learning',
      items: [
        NoteItem('Lecture Notes', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Research Paper', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
        NoteItem('Study Guide', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400'),
        NoteItem('Class Project', 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400'),
        NoteItem('Online Course', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400'),
        NoteItem('Textbook Summary', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400'),
        NoteItem('Exam Prep', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Group Discussion', 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=400'),
        NoteItem('Lab Report', 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400'),
        NoteItem('Presentation', 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400'),
      ],
    ),
    NoteCategory(
      title: 'Career/Skills',
      items: [
        NoteItem('Meeting Notes', 'https://images.unsplash.com/photo-1517180102446-f3ece451e9d8?w=400'),
        NoteItem('Project Plan', 'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400'),
        NoteItem('Skill Development', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Networking Event', 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=400'),
        NoteItem('Interview Prep', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
        NoteItem('Resume Update', 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=400'),
        NoteItem('Career Goals', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Industry Trends', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400'),
        NoteItem('Feedback Session', 'https://images.unsplash.com/photo-1517180102446-f3ece451e9d8?w=400'),
        NoteItem('Performance Review', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400'),
      ],
    ),
    NoteCategory(
      title: 'Memory/Personal Growth',
      items: [
        NoteItem('Journal Entry', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400'),
        NoteItem('Personal Goals', 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400'),
        NoteItem('Book Summary', 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400'),
        NoteItem('Mindfulness Exercise', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'),
        NoteItem('Gratitude List', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Reflection', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400'),
        NoteItem('Inspiration', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'),
        NoteItem('Learning Log', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Habit Tracker', 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400'),
        NoteItem('Memory', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400'),
      ],
    ),
    NoteCategory(
      title: 'Fun/Kids',
      items: [
        NoteItem('Family Activities', 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400'),
        NoteItem('Kids\' Projects', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400'),
        NoteItem('Game Ideas', 'https://images.unsplash.com/photo-1606092195730-5d7b9af1efc5?w=400'),
        NoteItem('Movie List', 'https://images.unsplash.com/photo-1489599510450-b6138516b045?w=400'),
        NoteItem('Travel Plans', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400'),
        NoteItem('Recipes', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400'),
        NoteItem('Hobby Notes', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
        NoteItem('Creative Writing', 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400'),
        NoteItem('Event Planning', 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=400'),
        NoteItem('Wish List', 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400'),
      ],
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Notes',
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
            setState(() {
              _selectedIndex = index;
            });
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
