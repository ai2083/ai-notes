import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'notes_list_page.dart';
import 'profile_page.dart';
import 'create_new_note_page.dart';
import 'add_note_page.dart';
import '../widgets/note_creation_dialog.dart';

class NoteDetailPage extends StatefulWidget {
  final String noteTitle;
  final String noteContent;
  final bool showCreationDialog; // 新参数：是否显示创建对话框
  final String? targetFolder;
  
  const NoteDetailPage({
    super.key,
    this.noteTitle = 'Note Title',
    this.noteContent = 'This note covers the key concepts of AI in note-taking, including summarization, question generation, and flashcard creation.',
    this.showCreationDialog = true, // 默认显示对话框
    this.targetFolder,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> with TickerProviderStateMixin {
  int _selectedBottomIndex = 2; // Notes tab is selected
  late TabController _tabController;
  
  final List<bool> _actionItems = [false, false]; // For checkboxes
  
  // 新增状态变量
  bool _showEditor = false;
  String? _selectedAction;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // 如果需要显示创建对话框，则在构建完成后显示
    if (widget.showCreationDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCreationDialog();
      });
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure Notes tab is selected when this page is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedBottomIndex != 2) {
        setState(() {
          _selectedBottomIndex = 2;
        });
      }
    });
  }
  
  // 显示创建选择对话框
  Future<void> _showCreationDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => NoteCreationDialog(
        targetFolder: widget.targetFolder,
      ),
    );
    
    if (result != null) {
      setState(() {
        _selectedAction = result['action'];
      });
      
      if (result['action'] == 'create') {
        // 显示CRDT编辑器
        setState(() {
          _showEditor = true;
        });
      } else if (result['action'] == 'upload') {
        // 显示上传对话框
        _showUploadDialog();
      }
    } else {
      // 用户取消了，返回上一页
      Navigator.of(context).pop();
    }
  }
  
  // 显示上传对话框
  Future<void> _showUploadDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNotePage(),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      setState(() {
        _showEditor = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              color: const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0D141B),
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 48),
                      child: Center(
                        child: Text(
                          widget.noteTitle,
                          style: const TextStyle(
                            color: Color(0xFF0D141B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.015,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFCFDBE7), width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF1380EC),
                indicatorWeight: 3,
                labelColor: const Color(0xFF0D141B),
                unselectedLabelColor: const Color(0xFF4C739A),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
                tabs: const [
                  Tab(text: 'Note'),
                  Tab(text: 'Chat'),
                  Tab(text: 'Flashcards'),
                  Tab(text: 'Quiz'),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNoteContent(),
                  _buildChatContent(),
                  _buildFlashcardsContent(),
                  _buildQuizContent(),
                ],
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
          currentIndex: _selectedBottomIndex,
          onTap: (index) {
            setState(() {
              _selectedBottomIndex = index;
            });
            if (index == 0) {
              // Navigate to home
              Navigator.popUntil(context, (route) => route.isFirst);
            } else if (index == 1) {
              // Navigate to chat page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            } else if (index == 2) {
              // Stay on notes (or go to notes list)
              if (index != _selectedBottomIndex) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesListPage(),
                  ),
                );
              }
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
              icon: Icon(Icons.note),
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

  Widget _buildNoteContent() {
    // 如果选择了创建笔记或上传文件，显示编辑器
    if (_showEditor) {
      if (_selectedAction == 'create') {
        return CreateNewNotePage(
          targetFolder: widget.targetFolder,
        );
      } else if (_selectedAction == 'upload') {
        // 显示上传内容的编辑器
        return CreateNewNotePage(
          targetFolder: widget.targetFolder,
        );
      }
    }
    
    // 默认显示原有的笔记内容
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Summary',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              widget.noteContent,
              style: const TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          
          // Highlights Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Highlights',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'AI enhances note-taking by providing features like automatic summarization, generating questions for review, and creating flashcards for efficient learning.',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          
          // Detailed Highlights
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Summarization of long notes into concise points',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'This feature allows users to condense extensive notes into key takeaways, making it easier to review and understand the core concepts. For example, it can transform a lengthy lecture transcript into a bullet-point summary highlighting the main topics discussed.',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Generation of review questions based on note content',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'This functionality creates questions based on the content of the notes, aiding in self-assessment and knowledge reinforcement. These questions can range from simple recall to more complex analytical inquiries, such as:\n\n• What are the main arguments presented in the text?\n• How does this concept relate to previous material?\n• What are the implications of these findings?',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Creation of flashcards for quick revision',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'This tool automatically generates flashcards from the notes, facilitating efficient and effective revision. Flashcards can include:\n\n• Key terms and definitions\n• Important formulas or equations\n• Significant dates or events',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          
          // Action Items Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Action Items',
              style: TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                CheckboxListTile(
                  value: _actionItems[0],
                  onChanged: (value) {
                    setState(() {
                      _actionItems[0] = value ?? false;
                    });
                  },
                  title: const Text(
                    'Explore the AI-powered features in the note-taking app.',
                    style: TextStyle(
                      color: Color(0xFF0D141B),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  activeColor: const Color(0xFF1380EC),
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  value: _actionItems[1],
                  onChanged: (value) {
                    setState(() {
                      _actionItems[1] = value ?? false;
                    });
                  },
                  title: const Text(
                    'Improve study efficiency and knowledge retention.',
                    style: TextStyle(
                      color: Color(0xFF0D141B),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  activeColor: const Color(0xFF1380EC),
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Color(0xFF4C739A),
          ),
          SizedBox(height: 16),
          Text(
            'Chat about this note',
            style: TextStyle(
              color: Color(0xFF4C739A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ask questions and get AI assistance with your notes',
            style: TextStyle(
              color: Color(0xFF4C739A),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardsContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.style_outlined,
            size: 64,
            color: Color(0xFF4C739A),
          ),
          SizedBox(height: 16),
          Text(
            'Flashcards',
            style: TextStyle(
              color: Color(0xFF4C739A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Auto-generated flashcards from your notes',
            style: TextStyle(
              color: Color(0xFF4C739A),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Color(0xFF4C739A),
          ),
          SizedBox(height: 16),
          Text(
            'Quiz',
            style: TextStyle(
              color: Color(0xFF4C739A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Test your knowledge with AI-generated questions',
            style: TextStyle(
              color: Color(0xFF4C739A),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
