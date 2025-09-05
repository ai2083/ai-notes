import 'dart:async';
import 'package:flutter/material.dart';
import 'note_detail_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'notes_list_page.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  int _selectedIndex = 0; // Home tab is selected by default
  
  // 面包屑导航系统
  List<String> _currentPath = ['My Notes']; // Current breadcrumb path
  List<String> _selectedFolderPath = ['My Notes']; // Selected folder for target
  final ScrollController _breadcrumbScrollController = ScrollController();
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadingFile = '';
  Timer? _progressTimer;
  
  // File system structure with 8-level depth support
  final Map<String, dynamic> _fileSystem = {
    'My Notes': {
      'type': 'folder',
      'children': {
        'Work': {
          'type': 'folder',
          'children': {
            'Projects': {
              'type': 'folder',
              'children': {
                'AI Notes': {
                  'type': 'folder',
                  'children': {
                    'Development': {
                      'type': 'folder',
                      'children': {
                        'Flutter': {
                          'type': 'folder',
                          'children': {
                            'UI Components': {
                              'type': 'folder',
                              'children': {
                                'Pages': {
                                  'type': 'folder',
                                  'children': {}
                                }
                              }
                            },
                            'State Management': {
                              'type': 'folder',
                              'children': {}
                            }
                          }
                        },
                        'Backend': {
                          'type': 'folder',
                          'children': {
                            'APIs': {
                              'type': 'folder',
                              'children': {}
                            }
                          }
                        }
                      }
                    },
                    'Research': {
                      'type': 'folder',
                      'children': {
                        'Machine Learning': {
                          'type': 'folder',
                          'children': {}
                        }
                      }
                    }
                  }
                },
                'Website Redesign': {
                  'type': 'folder',
                  'children': {
                    'Design': {
                      'type': 'folder',
                      'children': {}
                    },
                    'Development': {
                      'type': 'folder',
                      'children': {}
                    }
                  }
                }
              }
            },
            'Meetings': {
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
        },
        'Archive': {
          'type': 'folder',
          'children': {
            '2024': {
              'type': 'folder',
              'children': {
                'Old Projects': {
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

  // 获取用于修改的原始文件夹引用（不创建副本）
  Map<String, dynamic>? get _currentFolderForModification {
    Map<String, dynamic>? current = _fileSystem;
    
    // Navigate through the path, keeping original references
    for (int i = 0; i < _currentPath.length; i++) {
      String pathSegment = _currentPath[i];
      
      if (current != null && current.containsKey(pathSegment)) {
        // Get the folder object without type conversion to maintain reference
        var folderObj = current[pathSegment];
        if (folderObj is Map) {
          // Keep the original reference for the final folder
          if (i == _currentPath.length - 1) {
            // For the target folder, we need to ensure it's the right type but keep reference
            if (folderObj is Map<String, dynamic>) {
              current = folderObj;
            } else {
              // Convert in place if needed
              var converted = Map<String, dynamic>.from(folderObj);
              current[pathSegment] = converted;
              current = converted;
            }
          } else {
            // For intermediate navigation, navigate to children
            current = folderObj as Map<String, dynamic>;
            if (current['children'] != null) {
              var childrenObj = current['children'];
              if (childrenObj is Map) {
                if (childrenObj is Map<String, dynamic>) {
                  current = childrenObj;
                } else {
                  // Convert in place if needed
                  var converted = Map<String, dynamic>.from(childrenObj);
                  current['children'] = converted;
                  current = converted;
                }
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
      } else {
        return null;
      }
    }
    
    return current;
  }

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

  void _navigateToFolder(String folderName, [StateSetter? setModalState]) {
    if (_currentPath.length < 8) { // Maximum 8 levels
      if (setModalState != null) {
        // 在模态对话框中
        setModalState(() {
          _currentPath.add(folderName);
        });
      } else {
        // 在普通页面中
        setState(() {
          _currentPath.add(folderName);
        });
      }
      _scrollBreadcrumbToEnd();
    }
  }

  void _navigateToBreadcrumb(int index, [StateSetter? setModalState]) {
    if (setModalState != null) {
      // 在模态对话框中
      setModalState(() {
        _currentPath = _currentPath.sublist(0, index + 1);
      });
    } else {
      // 在普通页面中
      setState(() {
        _currentPath = _currentPath.sublist(0, index + 1);
      });
    }
  }

  void _navigateUp([StateSetter? setModalState]) {
    if (_currentPath.length > 1) {
      if (setModalState != null) {
        // 在模态对话框中
        setModalState(() {
          _currentPath.removeLast();
        });
      } else {
        // 在普通页面中
        setState(() {
          _currentPath.removeLast();
        });
      }
    }
  }

  void _createNewFolder([StateSetter? setModalState]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newFolderName = '';
        final TextEditingController controller = TextEditingController();
        String? errorMessage;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.create_new_folder,
                      color: Color(0xFF007AFF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('创建新文件夹'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentPath.length >= 8)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              '已达到最大深度限制，无法创建新文件夹',
                              style: TextStyle(color: Colors.orange, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: controller,
                    enabled: _currentPath.length < 8,
                    decoration: InputDecoration(
                      hintText: '输入文件夹名称',
                      border: const OutlineInputBorder(),
                      errorText: errorMessage,
                      prefixIcon: const Icon(Icons.folder_outlined),
                    ),
                    onChanged: (value) {
                      newFolderName = value.trim();
                      setDialogState(() {
                        if (newFolderName.isEmpty) {
                          errorMessage = null;
                        } else if (newFolderName.contains('/') || 
                                 newFolderName.contains('\\') ||
                                 newFolderName.contains(':') ||
                                 newFolderName.contains('*') ||
                                 newFolderName.contains('?') ||
                                 newFolderName.contains('"') ||
                                 newFolderName.contains('<') ||
                                 newFolderName.contains('>') ||
                                 newFolderName.contains('|')) {
                          errorMessage = '文件夹名称不能包含特殊字符';
                        } else if (_currentFolderContains(newFolderName)) {
                          errorMessage = '文件夹名称已存在';
                        } else {
                          errorMessage = null;
                        }
                      });
                    },
                    onSubmitted: (_) {
                      if (_canCreateFolder(newFolderName)) {
                        _performCreateFolder(newFolderName, setModalState);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: _canCreateFolder(newFolderName) 
                    ? () {
                        _performCreateFolder(newFolderName, setModalState);
                        Navigator.pop(context);
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                  ),
                  child: const Text('创建', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _currentFolderContains(String folderName) {
    Map<String, dynamic>? current = _currentFolder;
    if (current != null && current['children'] != null) {
      var childrenObj = current['children'];
      if (childrenObj is Map) {
        // Check if the key exists in a safe way
        return childrenObj.containsKey(folderName);
      }
    }
    return false;
  }

  bool _canCreateFolder(String folderName) {
    return folderName.isNotEmpty && 
           _currentPath.length < 8 && 
           !_currentFolderContains(folderName) &&
           !folderName.contains('/') && 
           !folderName.contains('\\') &&
           !folderName.contains(':') &&
           !folderName.contains('*') &&
           !folderName.contains('?') &&
           !folderName.contains('"') &&
           !folderName.contains('<') &&
           !folderName.contains('>') &&
           !folderName.contains('|');
  }

  void _performCreateFolder(String folderName, [StateSetter? setModalState]) {
    Map<String, dynamic>? current = _currentFolderForModification;
    if (current != null && current['children'] != null) {
      var childrenObj = current['children'];
      if (childrenObj is Map<String, dynamic>) {
        // Directly modify the original children map
        childrenObj[folderName] = {
          'type': 'folder',
          'children': {}
        };
      } else if (childrenObj is Map) {
        // Convert and update if it's a different Map type
        var converted = Map<String, dynamic>.from(childrenObj);
        converted[folderName] = {
          'type': 'folder',
          'children': {}
        };
        current['children'] = converted;
      }
      setState(() {});
      // Update modal state if provided
      setModalState?.call(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('文件夹 "$folderName" 创建成功'),
            ],
          ),
          backgroundColor: const Color(0xFF34C759),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
        // Navigate to Notes page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotesListPage()),
        );
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '选择文件夹',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          if (_currentPath.length < 8)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFF007AFF), width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  _createNewFolder(setModalState);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF007AFF),
                                  size: 20,
                                ),
                                tooltip: '创建新文件夹',
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Breadcrumb Navigation
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (_currentPath.length > 1)
                          IconButton(
                            onPressed: () {
                              _navigateUp(setModalState);
                            },
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
                                      _navigateToBreadcrumb(i, setModalState);
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
                  const SizedBox(height: 16),
                  
                  // Current Path Display
                  Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // 显示尾部路径
                      child: Text(
                        '当前路径: ${_currentPath.join(' > ')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Folder List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _currentFolderContents.length,
                      itemBuilder: (context, index) {
                        final folderName = _currentFolderContents[index];
                        return ListTile(
                          leading: const Icon(Icons.folder, color: Color(0xFF007AFF)),
                          title: Text(folderName),
                          trailing: const Icon(Icons.chevron_right, color: Color(0xFF007AFF)),
                          onTap: () {
                            if (_currentPath.length < 8) {
                              _navigateToFolder(folderName, setModalState);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('已达到最大深度限制'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  
                  // Select Current Folder Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFolderPath = List.from(_currentPath);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('已选择文件夹: ${_currentPath.join(' > ')}'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '选择当前文件夹',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
    _progressTimer = Timer.periodic(duration, (timer) {
      setState(() {
        _uploadProgress += 0.02;
      });
      
      if (_uploadProgress >= 1.0) {
        timer.cancel();
        _progressTimer = null;
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
                      Icons.arrow_back,
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
                          border: Border.all(color: const Color(0xFFCFDBE7)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.folder, color: Color(0xFF007AFF), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true, // 显示尾部路径
                                    child: Text(
                                      _selectedFolderPath.join(' > '),
                                      style: const TextStyle(
                                        color: Color(0xFF0D141B),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF0D141B),
                                  size: 24,
                                ),
                              ],
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

  @override
  void dispose() {
    _progressTimer?.cancel();
    _breadcrumbScrollController.dispose();
    super.dispose();
  }
}
