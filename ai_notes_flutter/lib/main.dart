import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/notes_list_page.dart';
import 'pages/chat_page.dart';
import 'pages/profile_page.dart';
import 'pages/note_detail_page.dart';
import 'pages/add_note_page.dart';
import 'data/default_notes_generator.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedLabels = [];
  
  // Available labels for filtering
  final List<String> _availableLabels = [
    '学习', '笔记', '复习',
    '工作', '职业', '技能',
    '日记', '成长', '反思',
    '游戏', '娱乐', '儿童'
  ];
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }
  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('筛选标签'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _availableLabels.map((label) {
                    return CheckboxListTile(
                      title: Text(label),
                      value: _selectedLabels.contains(label),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedLabels.add(label);
                          } else {
                            _selectedLabels.remove(label);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedLabels.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('清除'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('应用'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  List<NoteCategory> _getFilteredCategories() {
    final allCategories = DefaultNotesGenerator.generateMinimalDefaultNotes();
    
    if (_searchQuery.isEmpty && _selectedLabels.isEmpty) {
      return allCategories;
    }
    
    return allCategories.map((category) {
      final filteredItems = category.items.where((item) {
        // Title search
        bool titleMatches = _searchQuery.isEmpty || 
            item.title.toLowerCase().contains(_searchQuery.toLowerCase());
        
        // Label filter - for now we'll match against category title since items don't have tags
        bool labelMatches = _selectedLabels.isEmpty || 
            _selectedLabels.any((selectedLabel) => 
                category.title.contains(selectedLabel));
        
        return titleMatches && labelMatches;
      }).toList();
      
      return NoteCategory(
        title: category.title,
        items: filteredItems,
      );
    }).where((category) => category.items.isNotEmpty).toList();
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

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _getFilteredCategories();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF1F5F9),
              child: const Center(
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
            
            // Filter Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showFilterDialog(),
                    icon: const Icon(Icons.filter_list, size: 20),
                    label: Text(_selectedLabels.isEmpty 
                        ? '筛选' 
                        : '筛选 (${_selectedLabels.length})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '搜索笔记标题...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Voice input functionality - placeholder for now
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('语音输入功能开发中...')),
                        );
                      },
                      icon: const Icon(Icons.mic, color: Color(0xFF007AFF)),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
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
        margin: const EdgeInsets.only(bottom: 20), // Moved closer to bottom nav (about 10cm from your request)
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNotePage(),
              ),
            );
          },
          backgroundColor: const Color(0xFF007AFF), // Fashionable iOS-style blue
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 28),
          shape: const CircleBorder(), // Ensures perfect circular shape
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
