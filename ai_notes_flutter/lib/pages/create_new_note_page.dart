import 'package:flutter/material.dart';
import '../services/crdt_editor_service.dart';

class CreateNewNotePage extends StatefulWidget {
  const CreateNewNotePage({super.key});

  @override
  State<CreateNewNotePage> createState() => _CreateNewNotePageState();
}

class _CreateNewNotePageState extends State<CreateNewNotePage> {
  final CRDTEditorService _editorService = CRDTEditorService();
  String _currentTitle = '';
  String _currentContent = '';
  String? _documentId;
  bool _isServerAvailable = false;
  bool _isCheckingServer = true;
  
  @override
  void initState() {
    super.initState();
    _checkServerAvailability();
  }
  
  @override
  void dispose() {
    _editorService.dispose();
    super.dispose();
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
    });
    
    // Auto-save functionality can be implemented here
    print('Content changed: Title="$title", Content="$content"');
  }
  
  void _onDocIdGenerated(String docId) {
    setState(() {
      _documentId = docId;
    });
    
    print('Document ID generated: $docId');
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
        title: const Text(
          'Collaborative Note',
          style: TextStyle(
            color: Color(0xFF0D141B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        centerTitle: true,
        actions: [
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
