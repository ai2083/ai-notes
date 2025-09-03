import 'dart:async';
import 'package:flutter/material.dart';
import 'note_detail_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  int _selectedIndex = 2; // Notes tab is selected by default
  String _selectedFolder = 'My Notes';
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadingFile = '';
  
  final List<String> _folders = [
    'My Notes',
    'Work Notes',
    'Study Notes',
    'Personal Journal',
    'Meeting Notes',
    'Project Ideas',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure Notes tab is selected when this page is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedIndex != 2) {
        setState(() {
          _selectedIndex = 2;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
        break;
      case 2:
        // Already on Notes page
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  void _selectFolder() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Folder',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...(_folders.map((folder) => ListTile(
                title: Text(folder),
                leading: const Icon(Icons.folder),
                trailing: _selectedFolder == folder 
                    ? const Icon(Icons.check, color: Color(0xFF1380EC))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedFolder = folder;
                  });
                  Navigator.pop(context);
                },
              ))),
            ],
          ),
        );
      },
    );
  }

  void _startUpload(String type) {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadingFile = type;
    });

    // Simulate upload progress
    _simulateUpload();
  }

  void _simulateUpload() {
    const duration = Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      setState(() {
        _uploadProgress += 0.02;
      });
      
      if (_uploadProgress >= 1.0) {
        timer.cancel();
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
        
        // Show success message and navigate to note detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_uploadingFile uploaded successfully!'),
            backgroundColor: const Color(0xFF1380EC),
          ),
        );
        
        // Navigate to the note detail page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailPage(
              noteTitle: 'New $_uploadingFile Note',
              noteContent: 'Content from $_uploadingFile has been processed and is ready for editing.',
            ),
          ),
        );
      }
    });
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0xFFCFDBE7)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF0D141B),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF0D141B),
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Add Note',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0D141B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24), // Balance the close button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Target Folder Section
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        'Target Folder',
                        style: TextStyle(
                          color: Color(0xFF0D141B),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ),
                    
                    GestureDetector(
                      onTap: _selectFolder,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedFolder,
                                style: const TextStyle(
                                  color: Color(0xFF0D141B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF0D141B),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Upload Section
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          color: Color(0xFF0D141B),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ),

                    // Upload Options Grid
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        children: [
                          _buildUploadOption(
                            icon: Icons.mic,
                            title: 'Audio',
                            onTap: () => _startUpload('Audio'),
                          ),
                          _buildUploadOption(
                            icon: Icons.videocam,
                            title: 'Video',
                            onTap: () => _startUpload('Video'),
                          ),
                          _buildUploadOption(
                            icon: Icons.description,
                            title: 'PDF',
                            onTap: () => _startUpload('PDF'),
                          ),
                          _buildUploadOption(
                            icon: Icons.smart_display,
                            title: 'YouTube',
                            onTap: () => _startUpload('YouTube'),
                          ),
                          _buildUploadOption(
                            icon: Icons.slideshow,
                            title: 'PPT',
                            onTap: () => _startUpload('PPT'),
                          ),
                          _buildUploadOption(
                            icon: Icons.language,
                            title: 'Website',
                            onTap: () => _startUpload('Website'),
                          ),
                        ],
                      ),
                    ),

                    // Upload Progress Section (shown when uploading)
                    if (_isUploading) ...[
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Uploading and processing...',
                                  style: const TextStyle(
                                    color: Color(0xFF0D141B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFCFDBE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _uploadProgress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1380EC),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(_uploadProgress * 100).toInt()}% complete',
                              style: const TextStyle(
                                color: Color(0xFF4C739A),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFF8FAFC),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note, size: 24),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}
