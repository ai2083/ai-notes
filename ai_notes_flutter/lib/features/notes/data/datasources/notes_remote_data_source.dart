import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> getNotes({
    String? userId,
    String? status,
    String? type,
    List<String>? tags,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  Future<NoteModel> getNoteById(String noteId);
  Future<NoteModel> createNote(NoteModel note);
  Future<NoteModel> updateNote(NoteModel note);
  Future<void> deleteNote(String noteId);
  Future<NoteModel> restoreNote(String noteId);
  Future<void> permanentlyDeleteNote(String noteId);
  Future<List<NoteModel>> batchUpdateNotes(
    List<String> noteIds,
    Map<String, dynamic> updates,
  );
  Future<List<NoteModel>> searchNotes({
    required String query,
    String? userId,
    List<String>? tags,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<String>> getNoteTags(String? userId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final FirebaseFirestore firestore;

  NotesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<NoteModel>> getNotes({
    String? userId,
    String? status,
    String? type,
    List<String>? tags,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      Query query = firestore.collection('notes');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      if (tags != null && tags.isNotEmpty) {
        query = query.where('tags', arrayContainsAny: tags);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query
            .where('title', isGreaterThanOrEqualTo: searchQuery)
            .where('title', isLessThan: searchQuery + 'z');
      }

      query = query.orderBy('updatedAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null && offset > 0) {
        // 需要实现分页逻辑
      }

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => NoteModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get notes: ${e.toString()}');
    }
  }

  @override
  Future<NoteModel> getNoteById(String noteId) async {
    try {
      final doc = await firestore.collection('notes').doc(noteId).get();
      
      if (!doc.exists) {
        throw ServerException(message: 'Note not found');
      }

      return NoteModel.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw ServerException(message: 'Failed to get note: ${e.toString()}');
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final docRef = await firestore.collection('notes').add(note.toJson());
      
      final createdNote = note.copyWith(id: docRef.id) as NoteModel;
      
      // 更新文档ID
      await docRef.update({'id': docRef.id});
      
      return createdNote;
    } catch (e) {
      throw ServerException(message: 'Failed to create note: ${e.toString()}');
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      await firestore.collection('notes').doc(note.id).update(note.toJson());
      
      return note;
    } catch (e) {
      throw ServerException(message: 'Failed to update note: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await firestore.collection('notes').doc(noteId).update({
        'status': 'deleted',
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(message: 'Failed to delete note: ${e.toString()}');
    }
  }

  @override
  Future<NoteModel> restoreNote(String noteId) async {
    try {
      await firestore.collection('notes').doc(noteId).update({
        'status': 'draft',
        'deletedAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return await getNoteById(noteId);
    } catch (e) {
      throw ServerException(message: 'Failed to restore note: ${e.toString()}');
    }
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    try {
      await firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      throw ServerException(message: 'Failed to permanently delete note: ${e.toString()}');
    }
  }

  @override
  Future<List<NoteModel>> batchUpdateNotes(
    List<String> noteIds,
    Map<String, dynamic> updates,
  ) async {
    try {
      final batch = firestore.batch();
      final updatedNotes = <NoteModel>[];

      for (final noteId in noteIds) {
        final docRef = firestore.collection('notes').doc(noteId);
        batch.update(docRef, {
          ...updates,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      // 获取更新后的笔记
      for (final noteId in noteIds) {
        final note = await getNoteById(noteId);
        updatedNotes.add(note);
      }

      return updatedNotes;
    } catch (e) {
      throw ServerException(message: 'Failed to batch update notes: ${e.toString()}');
    }
  }

  @override
  Future<List<NoteModel>> searchNotes({
    required String query,
    String? userId,
    List<String>? tags,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query firestoreQuery = firestore.collection('notes');

      if (userId != null) {
        firestoreQuery = firestoreQuery.where('userId', isEqualTo: userId);
      }

      if (type != null) {
        firestoreQuery = firestoreQuery.where('type', isEqualTo: type);
      }

      if (tags != null && tags.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('tags', arrayContainsAny: tags);
      }

      if (startDate != null) {
        firestoreQuery = firestoreQuery.where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }

      if (endDate != null) {
        firestoreQuery = firestoreQuery.where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

      // 简单的文本搜索，在实际应用中可能需要使用Algolia等搜索服务
      firestoreQuery = firestoreQuery
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z');

      final querySnapshot = await firestoreQuery.get();
      
      return querySnapshot.docs
          .map((doc) => NoteModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to search notes: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getNoteTags(String? userId) async {
    try {
      Query query = firestore.collection('notes');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      final allTags = <String>{};

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final tags = List<String>.from(data['tags'] ?? []);
        allTags.addAll(tags);
      }

      return allTags.toList()..sort();
    } catch (e) {
      throw ServerException(message: 'Failed to get note tags: ${e.toString()}');
    }
  }
}
