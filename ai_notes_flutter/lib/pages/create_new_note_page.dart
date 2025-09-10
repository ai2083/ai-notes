import 'package:flutter/material.dart';
import 'dart:async';
import '../services/crdt_editor_service.dart';
import '../features/notes/domain/entities/note.dart';
import '../features/notes/domain/repositories/notes_repository.dart';
import '../features/notes/domain/usecases/create_note.dart';
import '../features/notes/domain/usecases/update_note.dart';
import '../features/notes/domain/usecases/get_note_by_id.dart';
import '../core/di/injection.dart';
import '../debug/notes_storage_debugger.dart';

class CreateNewNotePage extends StatefulWidget {
  final String? existingNoteId; // 用于编辑现有笔记
  final String? targetFolder;   // 目标文件夹
  
  const CreateNewNotePage({
    super.key,
    this.existingNoteId,
    this.targetFolder,
  });

  @override
  State<CreateNewNotePage> createState() => _CreateNewNotePageState();
}

class _CreateNewNotePageState extends State<CreateNewNotePage> {
  final CRDTEditorService _editorService = CRDTEditorService();
  
  // 笔记相关状态
  Note? _currentNote;
  String _currentTitle = '';
  String _currentContent = '';
  String? _documentId;
  
  // 自动保存相关
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  
  // 服务器状态
  bool _isServerAvailable = false;
  bool _isCheckingServer = true;
  
  // 用例依赖
  late final CreateNote _createNoteUseCase;
  late final UpdateNote _updateNoteUseCase;
  late final GetNoteById _getNoteByIdUseCase;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化用例
    final notesRepository = getIt<NotesRepository>();
    _createNoteUseCase = CreateNote(notesRepository);
    _updateNoteUseCase = UpdateNote(notesRepository);
    _getNoteByIdUseCase = GetNoteById(notesRepository);
    
    _checkServerAvailability();
    
