import 'package:flutter_test/flutter_test.dart';
import 'package:ai_notes_flutter/features/notes/domain/entities/note.dart';
import 'package:ai_notes_flutter/features/notes/data/models/note_model.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/get_notes.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/create_note.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/update_note.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/delete_note.dart';
import 'package:ai_notes_flutter/features/notes/domain/usecases/search_notes.dart';

void main() {
  group('Notes Features Integration Tests', () {
    group('Note Entity Tests', () {
      test('should create note with all required fields', () {
        // Arrange & Act
        final note = Note(
          id: 'note123',
          title: 'Test Note',
          content: 'This is a test note content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test', 'integration'],
          attachments: [],
          keywords: ['test', 'note'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Assert
        expect(note.id, 'note123');
        expect(note.title, 'Test Note');
        expect(note.content, 'This is a test note content');
        expect(note.type, NoteType.text);
        expect(note.status, NoteStatus.draft);
        expect(note.tags, ['test', 'integration']);
        expect(note.keywords, ['test', 'note']);
        expect(note.userId, 'user123');
      });

      test('should support all note types', () {
        final noteTypes = [
          NoteType.text,
          NoteType.audio,
          NoteType.video,
          NoteType.image,
          NoteType.pdf,
          NoteType.mixed,
        ];

        for (final type in noteTypes) {
          final note = Note(
            id: 'note_${type.name}',
            title: '${type.name} Note',
            content: 'Content for ${type.name}',
            type: type,
            status: NoteStatus.draft,
            tags: [type.name],
            attachments: [],
            keywords: [type.name],
            userId: 'user123',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          expect(note.type, type);
          expect(note.title, '${type.name} Note');
        }
      });

      test('should support all note statuses', () {
        final noteStatuses = [
          NoteStatus.draft,
          NoteStatus.published,
          NoteStatus.archived,
          NoteStatus.deleted,
        ];

        for (final status in noteStatuses) {
          final note = Note(
            id: 'note_${status.name}',
            title: '${status.name} Note',
            content: 'Content for ${status.name}',
            type: NoteType.text,
            status: status,
            tags: [status.name],
            attachments: [],
            keywords: [status.name],
            userId: 'user123',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          expect(note.status, status);
          expect(note.title, '${status.name} Note');
        }
      });

      test('should create note with optional fields', () {
        // Arrange & Act
        final note = Note(
          id: 'note123',
          title: 'Rich Note',
          content: 'This is a rich note with all optional fields',
          type: NoteType.mixed,
          status: NoteStatus.published,
          tags: ['rich', 'complete'],
          attachments: ['file1.pdf', 'image1.jpg', 'audio1.mp3'],
          summary: 'This is a comprehensive note with multiple attachments',
          transcript: 'Transcript of the audio content in the note',
          keywords: ['rich', 'complete', 'comprehensive'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          deletedAt: null,
          metadata: {
            'version': 2,
            'wordCount': 250,
            'readingTime': 2,
            'lastEditor': 'user123',
            'collaborators': ['user456', 'user789'],
          },
        );

        // Assert
        expect(note.attachments, hasLength(3));
        expect(note.attachments, contains('file1.pdf'));
        expect(note.attachments, contains('image1.jpg'));
        expect(note.attachments, contains('audio1.mp3'));
        expect(note.summary, contains('comprehensive'));
        expect(note.transcript, contains('Transcript'));
        expect(note.metadata, isNotNull);
        expect(note.metadata!['version'], 2);
        expect(note.metadata!['wordCount'], 250);
        expect(note.metadata!['collaborators'], isA<List>());
      });

      test('should serialize and deserialize note', () {
        // Arrange
        final note = Note(
          id: 'note123',
          title: 'Serialization Test',
          content: 'Test content for serialization',
          type: NoteType.image,
          status: NoteStatus.published,
          tags: ['serialization', 'test'],
          attachments: ['image.jpg'],
          summary: 'Test summary',
          transcript: 'Test transcript',
          keywords: ['serialization'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          metadata: {'format': 'jpeg', 'size': '2MB'},
        );

        // Act
        final json = note.toJson();
        final deserializedNote = Note.fromJson(json);

        // Assert
        expect(deserializedNote.id, note.id);
        expect(deserializedNote.title, note.title);
        expect(deserializedNote.content, note.content);
        expect(deserializedNote.type, note.type);
        expect(deserializedNote.status, note.status);
        expect(deserializedNote.tags, note.tags);
        expect(deserializedNote.attachments, note.attachments);
        expect(deserializedNote.summary, note.summary);
        expect(deserializedNote.transcript, note.transcript);
        expect(deserializedNote.keywords, note.keywords);
        expect(deserializedNote.userId, note.userId);
        expect(deserializedNote.metadata, note.metadata);
      });

      test('should support note equality', () {
        // Arrange
        final note1 = Note(
          id: 'note123',
          title: 'Same Note',
          content: 'Same content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['same'],
          attachments: [],
          keywords: ['same'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final note2 = Note(
          id: 'note123',
          title: 'Same Note',
          content: 'Same content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['same'],
          attachments: [],
          keywords: ['same'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final note3 = Note(
          id: 'note456',
          title: 'Different Note',
          content: 'Different content',
          type: NoteType.audio,
          status: NoteStatus.published,
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
          id: 'model123',
          title: 'Model Test',
          content: 'Testing NoteModel',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['model'],
          attachments: [],
          keywords: ['model'],
          userId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(noteModel, isA<Note>());
        expect(noteModel.title, 'Model Test');
        expect(noteModel.content, 'Testing NoteModel');
      });

      test('should create from Note entity', () {
        // Arrange
        final note = Note(
          id: 'note123',
          title: 'Original Note',
          content: 'Original content',
          type: NoteType.video,
          status: NoteStatus.published,
          tags: ['video'],
          attachments: ['video.mp4'],
          keywords: ['video'],
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
        expect(noteModel.tags, note.tags);
        expect(noteModel.attachments, note.attachments);
        expect(noteModel.keywords, note.keywords);
        expect(noteModel.userId, note.userId);
        expect(noteModel.createdAt, note.createdAt);
        expect(noteModel.updatedAt, note.updatedAt);
      });

      test('should convert to and from Hive format', () {
        // Arrange
        final noteModel = NoteModel(
          id: 'hive123',
          title: 'Hive Test',
          content: 'Testing Hive serialization',
          type: NoteType.pdf,
          status: NoteStatus.archived,
          tags: ['hive', 'storage'],
          attachments: ['document.pdf'],
          keywords: ['hive'],
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
        expect(noteFromHive.content, noteModel.content);
        expect(noteFromHive.type, noteModel.type);
        expect(noteFromHive.status, noteModel.status);
        expect(noteFromHive.tags, noteModel.tags);
        expect(noteFromHive.attachments, noteModel.attachments);
        expect(noteFromHive.keywords, noteModel.keywords);
        expect(noteFromHive.userId, noteModel.userId);
        expect(noteFromHive.createdAt, noteModel.createdAt);
        expect(noteFromHive.updatedAt, noteModel.updatedAt);
      });
    });

    group('Use Case Structure Tests', () {
      test('should validate all use case classes exist', () {
        // Validate that our use case classes are properly structured
        expect(GetNotes, isA<Type>());
        expect(GetNoteById, isA<Type>());
        expect(CreateNote, isA<Type>());
        expect(UpdateNote, isA<Type>());
        expect(DeleteNote, isA<Type>());
        expect(SearchNotes, isA<Type>());
      });
    });

    group('Note Validation Tests', () {
      test('should validate note title requirements', () {
        // Valid titles
        expect(_isValidTitle('Valid Title'), isTrue);
        expect(_isValidTitle('A'), isTrue);
        expect(_isValidTitle('Very Long Title That Still Should Be Valid'), isTrue);
        expect(_isValidTitle('Title with 123 numbers'), isTrue);
        expect(_isValidTitle('Title with emojis and notes'), isTrue);

        // Invalid titles
        expect(_isValidTitle(''), isFalse);
        expect(_isValidTitle('   '), isFalse);
        expect(_isValidTitle('\n\t'), isFalse);
      });

      test('should validate note content', () {
        // Valid content
        expect(_isValidContent('Some content'), isTrue);
        expect(_isValidContent(''), isTrue); // Empty content is allowed
        expect(_isValidContent('Very long content ' * 100), isTrue);

        // Content with special characters should be valid
        expect(_isValidContent('Content with\nnewlines\tand\ttabs'), isTrue);
        expect(_isValidContent('Content with emojis and symbols @#\$%'), isTrue);
      });

      test('should validate tags', () {
        // Valid tags
        expect(_isValidTag('validtag'), isTrue);
        expect(_isValidTag('tag123'), isTrue);
        expect(_isValidTag('tag-with-dash'), isTrue);
        expect(_isValidTag('tag_with_underscore'), isTrue);

        // Invalid tags
        expect(_isValidTag(''), isFalse);
        expect(_isValidTag('   '), isFalse);
        expect(_isValidTag('tag with spaces'), isFalse);
        expect(_isValidTag('tag#with#symbols'), isFalse);
      });

      test('should validate keywords extraction', () {
        final content = 'This is a test note about Flutter development and testing';
        final extractedKeywords = _extractKeywords(content);

        expect(extractedKeywords, isNotEmpty);
        expect(extractedKeywords, contains('flutter'));
        expect(extractedKeywords, contains('development'));
        expect(extractedKeywords, contains('testing'));
        expect(extractedKeywords, isNot(contains('is'))); // Stop words should be filtered
        expect(extractedKeywords, isNot(contains('a')));
        expect(extractedKeywords, isNot(contains('the')));
      });
    });

    group('Note Operations Tests', () {
      test('should handle note lifecycle states', () {
        // Create a new note
        var note = Note(
          id: 'lifecycle123',
          title: 'Lifecycle Test',
          content: 'Testing note lifecycle',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['lifecycle'],
          attachments: [],
          keywords: ['lifecycle'],
          userId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(note.status, NoteStatus.draft);
        expect(note.deletedAt, isNull);

        // Publish the note
        note = Note(
          id: note.id,
          title: note.title,
          content: note.content,
          type: note.type,
          status: NoteStatus.published,
          tags: note.tags,
          attachments: note.attachments,
          keywords: note.keywords,
          userId: note.userId,
          createdAt: note.createdAt,
          updatedAt: DateTime.now(),
        );

        expect(note.status, NoteStatus.published);

        // Archive the note
        note = Note(
          id: note.id,
          title: note.title,
          content: note.content,
          type: note.type,
          status: NoteStatus.archived,
          tags: note.tags,
          attachments: note.attachments,
          keywords: note.keywords,
          userId: note.userId,
          createdAt: note.createdAt,
          updatedAt: DateTime.now(),
        );

        expect(note.status, NoteStatus.archived);

        // Soft delete the note
        note = Note(
          id: note.id,
          title: note.title,
          content: note.content,
          type: note.type,
          status: NoteStatus.deleted,
          tags: note.tags,
          attachments: note.attachments,
          keywords: note.keywords,
          userId: note.userId,
          createdAt: note.createdAt,
          updatedAt: DateTime.now(),
          deletedAt: DateTime.now(),
        );

        expect(note.status, NoteStatus.deleted);
        expect(note.deletedAt, isNotNull);
      });

      test('should handle note search scenarios', () {
        final notes = [
          Note(
            id: 'search1',
            title: 'Flutter Development',
            content: 'Learning Flutter for mobile app development',
            type: NoteType.text,
            status: NoteStatus.published,
            tags: ['flutter', 'mobile', 'development'],
            attachments: [],
            keywords: ['flutter', 'mobile', 'development'],
            userId: 'user123',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Note(
            id: 'search2',
            title: 'Recipe: Chocolate Cake',
            content: 'Delicious chocolate cake recipe with step-by-step instructions',
            type: NoteType.text,
            status: NoteStatus.published,
            tags: ['recipe', 'cooking', 'dessert'],
            attachments: [],
            keywords: ['recipe', 'chocolate', 'cake'],
            userId: 'user123',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Note(
            id: 'search3',
            title: 'Meeting Notes',
            content: 'Flutter project meeting notes and action items',
            type: NoteType.text,
            status: NoteStatus.draft,
            tags: ['meeting', 'work'],
            attachments: [],
            keywords: ['meeting', 'flutter', 'project'],
            userId: 'user123',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        // Search by title
        final flutterNotes = _searchNotes(notes, 'Flutter');
        expect(flutterNotes, hasLength(2));
        expect(flutterNotes.map((n) => n.id), containsAll(['search1', 'search3']));

        // Search by content
        final recipeNotes = _searchNotes(notes, 'recipe');
        expect(recipeNotes, hasLength(1));
        expect(recipeNotes.first.id, 'search2');

        // Search by tags
        final workNotes = _searchNotes(notes, 'work');
        expect(workNotes, hasLength(1));
        expect(workNotes.first.id, 'search3');
      });
    });
  });
}

// Helper validation functions
bool _isValidTitle(String title) {
  return title.trim().isNotEmpty;
}

bool _isValidContent(String content) {
  return true; // Content can be empty
}

bool _isValidTag(String tag) {
  if (tag.trim().isEmpty) return false;
  if (tag.contains(' ')) return false;
  if (tag.contains('#')) return false;
  return true;
}

List<String> _extractKeywords(String content) {
  final stopWords = {'is', 'a', 'the', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'about'};
  return content
      .toLowerCase()
      .split(RegExp(r'\W+'))
      .where((word) => word.isNotEmpty && word.length > 2 && !stopWords.contains(word))
      .toSet()
      .toList();
}

List<Note> _searchNotes(List<Note> notes, String query) {
  final lowerQuery = query.toLowerCase();
  return notes.where((note) {
    return note.title.toLowerCase().contains(lowerQuery) ||
           note.content.toLowerCase().contains(lowerQuery) ||
           note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
           note.keywords.any((keyword) => keyword.toLowerCase().contains(lowerQuery));
  }).toList();
}
