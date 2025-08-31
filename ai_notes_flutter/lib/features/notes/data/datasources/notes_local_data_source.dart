import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getNotes({
    String? userId,
    String? status,
    String? type,
    List<String>? tags,
    String? searchQuery,
  });
  
  Future<NoteModel?> getNoteById(String noteId);
  Future<void> cacheNote(NoteModel note);
  Future<void> cacheNotes(List<NoteModel> notes);
  Future<void> deleteNote(String noteId);
  Future<void> clearCache();
  Future<List<String>> getNoteTags(String? userId);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  static const String notesBoxName = 'notes';
  
  Box<Map>? _notesBox;

  Future<Box<Map>> get notesBox async {
    _notesBox ??= await Hive.openBox<Map>(notesBoxName);
    return _notesBox!;
  }

  @override
  Future<List<NoteModel>> getNotes({
    String? userId,
    String? status,
    String? type,
    List<String>? tags,
    String? searchQuery,
  }) async {
    try {
      final box = await notesBox;
      final notes = <NoteModel>[];

      for (final entry in box.values) {
        final noteMap = Map<String, dynamic>.from(entry);
        final note = NoteModel.fromHiveJson(noteMap);

        // 应用过滤条件
        if (userId != null && note.userId != userId) continue;
        if (status != null && note.status.name != status) continue;
        if (type != null && note.type.name != type) continue;
        
        if (tags != null && tags.isNotEmpty) {
          final hasAnyTag = tags.any((tag) => note.tags.contains(tag));
          if (!hasAnyTag) continue;
        }

        if (searchQuery != null && searchQuery.isNotEmpty) {
          final queryLower = searchQuery.toLowerCase();
          final titleMatch = note.title.toLowerCase().contains(queryLower);
          final contentMatch = note.content.toLowerCase().contains(queryLower);
          if (!titleMatch && !contentMatch) continue;
        }

        notes.add(note);
      }

      // 按更新时间降序排序
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return notes;
    } catch (e) {
      throw CacheException(message: 'Failed to get notes from cache: ${e.toString()}');
    }
  }

  @override
  Future<NoteModel?> getNoteById(String noteId) async {
    try {
      final box = await notesBox;
      final noteMap = box.get(noteId);
      
      if (noteMap == null) return null;
      
      return NoteModel.fromHiveJson(Map<String, dynamic>.from(noteMap));
    } catch (e) {
      throw CacheException(message: 'Failed to get note from cache: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheNote(NoteModel note) async {
    try {
      final box = await notesBox;
      await box.put(note.id, note.toHiveJson());
    } catch (e) {
      throw CacheException(message: 'Failed to cache note: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    try {
      final box = await notesBox;
      final notesMap = <String, Map<String, dynamic>>{};
      
      for (final note in notes) {
        notesMap[note.id] = note.toHiveJson();
      }
      
      await box.putAll(notesMap);
    } catch (e) {
      throw CacheException(message: 'Failed to cache notes: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      final box = await notesBox;
      await box.delete(noteId);
    } catch (e) {
      throw CacheException(message: 'Failed to delete note from cache: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await notesBox;
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear notes cache: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getNoteTags(String? userId) async {
    try {
      final notes = await getNotes(userId: userId);
      final allTags = <String>{};

      for (final note in notes) {
        allTags.addAll(note.tags);
      }

      return allTags.toList()..sort();
    } catch (e) {
      throw CacheException(message: 'Failed to get note tags from cache: ${e.toString()}');
    }
  }
}