    // 如果有现有笔记ID，则加载它
    if (widget.existingNoteId != null) {
      _loadExistingNote();
    }
  }
  
  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _editorService.dispose();
    super.dispose();
  }
  
  /// 加载现有笔记
  Future<void> _loadExistingNote() async {
    if (widget.existingNoteId == null) return;
    
    final result = await _getNoteByIdUseCase(widget.existingNoteId!);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load note: ${failure.toString()}')),
        );
      },
      (note) {
        setState(() {
          _currentNote = note;
          _currentTitle = note.title;
          _currentContent = note.content;
        });
        
        // 设置编辑器内容
        _editorService.setContent(
          title: _currentTitle, 
          content: _currentContent,
        );
      },
    );
  }
  
  Future<void> _checkServerAvailability() async {
    final isAvailable = await CRDTEditorService.isServerAvailable();
    setState(() {
      _isServerAvailable = isAvailable;
      _isCheckingServer = false;
    });
    
    if (!isAvailable) {
      _showServerUnavailableDialog();
    }
  }
  
  void _showServerUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CRDT Server Unavailable'),
        content: const Text(
          'The collaborative editing server is not available. '
          'The editor will work in offline mode. Changes will be saved locally '
          'and can sync when the server becomes available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Offline'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkServerAvailability();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  void _onContentChanged(String title, String content) {
    setState(() {
      _currentTitle = title;
      _currentContent = content;
      _hasUnsavedChanges = true;
    });
    
    // 延迟自动保存，避免频繁保存
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      _autoSaveNote();
    });
    
    print('Content changed: Title="$title", Content="$content"');
  }
  
  /// 自动保存笔记
  Future<void> _autoSaveNote() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final displayTitle = _currentTitle.trim().isEmpty ? 'Untitled' : _currentTitle.trim();
      
      print('=== 开始自动保存 ===');
      print('目标文件夹: ${widget.targetFolder}');
      print('标题: $displayTitle');
      print('内容长度: ${_currentContent.length}');
      print('文档ID: $_documentId');
      print('当前笔记: ${_currentNote?.id}');
      
      if (_currentNote == null) {
        // 创建新笔记
        final newNote = Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: displayTitle,
          content: _currentContent,
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: [],
          attachments: [],
          keywords: _extractKeywords(_currentContent),
          userId: 'current_user', // TODO: 获取实际用户ID
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          metadata: {
            'targetFolder': widget.targetFolder,
            'crdtDocumentId': _documentId,
          },
        );
        
        print('创建新笔记: ${newNote.id}');
        print('笔记元数据: ${newNote.metadata}');
        
        final result = await _createNoteUseCase(newNote);
        result.fold(
          (failure) {
            print('❌ 创建笔记失败: $failure');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save note')),
            );
          },
          (note) {
            setState(() {
              _currentNote = note;
              _hasUnsavedChanges = false;
            });
            print('✅ 笔记创建成功: ${note.id}');
            print('保存位置: ${note.metadata?['targetFolder']}');
            
            // 立即调试查看存储情况
            NotesStorageDebugger.debugStoredNotes();
          },
        );
      } else {
        // 更新现有笔记
        final updatedNote = _currentNote!.copyWith(
          title: displayTitle,
          content: _currentContent,
          updatedAt: DateTime.now(),
          keywords: _extractKeywords(_currentContent),
        );
        
        final result = await _updateNoteUseCase(updatedNote);
        result.fold(
          (failure) {
            print('Failed to update note: $failure');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save note')),
            );
          },
          (note) {
            setState(() {
              _currentNote = note;
              _hasUnsavedChanges = false;
            });
            print('Note updated successfully: ${note.id}');
          },
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
  
  /// 从内容中提取关键词（简单实现）
  List<String> _extractKeywords(String content) {
    if (content.isEmpty) return [];
    
    final words = content
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 3)
        .toSet()
        .toList();
    
    return words.take(10).toList(); // 最多10个关键词
  }
  
  void _onDocIdGenerated(String docId) {
    setState(() {
      _documentId = docId;
    });
    
    print('Document ID generated: $docId');
    
    // 如果已有笔记，更新其 metadata
    if (_currentNote != null) {
      final updatedMetadata = Map<String, dynamic>.from(_currentNote!.metadata ?? {});
      updatedMetadata['crdtDocumentId'] = docId;
      
      final updatedNote = _currentNote!.copyWith(
        metadata: updatedMetadata,
        updatedAt: DateTime.now(),
      );
      
      _updateNoteUseCase(updatedNote).then((result) {
        result.fold(
          (failure) => print('Failed to update note with doc ID: $failure'),
          (note) {
            setState(() {
              _currentNote = note;
            });
            print('Note updated with doc ID: $docId');
          },
        );
      });
    }
  }
  
  Future<void> _exportContent() async {
    final content = await _editorService.getContent();
    if (content != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Content'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Document ID: ${content['docId']}'),
                const SizedBox(height: 8),
                Text('Title: ${content['title']}'),
                const SizedBox(height: 8),
                Text('Content: ${content['content']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = _currentTitle.trim().isEmpty ? 'Untitled' : _currentTitle.trim();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0D141B),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayTitle,
              style: const TextStyle(
                color: Color(0xFF0D141B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
            ),
            if (_isSaving)
              const Text(
                'Saving...',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                ),
              )
            else if (_hasUnsavedChanges)
              const Text(
                'Unsaved changes',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 12,
                ),
              )
            else if (_currentNote != null)
              const Text(
                'All changes saved',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Debug 按钮（开发模式）
          IconButton(
            onPressed: () async {
              await NotesStorageDebugger.debugStoredNotes();
            },
            icon: const Icon(
              Icons.bug_report,
              color: Color(0xFF8B5CF6),
            ),
            tooltip: 'Debug Storage',
          ),
          if (!_isCheckingServer)
            IconButton(
              onPressed: _exportContent,
              icon: const Icon(
                Icons.share,
                color: Color(0xFF0D141B),
              ),
              tooltip: 'Export Content',
            ),
          if (!_isCheckingServer)
            IconButton(
              onPressed: _checkServerAvailability,
              icon: Icon(
                _isServerAvailable ? Icons.cloud_done : Icons.cloud_off,
                color: _isServerAvailable ? Colors.green : Colors.orange,
              ),
              tooltip: _isServerAvailable ? 'Online' : 'Offline',
            ),
        ],
      ),
      body: SafeArea(
        child: _isCheckingServer
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Checking CRDT server availability...'),
                  ],
                ),
              )
            : _buildEditor(),
      ),
    );
  }
  
  Widget _buildEditor() {
    if (_isServerAvailable) {
      // Online mode with CRDT collaboration
      return _editorService.createWebView(
        onContentChanged: _onContentChanged,
        onDocIdGenerated: _onDocIdGenerated,
      );
    } else {
      // Offline mode with local editing
      return _editorService.createOfflineWebView(
        onContentChanged: _onContentChanged,
        onDocIdGenerated: _onDocIdGenerated,
        initialTitle: _currentTitle.isEmpty ? null : _currentTitle,
        initialContent: _currentContent.isEmpty ? null : _currentContent,
      );
    }
  }
}
