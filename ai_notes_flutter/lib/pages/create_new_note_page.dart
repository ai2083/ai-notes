import 'package:flutter/material.dart';

class CreateNewNotePage extends StatefulWidget {
  const CreateNewNotePage({super.key});

  @override
  State<CreateNewNotePage> createState() => _CreateNewNotePageState();
}

class _CreateNewNotePageState extends State<CreateNewNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Listen for changes and auto-save
    _titleController.addListener(_autoSave);
    _contentController.addListener(_autoSave);
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  void _autoSave() {
    // Auto-save functionality - can be implemented to save to local storage or backend
    // For now, we'll just print the changes
    print('Auto-saving note: Title="${_titleController.text}", Content="${_contentController.text}"');
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
          'Create New Note',
          style: TextStyle(
            color: Color(0xFF0D141B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Note Title Input
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'New Note',
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
                style: const TextStyle(
                  color: Color(0xFF0D141B),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
              
              const SizedBox(height: 16),
              
              // Note Content Input
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'Note Content',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF0D141B),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
