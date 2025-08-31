import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ai_notes_flutter/features/notes/domain/entities/note.dart';
import 'package:ai_notes_flutter/features/notes/domain/repositories/notes_repository.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/get_notes.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/create_note.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/update_note.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/delete_note.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/search_notes.dart';
import 'package:ai_notes_flutter/features/notes/data/models/note_model.dart';
import 'package:ai_notes_flutter/core/error/failures.dart';

@GenerateMocks([NotesRepository])
import 'notes_test.mocks.dart';

void main() {
  group('Notes Domain Tests', () {
    late MockNotesRepository mockNotesRepository;
    late GetNotes getNotes;
    late GetNoteById getNoteById;
    late CreateNote createNote;
    late UpdateNote updateNote;
    late DeleteNote deleteNote;
    late SearchNotes searchNotes;

    setUp(() {
      mockNotesRepository = MockNotesRepository();
      getNotes = GetNotes(mockNotesRepository);
      getNoteById = GetNoteById(mockNotesRepository);
      createNote = CreateNote(mockNotesRepository);
      updateNote = UpdateNote(mockNotesRepository);
      deleteNote = DeleteNote(mockNotesRepository);
      searchNotes = SearchNotes(mockNotesRepository);
    });

    group('Note Entity Tests', () {
      test('should create Note with all required fields', () {
        // Arrange & Act
        final note = Note(
          id: '123',
          title: 'Test Note',
          content: 'This is test content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test', 'example'],
          attachments: [],
          keywords: ['test', 'note'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
        );

        // Assert
        expect(note.id, '123');
        expect(note.title, 'Test Note');
        expect(note.content, 'This is test content');
        expect(note.type, NoteType.text);
        expect(note.status, NoteStatus.draft);
        expect(note.tags, ['test', 'example']);
        expect(note.keywords, ['test', 'note']);
        expect(note.userId, 'user123');
      });

      test('should support optional fields', () {
        // Arrange & Act
        final note = Note(
          id: '123',
          title: 'Test Note',
          content: 'This is test content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test'],
          attachments: ['file1.pdf', 'image1.jpg'],
          summary: 'Test summary',
          transcript: 'Test transcript',
          keywords: ['test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          deletedAt: DateTime(2023, 1, 3),
          metadata: {'version': 1, 'source': 'manual'},
        );

        // Assert
        expect(note.attachments, ['file1.pdf', 'image1.jpg']);
        expect(note.summary, 'Test summary');
        expect(note.transcript, 'Test transcript');
        expect(note.deletedAt, DateTime(2023, 1, 3));
        expect(note.metadata, {'version': 1, 'source': 'manual'});
      });

      test('should create copy with updated fields', () {
        // Arrange
        final originalNote = Note(
          id: '123',
          title: 'Original Title',
          content: 'Original content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['original'],
          attachments: [],
          keywords: ['original'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Act
        final updatedNote = originalNote.copyWith(
          title: 'Updated Title',
          status: NoteStatus.published,
          updatedAt: DateTime(2023, 1, 2),
        );

        // Assert
        expect(updatedNote.id, originalNote.id);
        expect(updatedNote.title, 'Updated Title');
        expect(updatedNote.content, originalNote.content);
        expect(updatedNote.status, NoteStatus.published);
        expect(updatedNote.updatedAt, DateTime(2023, 1, 2));
      });

      test('should convert to and from JSON', () {
        // Arrange
        final note = Note(
          id: '123',
          title: 'Test Note',
          content: 'Test content',
          type: NoteType.audio,
          status: NoteStatus.published,
          tags: ['test', 'audio'],
          attachments: ['audio1.mp3'],
          summary: 'Audio note summary',
          transcript: 'Audio transcript',
          keywords: ['audio', 'test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          metadata: {'duration': 120},
        );

        // Act
        final json = note.toJson();
        final noteFromJson = Note.fromJson(json);

        // Assert
        expect(noteFromJson.id, note.id);
        expect(noteFromJson.title, note.title);
        expect(noteFromJson.content, note.content);
        expect(noteFromJson.type, note.type);
        expect(noteFromJson.status, note.status);
        expect(noteFromJson.tags, note.tags);
        expect(noteFromJson.attachments, note.attachments);
        expect(noteFromJson.summary, note.summary);
        expect(noteFromJson.transcript, note.transcript);
        expect(noteFromJson.keywords, note.keywords);
        expect(noteFromJson.userId, note.userId);
        expect(noteFromJson.metadata, note.metadata);
      });

      test('should support equality comparison', () {
        // Arrange
        final note1 = Note(
          id: '123',
          title: 'Test Note',
          content: 'Test content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test'],
          attachments: [],
          keywords: ['test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final note2 = Note(
          id: '123',
          title: 'Test Note',
          content: 'Test content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test'],
          attachments: [],
          keywords: ['test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final note3 = Note(
          id: '456',
          title: 'Different Note',
          content: 'Different content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['different'],
          attachments: [],
          keywords: ['different'],
          userId: 'user456',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Assert
        expect(note1, equals(note2));
        expect(note1, isNot(equals(note3)));
      });
    });

    group('NoteModel Tests', () {
      test('should extend Note entity', () {
        // Arrange & Act
        final noteModel = NoteModel(
          id: '123',
          title: 'Test Note Model',
          content: 'Test content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test'],
          attachments: [],
          keywords: ['test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Assert
        expect(noteModel, isA<Note>());
        expect(noteModel.title, 'Test Note Model');
      });

      test('should create from Note entity', () {
        // Arrange
        final note = Note(
          id: '123',
          title: 'Test Note',
          content: 'Test content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test'],
          attachments: [],
          keywords: ['test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Act
        final noteModel = NoteModel.fromNote(note);

        // Assert
        expect(noteModel.id, note.id);
        expect(noteModel.title, note.title);
        expect(noteModel.content, note.content);
        expect(noteModel.type, note.type);
        expect(noteModel.status, note.status);
      });

      test('should convert to Hive JSON format', () {
        // Arrange
        final noteModel = NoteModel(
          id: '123',
          title: 'Test Note',
          content: 'Test content',
          type: NoteType.video,
          status: NoteStatus.published,
          tags: ['test', 'video'],
          attachments: ['video1.mp4'],
          keywords: ['video', 'test'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
        );

        // Act
        final hiveJson = noteModel.toHiveJson();
        final noteFromHive = NoteModel.fromHiveJson(hiveJson);

        // Assert
        expect(noteFromHive.id, noteModel.id);
        expect(noteFromHive.title, noteModel.title);
        expect(noteFromHive.type, noteModel.type);
        expect(noteFromHive.status, noteModel.status);
        expect(noteFromHive.createdAt, noteModel.createdAt);
        expect(noteFromHive.updatedAt, noteModel.updatedAt);
      });
    });

    group('GetNotes Usecase Tests', () {
      final testNotes = [
        Note(
          id: '1',
          title: 'Note 1',
          content: 'Content 1',
          type: NoteType.text,
          status: NoteStatus.published,
          tags: ['tag1'],
          attachments: [],
          keywords: ['keyword1'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
        Note(
          id: '2',
          title: 'Note 2',
          content: 'Content 2',
          type: NoteType.audio,
          status: NoteStatus.draft,
          tags: ['tag2'],
          attachments: [],
          keywords: ['keyword2'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 2),
          updatedAt: DateTime(2023, 1, 2),
        ),
      ];

      test('should return list of notes when successful', () async {
        // Arrange
        when(mockNotesRepository.getNotes())
            .thenAnswer((_) async => Right(testNotes));

        // Act
        final result = await getNotes();

        // Assert
        expect(result, Right(testNotes));
        verify(mockNotesRepository.getNotes()).called(1);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Server error');
        when(mockNotesRepository.getNotes())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await getNotes();

        // Assert
        expect(result, const Left(failure));
        verify(mockNotesRepository.getNotes()).called(1);
      });

      test('should pass parameters to repository', () async {
        // Arrange
        when(mockNotesRepository.getNotes(
          userId: 'user123',
          status: NoteStatus.published,
          type: NoteType.text,
          tags: ['important'],
          limit: 10,
        )).thenAnswer((_) async => Right(testNotes));

        // Act
        final result = await getNotes(
          userId: 'user123',
          status: NoteStatus.published,
          type: NoteType.text,
          tags: ['important'],
          limit: 10,
        );

        // Assert
        expect(result, Right(testNotes));
        verify(mockNotesRepository.getNotes(
          userId: 'user123',
          status: NoteStatus.published,
          type: NoteType.text,
          tags: ['important'],
          limit: 10,
        )).called(1);
      });
    });

    group('CreateNote Usecase Tests', () {
      final testNote = Note(
        id: '123',
        title: 'New Note',
        content: 'New content',
        type: NoteType.text,
        status: NoteStatus.draft,
        tags: ['new'],
        attachments: [],
        keywords: ['new'],
        userId: 'user123',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );

      test('should return created note when successful', () async {
        // Arrange
        when(mockNotesRepository.createNote(testNote))
            .thenAnswer((_) async => Right(testNote));

        // Act
        final result = await createNote(testNote);

        // Assert
        expect(result, Right(testNote));
        verify(mockNotesRepository.createNote(testNote)).called(1);
      });

      test('should return failure when creation fails', () async {
        // Arrange
        const failure = ValidationFailure(message: 'Invalid note data');
        when(mockNotesRepository.createNote(testNote))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await createNote(testNote);

        // Assert
        expect(result, const Left(failure));
        verify(mockNotesRepository.createNote(testNote)).called(1);
      });
    });

    group('SearchNotes Usecase Tests', () {
      final searchResults = [
        Note(
          id: '1',
          title: 'Search Result 1',
          content: 'Content with search term',
          type: NoteType.text,
          status: NoteStatus.published,
          tags: ['search'],
          attachments: [],
          keywords: ['search'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
      ];

      test('should return search results when successful', () async {
        // Arrange
        const query = 'search term';
        when(mockNotesRepository.searchNotes(
          query: query,
          userId: 'user123',
        )).thenAnswer((_) async => Right(searchResults));

        // Act
        final result = await searchNotes(
          query: query,
          userId: 'user123',
        );

        // Assert
        expect(result, Right(searchResults));
        verify(mockNotesRepository.searchNotes(
          query: query,
          userId: 'user123',
        )).called(1);
      });

      test('should handle empty search results', () async {
        // Arrange
        const query = 'nonexistent term';
        when(mockNotesRepository.searchNotes(query: query))
            .thenAnswer((_) async => const Right([]));

        // Act
        final result = await searchNotes(query: query);

        // Assert
        expect(result, const Right([]));
      });
    });
  });

  group('Note Type and Status Enums Tests', () {
    test('should have correct NoteType values', () {
      expect(NoteType.values.length, 6);
      expect(NoteType.values, contains(NoteType.text));
      expect(NoteType.values, contains(NoteType.audio));
      expect(NoteType.values, contains(NoteType.video));
      expect(NoteType.values, contains(NoteType.image));
      expect(NoteType.values, contains(NoteType.pdf));
      expect(NoteType.values, contains(NoteType.mixed));
    });

    test('should have correct NoteStatus values', () {
      expect(NoteStatus.values.length, 4);
      expect(NoteStatus.values, contains(NoteStatus.draft));
      expect(NoteStatus.values, contains(NoteStatus.published));
      expect(NoteStatus.values, contains(NoteStatus.archived));
      expect(NoteStatus.values, contains(NoteStatus.deleted));
    });

    test('should convert enum to string correctly', () {
      expect(NoteType.text.name, 'text');
      expect(NoteType.audio.name, 'audio');
      expect(NoteStatus.draft.name, 'draft');
      expect(NoteStatus.published.name, 'published');
    });
  });

  group('Notes Validation Tests', () {
    test('should validate note title', () {
      expect(_isValidNoteTitle('Valid Title'), isTrue);
      expect(_isValidNoteTitle('A'), isTrue);
      expect(_isValidNoteTitle(''), isFalse);
      expect(_isValidNoteTitle('   '), isFalse);
    });

    test('should validate note content', () {
      expect(_isValidNoteContent('Some content'), isTrue);
      expect(_isValidNoteContent(''), isTrue); // Empty content is allowed for drafts
    });

    test('should validate note tags', () {
      expect(_isValidNoteTags(['tag1', 'tag2']), isTrue);
      expect(_isValidNoteTags([]), isTrue);
      expect(_isValidNoteTags(['', 'valid']), isFalse);
      expect(_isValidNoteTags(['   ', 'valid']), isFalse);
    });
  });
}

// Helper validation functions
bool _isValidNoteTitle(String title) {
  return title.trim().isNotEmpty;
}

bool _isValidNoteContent(String content) {
  return true; // Content can be empty for drafts
}

bool _isValidNoteTags(List<String> tags) {
  return tags.every((tag) => tag.trim().isNotEmpty);
}
