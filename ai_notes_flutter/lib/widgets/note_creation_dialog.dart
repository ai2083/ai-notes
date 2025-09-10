import 'package:flutter/material.dart';

class NoteCreationDialog extends StatelessWidget {
  final String? targetFolder;
  
  const NoteCreationDialog({
    super.key,
    this.targetFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            const Text(
              'Create New Note',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D141B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose how you want to create your note',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Create Note 选项
            _buildOptionTile(
              context: context,
              icon: Icons.edit_note,
              title: 'Create Note',
              subtitle: 'Start writing with our collaborative editor',
              color: const Color(0xFF007AFF),
              onTap: () async {
                Navigator.of(context).pop();
                
                // 返回创建笔记的选择
                Navigator.of(context).pop({'action': 'create', 'targetFolder': targetFolder});
              },
            ),
            
            const SizedBox(height: 16),
            
            // Upload 选项
            _buildOptionTile(
              context: context,
              icon: Icons.upload_file,
              title: 'Upload',
              subtitle: 'Upload and process documents, images, or audio',
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.of(context).pop();
                
                // 返回上传的选择
                Navigator.of(context).pop({'action': 'upload', 'targetFolder': targetFolder});
              },
            ),
            
            const SizedBox(height: 24),
            
            // 取消按钮
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D141B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
