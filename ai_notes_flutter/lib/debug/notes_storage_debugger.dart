import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotesStorageDebugger {
  static Future<void> debugStoredNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString('notes');
    
    print('=== 笔记存储调试信息 ===');
    
    if (notesJson == null || notesJson.isEmpty) {
      print('❌ SharedPreferences中没有找到笔记数据');
      print('Key "notes" 不存在或为空');
      return;
    }
    
    try {
      final notesList = (jsonDecode(notesJson) as List);
      print('✅ 找到 ${notesList.length} 条笔记记录');
      
      for (int i = 0; i < notesList.length; i++) {
        final noteData = notesList[i];
        print('\n--- 笔记 ${i + 1} ---');
        print('ID: ${noteData['id']}');
        print('标题: ${noteData['title']}');
        print('内容长度: ${noteData['content']?.length ?? 0} 字符');
        print('类型: ${noteData['type']}');
        print('状态: ${noteData['status']}');
        print('创建时间: ${noteData['createdAt']}');
        print('更新时间: ${noteData['updatedAt']}');
        
        // 检查metadata中的targetFolder
        if (noteData['metadata'] != null) {
          final metadata = noteData['metadata'];
          print('目标文件夹: ${metadata['targetFolder'] ?? '未设置'}');
          print('CRDT文档ID: ${metadata['crdtDocumentId'] ?? '未设置'}');
        } else {
          print('元数据: 无');
        }
      }
      
    } catch (e) {
      print('❌ 解析笔记数据时出错: $e');
      print('原始JSON长度: ${notesJson.length}');
      print('原始JSON前100字符: ${notesJson.substring(0, notesJson.length > 100 ? 100 : notesJson.length)}');
    }
    
    print('\n=== 调试信息结束 ===');
  }
  
  static Future<void> clearAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notes');
    print('✅ 已清除所有存储的笔记');
  }
  
  static Future<List<String>> getAllStorageKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().toList();
    print('所有SharedPreferences键: $keys');
    return keys;
  }
}
