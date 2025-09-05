import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'note_detail_page.dart';
import 'profile_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 2; // Notes tab is selected by default
  
  // 面包屑导航系统
  List<String> _currentPath = ['My Notes']; // Current breadcrumb path
  final ScrollController _breadcrumbScrollController = ScrollController();
  
  // File system structure with 8-level depth support
  final Map<String, dynamic> _fileSystem = {
    'My Notes': {
      'type': 'folder',
      'children': {
        'Work': {
          'type': 'folder',
          'children': {
            'Meeting Notes': {
              'type': 'folder',
              'children': {
                'Daily Standups': {
                  'type': 'folder',
                  'children': {}
                },
                'Client Meetings': {
                  'type': 'folder',
                  'children': {}
                }
              }
            }
          }
        },
        'Personal': {
          'type': 'folder',
          'children': {
            'Journal': {
              'type': 'folder',
              'children': {
                '2025': {
                  'type': 'folder',
                  'children': {
                    'September': {
                      'type': 'folder',
                      'children': {}
                    }
                  }
                }
              }
            },
            'Learning': {
              'type': 'folder',
              'children': {
                'Programming': {
                  'type': 'folder',
                  'children': {
                    'Flutter': {
                      'type': 'folder',
                      'children': {}
                    },
                    'Python': {
                      'type': 'folder',
                      'children': {}
                    }
                  }
                },
                'Languages': {
                  'type': 'folder',
                  'children': {
                    'English': {
                      'type': 'folder',
                      'children': {}
                    }
                  }
                }
              }
            }
          }
        },
        'Study': {
          'type': 'folder',
          'children': {
            'Computer Science': {
              'type': 'folder',
              'children': {
                'Algorithms': {
                  'type': 'folder',
                  'children': {}
                },
                'Data Structures': {
                  'type': 'folder',
                  'children': {}
                }
              }
            }
          }
        }
      }
    }
  };
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    _breadcrumbScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  // 获取当前文件夹
  Map<String, dynamic>? get _currentFolder {
    Map<String, dynamic>? current = _fileSystem;
    
    // Navigate through the path
    for (int i = 0; i < _currentPath.length; i++) {
      String pathSegment = _currentPath[i];
      
      if (current != null && current.containsKey(pathSegment)) {
        // Get the folder object with safe type conversion
        var folderObj = current[pathSegment];
        if (folderObj is Map) {
          current = Map<String, dynamic>.from(folderObj);
        } else {
          return null;
        }
        
        // If this is not the last path segment, navigate to children for the next iteration
        if (i < _currentPath.length - 1) {
          if (current['children'] != null) {
            var childrenObj = current['children'];
            if (childrenObj is Map) {
              current = Map<String, dynamic>.from(childrenObj);
            } else {
              return null;
            }
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
    }
    
    return current;
  }
  
  // 获取当前文件夹内容
  List<String> get _currentFolderContents {
    final folder = _currentFolder;
    if (folder != null && folder['children'] != null) {
      var childrenObj = folder['children'];
      if (childrenObj is Map) {
        // Use a safer approach that works with all Map types
        var safeChildren = <String, dynamic>{};
        childrenObj.forEach((key, value) {
          if (key is String) {
            safeChildren[key] = value;
          }
        });
        return safeChildren.keys.toList()..sort();
      }
    }
    return [];
  }
  
  // 自动滚动到面包屑末尾
  void _scrollBreadcrumbToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_breadcrumbScrollController.hasClients) {
        _breadcrumbScrollController.animateTo(
          _breadcrumbScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _navigateToFolder(String folderName) {
    if (_currentPath.length < 8) { // Maximum 8 levels
      setState(() {
        _currentPath.add(folderName);
      });
      _scrollBreadcrumbToEnd();
    }
  }

  void _navigateToBreadcrumb(int index) {
    setState(() {
      _currentPath = _currentPath.sublist(0, index + 1);
    });
  }

  void _navigateUp() {
    if (_currentPath.length > 1) {
      setState(() {
        _currentPath.removeLast();
      });
    }
  }
  
  // 显示添加文件夹对话框
  void _showAddFolderDialog() {
    final TextEditingController folderNameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('添加子目录'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(
              labelText: '目录名称',
              hintText: '请输入目录名称',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  _addNewFolder(folderName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }
  
  // 添加新文件夹到当前目录
  void _addNewFolder(String folderName) {
    // 获取当前文件夹的引用
    Map<String, dynamic>? currentFolder = _fileSystem;
    
    // 遍历路径找到当前文件夹
    for (int i = 0; i < _currentPath.length; i++) {
      final pathSegment = _currentPath[i];
      if (currentFolder != null && currentFolder.containsKey(pathSegment)) {
        if (i == _currentPath.length - 1) {
          // 这是最后一个路径段，我们在这里添加新文件夹
          if (currentFolder[pathSegment]['children'] != null) {
            currentFolder[pathSegment]['children'][folderName] = {
              'type': 'folder',
              'children': <String, dynamic>{}
            };
          }
        } else {
          // 继续遍历到下一级
          currentFolder = currentFolder[pathSegment]['children'];
        }
      }
    }
    
    // 刷新UI
    setState(() {});
    
    // 显示成功消息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('成功添加目录: $folderName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
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

  final List<NoteFolder> allNotes = [
  ];

  final List<SharedNote> sharedNotes = [
    SharedNote('Team Meeting', 'Shared by Alex', Icons.note),
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
                      'Notes',
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showAddNoteDialog(context);
                      },
                      icon: const Icon(
                        Icons.add,
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
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  // Current Directory Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 80, 4), // 增加右边距从16到80 (5倍)
                    child: Row(
                      children: [
                        const Text(
                          'Notes',
                          style: TextStyle(
                            color: Color(0xFF0D141B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.015,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFE7EDF3),
                          ),
                          child: InkWell(
                            onTap: _showAddFolderDialog,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.create_new_folder,
                                    color: Color(0xFF007AFF),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '创建文件夹',
                                    style: TextStyle(
                                      color: Color(0xFF007AFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Breadcrumb Navigation (Always show)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Back button for subdirectories
                        if (_currentPath.length > 1)
                          IconButton(
                            onPressed: _navigateUp,
                            icon: const Icon(Icons.arrow_back, size: 20),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _breadcrumbScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < _currentPath.length; i++) ...[
                                  if (i > 0)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                                    ),
                                  GestureDetector(
                                    onTap: () {
                                      _navigateToBreadcrumb(i);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: i == _currentPath.length - 1 
                                            ? const Color(0xFF007AFF) 
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _currentPath[i],
                                        style: TextStyle(
                                          color: i == _currentPath.length - 1 
                                              ? Colors.white 
                                              : const Color(0xFF007AFF),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
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
                  
                  const SizedBox(height: 4),
                  
                  // Folder Navigation - Always show container with fixed height
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: _currentFolderContents.isNotEmpty
                        ? ListView.builder(
                            itemCount: _currentFolderContents.length,
                            itemBuilder: (context, index) {
                              return _buildFolderItem(_currentFolderContents[index]);
                            },
                          )
                        : const SizedBox(), // Empty container when no content
                  ),
                  const SizedBox(height: 16),
                  
                  // Note Folders
                  ...allNotes.map((folder) => _buildNoteFolder(folder)),

                  // Shared Notes Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Shared Notes',
                      style: TextStyle(
                        color: Color(0xFF0D141B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),

                  // Shared Notes List
                  ...sharedNotes.map((note) => _buildSharedNote(note)),
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
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) {
              // Navigate back to home
              Navigator.pop(context);
            } else if (index == 1) {
              // Navigate to chat page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
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

  // 获取文件夹中的项目数量
  int _getFolderItemCount(String folderName) {
    // 创建临时路径到指定文件夹
    List<String> tempPath = List.from(_currentPath)..add(folderName);
    
    Map<String, dynamic>? current = _fileSystem;
    
    // 导航到指定文件夹
    for (int i = 0; i < tempPath.length; i++) {
      String pathSegment = tempPath[i];
      
      if (current != null && current.containsKey(pathSegment)) {
        var folderObj = current[pathSegment];
        if (folderObj is Map) {
          current = Map<String, dynamic>.from(folderObj);
        } else {
          return 0;
        }
        
        // 如果不是最后一个路径段，导航到children
        if (i < tempPath.length - 1) {
          if (current['children'] != null) {
            var childrenObj = current['children'];
            if (childrenObj is Map) {
              current = Map<String, dynamic>.from(childrenObj);
            } else {
              return 0;
            }
          } else {
            return 0;
          }
        }
      } else {
        return 0;
      }
    }
    
    // 计算children的数量
    if (current != null && current['children'] != null) {
      var childrenObj = current['children'];
      if (childrenObj is Map) {
        return childrenObj.length;
      }
    }
    
    return 0;
  }

  Widget _buildFolderItem(String folderName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          _navigateToFolder(folderName);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFE7EDF3),
                ),
                child: const Icon(
                  Icons.folder,
                  color: Color(0xFF007AFF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folderName,
                      style: const TextStyle(
                        color: Color(0xFF0D141B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_getFolderItemCount(folderName)} 个项目',
                      style: const TextStyle(
                        color: Color(0xFF4C739A),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteFolder(NoteFolder folder) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          _openFolder(folder);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFE7EDF3),
                ),
                child: Icon(
                  folder.icon,
                  color: const Color(0xFF0D141B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      style: const TextStyle(
                        color: Color(0xFF0D141B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${folder.noteCount} notes',
                      style: const TextStyle(
                        color: Color(0xFF4C739A),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSharedNote(SharedNote note) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          _openSharedNote(note);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFE7EDF3),
                ),
                child: Icon(
                  note.icon,
                  color: const Color(0xFF0D141B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        color: Color(0xFF0D141B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.sharedBy,
                      style: const TextStyle(
                        color: Color(0xFF4C739A),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFolder(NoteFolder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(
          noteTitle: folder.name,
          noteContent: 'This folder contains ${folder.noteCount} notes related to ${folder.name.toLowerCase()}. These notes cover various aspects and details of the topic.',
        ),
      ),
    );
  }

  void _openSharedNote(SharedNote note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(
          noteTitle: note.title,
          noteContent: 'Shared note from ${note.sharedBy}. This note contains collaborative content and insights.',
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Note'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Note title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Note content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                    content: Text('Note added successfully!'),
                    backgroundColor: Color(0xFF1380EC),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1380EC),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Note'),
            ),
          ],
        );
      },
    );
  }
}

class NoteFolder {
  final String name;
  final int noteCount;
  final IconData icon;

  NoteFolder(this.name, this.noteCount, this.icon);
}

class SharedNote {
  final String title;
  final String sharedBy;
  final IconData icon;

  SharedNote(this.title, this.sharedBy, this.icon);
}
