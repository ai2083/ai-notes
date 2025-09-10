import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';

class NotesRepositoryImpl implements NotesRepository {
  final Dio dio;
  final SharedPreferences prefs;

  NotesRepositoryImpl({
    required this.dio,
    required this.prefs,
  });

  @override
  Future<Either<Failure, List<Note>>> getNotes({
    String? userId,
    NoteStatus? status,
    NoteType? type,
    List<String>? tags,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      final notesJson = prefs.getString('notes') ?? '[]';
      final notesList = (jsonDecode(notesJson) as List)
          .map((json) => Note.fromJson(json))
          .toList();
      
      // Apply filters
      var filteredNotes = notesList.where((note) {
        if (userId != null && note.userId != userId) return false;
        if (status != null && note.status != status) return false;
        if (type != null && note.type != type) return false;
        if (tags != null && !tags.any((tag) => note.tags.contains(tag))) return false;
        if (searchQuery != null && 
            !note.title.toLowerCase().contains(searchQuery.toLowerCase()) &&
            !note.content.toLowerCase().contains(searchQuery.toLowerCase())) return false;
        return true;
      }).toList();

      // Apply pagination
      if (offset != null && offset > 0) {
        filteredNotes = filteredNotes.skip(offset).toList();
      }
      if (limit != null && limit > 0) {
        filteredNotes = filteredNotes.take(limit).toList();
      }
      
      return Right(filteredNotes);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get notes: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final notes = await getNotes();
      final notesList = notes.fold(
        (failure) => <Note>[],
        (notes) => notes,
      );
      
      notesList.add(note);
      await _saveNotesToLocal(notesList);
      
      return Right(note);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create note: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final notes = await getNotes();
      final notesList = notes.fold(
        (failure) => <Note>[],
        (notes) => notes,
      );
      
      final index = notesList.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        notesList[index] = note;
        await _saveNotesToLocal(notesList);
        return Right(note);
      } else {
        return Left(NotFoundFailure(message: 'Note not found'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update note: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String noteId) async {
    try {
      final notes = await getNotes();
      final notesList = notes.fold(
        (failure) => <Note>[],
        (notes) => notes,
      );
      
      notesList.removeWhere((note) => note.id == noteId);
      await _saveNotesToLocal(notesList);
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete note: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String noteId) async {
    try {
      final notes = await getNotes();
      return notes.fold(
        (failure) => Left(failure),
        (notesList) {
          try {
            final note = notesList.firstWhere((note) => note.id == noteId);
            return Right(note);
          } catch (e) {
            return Left(NotFoundFailure(message: 'Note not found: $noteId'));
          }
        },
      );
    } catch (e) {
      return Left(NotFoundFailure(message: 'Note not found: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> restoreNote(String noteId) async {
    try {
      final noteResult = await getNoteById(noteId);
      return noteResult.fold(
        (failure) => Left(failure),
        (note) async {
          final restoredNote = note.copyWith(
            status: NoteStatus.draft,
            deletedAt: null,
            updatedAt: DateTime.now(),
          );
          return await updateNote(restoredNote);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to restore note: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> permanentlyDeleteNote(String noteId) async {
    return await deleteNote(noteId);
  }

  @override
  Future<Either<Failure, List<Note>>> batchUpdateNotes(
    List<String> noteIds,
    Map<String, dynamic> updates,
  ) async {
    try {
      final List<Note> updatedNotes = [];
      for (final noteId in noteIds) {
        final noteResult = await getNoteById(noteId);
        await noteResult.fold(
          (failure) => null,
          (note) async {
            // Apply updates to note - simplified implementation
            final updatedNote = note.copyWith(
              updatedAt: DateTime.now(),
              // Add more field updates based on the updates map as needed
            );
            final updateResult = await updateNote(updatedNote);
            updateResult.fold(
              (failure) => null,
              (note) => updatedNotes.add(note),
            );
          },
        );
      }
      return Right(updatedNotes);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to batch update notes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes({
    required String query,
    String? userId,
    List<String>? tags,
    NoteType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await getNotes(
      userId: userId,
      type: type,
      tags: tags,
      searchQuery: query,
    );
  }

  @override
  Future<Either<Failure, List<String>>> getNoteTags(String? userId) async {
    try {
      final notes = await getNotes(userId: userId);
      return notes.fold(
        (failure) => Left(failure),
        (notesList) {
          final allTags = <String>{};
          for (final note in notesList) {
            allTags.addAll(note.tags);
          }
          return Right(allTags.toList());
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get tags: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncNotes() async {
    // Simplified implementation - in real app would sync with server
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> exportNotes({
    required List<String> noteIds,
    required String format,
  }) async {
    try {
      final List<Note> notesToExport = [];
      for (final noteId in noteIds) {
        final noteResult = await getNoteById(noteId);
        noteResult.fold(
          (failure) => null,
          (note) => notesToExport.add(note),
        );
      }
      
      // Simplified export - just return JSON string
      final exportData = jsonEncode(notesToExport.map((note) => note.toJson()).toList());
      return Right(exportData);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to export notes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> importNotes({
    required String filePath,
    required String format,
  }) async {
    try {
      // Simplified implementation
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to import notes: $e'));
    }
  }

  Future<void> _saveNotesToLocal(List<Note> notes) async {
    final notesJson = jsonEncode(notes.map((note) => note.toJson()).toList());
    await prefs.setString('notes', notesJson);
  }
}
