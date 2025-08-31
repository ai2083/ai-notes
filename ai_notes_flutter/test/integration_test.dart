import 'package:flutter_test/flutter_test.dart';
import 'package:ai_notes_flutter/features/notes/domain/entities/note.dart';
import 'package:ai_notes_flutter/features/auth/domain/entities/user.dart' as auth_user;
import 'package:ai_notes_flutter/features/notes/data/models/note_model.dart';
import 'package:ai_notes_flutter/core/error/failures.dart';
import 'package:ai_notes_flutter/core/error/exceptions.dart';

void main() {
  group('Implemented Features Integration Tests', () {
    group('User Entity Tests', () {
      test('should create user entity with all fields', () {
        // Arrange & Act
        final user = auth_user.User(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          createdAt: DateTime(2023, 1, 1),
          lastLoginAt: DateTime(2023, 1, 2),
          subscriptionType: 'pro',
          isEmailVerified: true,
        );

        // Assert
        expect(user.id, 'user123');
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'Test User');
        expect(user.avatarUrl, 'https://example.com/avatar.jpg');
        expect(user.createdAt, DateTime(2023, 1, 1));
        expect(user.lastLoginAt, DateTime(2023, 1, 2));
        expect(user.subscriptionType, 'pro');
        expect(user.isEmailVerified, true);
      });

      test('should support user entity equality', () {
        // Arrange
        final user1 = auth_user.User(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime(2023, 1, 1),
        );

        final user2 = auth_user.User(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime(2023, 1, 1),
        );

        final user3 = auth_user.User(
          id: 'user456',
          email: 'other@example.com',
          displayName: 'Other User',
          createdAt: DateTime(2023, 1, 1),
        );

        // Assert
        expect(user1, equals(user2));
        expect(user1, isNot(equals(user3)));
      });

      test('should serialize user to and from Map', () {
        // Arrange
        final user = auth_user.User(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          createdAt: DateTime(2023, 1, 1),
          lastLoginAt: DateTime(2023, 1, 2),
          subscriptionType: 'team',
          isEmailVerified: true,
        );

        // Act
        final map = user.toMap();
        final userFromMap = auth_user.User.fromMap(map);

        // Assert
        expect(userFromMap.id, user.id);
        expect(userFromMap.email, user.email);
        expect(userFromMap.displayName, user.displayName);
        expect(userFromMap.avatarUrl, user.avatarUrl);
        expect(userFromMap.createdAt, user.createdAt);
        expect(userFromMap.lastLoginAt, user.lastLoginAt);
        expect(userFromMap.subscriptionType, user.subscriptionType);
        expect(userFromMap.isEmailVerified, user.isEmailVerified);
      });

      test('should create user copy with updated fields', () {
        // Arrange
        final originalUser = auth_user.User(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Original Name',
          createdAt: DateTime(2023, 1, 1),
          subscriptionType: 'free',
        );

        // Act
        final updatedUser = originalUser.copyWith(
          displayName: 'Updated Name',
          avatarUrl: 'https://example.com/new-avatar.jpg',
          lastLoginAt: DateTime(2023, 1, 2),
          subscriptionType: 'pro',
          isEmailVerified: true,
        );

        // Assert
        expect(updatedUser.id, originalUser.id);
        expect(updatedUser.email, originalUser.email);
        expect(updatedUser.displayName, 'Updated Name');
        expect(updatedUser.avatarUrl, 'https://example.com/new-avatar.jpg');
        expect(updatedUser.createdAt, originalUser.createdAt);
        expect(updatedUser.lastLoginAt, DateTime(2023, 1, 2));
        expect(updatedUser.subscriptionType, 'pro');
        expect(updatedUser.isEmailVerified, true);
      });

      test('should handle default values correctly', () {
        // Arrange & Act
        final user = auth_user.User(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          createdAt: DateTime(2023, 1, 1),
        );

        // Assert default values
        expect(user.avatarUrl, isNull);
        expect(user.lastLoginAt, isNull);
        expect(user.subscriptionType, 'free');
        expect(user.isEmailVerified, false);
      });

      test('should handle subscription types', () {
        // Test different subscription types
        final freeUser = auth_user.User(
          id: 'user1',
          email: 'free@example.com',
          displayName: 'Free User',
          createdAt: DateTime.now(),
          subscriptionType: 'free',
        );

        final proUser = auth_user.User(
          id: 'user2',
          email: 'pro@example.com',
          displayName: 'Pro User',
          createdAt: DateTime.now(),
          subscriptionType: 'pro',
        );

        final teamUser = auth_user.User(
          id: 'user3',
          email: 'team@example.com',
          displayName: 'Team User',
          createdAt: DateTime.now(),
          subscriptionType: 'team',
        );

        expect(freeUser.subscriptionType, 'free');
        expect(proUser.subscriptionType, 'pro');
        expect(teamUser.subscriptionType, 'team');
      });
    });

    group('Note Entity Tests', () {
      test('should create note entity with all required fields', () {
        // Arrange & Act
        final note = Note(
          id: 'note123',
          title: 'Test Note',
          content: 'This is test content for the note',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['test', 'example', 'unit-test'],
          attachments: [],
          keywords: ['test', 'note', 'content'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Assert
        expect(note.id, 'note123');
        expect(note.title, 'Test Note');
        expect(note.content, 'This is test content for the note');
        expect(note.type, NoteType.text);
        expect(note.status, NoteStatus.draft);
        expect(note.tags, ['test', 'example', 'unit-test']);
        expect(note.keywords, ['test', 'note', 'content']);
        expect(note.userId, 'user123');
      });

      test('should support all note types and statuses', () {
        // Test Note Types
        expect(NoteType.values, hasLength(6));
        expect(NoteType.values, contains(NoteType.text));
        expect(NoteType.values, contains(NoteType.audio));
        expect(NoteType.values, contains(NoteType.video));
        expect(NoteType.values, contains(NoteType.image));
        expect(NoteType.values, contains(NoteType.pdf));
        expect(NoteType.values, contains(NoteType.mixed));

        // Test Note Statuses
        expect(NoteStatus.values, hasLength(4));
        expect(NoteStatus.values, contains(NoteStatus.draft));
        expect(NoteStatus.values, contains(NoteStatus.published));
        expect(NoteStatus.values, contains(NoteStatus.archived));
        expect(NoteStatus.values, contains(NoteStatus.deleted));
      });

      test('should create note with optional fields', () {
        // Arrange & Act
        final note = Note(
          id: 'note123',
          title: 'Audio Note',
          content: 'Transcribed content from audio',
          type: NoteType.audio,
          status: NoteStatus.published,
          tags: ['audio', 'transcription'],
          attachments: ['audio1.mp3', 'transcript.txt'],
          summary: 'This is an audio note with transcription',
          transcript: 'The full transcript of the audio content...',
          keywords: ['audio', 'transcription', 'content'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          deletedAt: null,
          metadata: {
            'duration': 120,
            'fileSize': '5MB',
            'format': 'mp3',
            'quality': 'high'
          },
        );

        // Assert
        expect(note.attachments, ['audio1.mp3', 'transcript.txt']);
        expect(note.summary, 'This is an audio note with transcription');
        expect(note.transcript, isNotNull);
        expect(note.transcript!.contains('transcript'), isTrue);
        expect(note.metadata, isNotNull);
        expect(note.metadata!['duration'], 120);
        expect(note.metadata!['format'], 'mp3');
      });

      test('should serialize note to and from JSON', () {
        // Arrange
        final note = Note(
          id: 'note123',
          title: 'Test Note',
          content: 'Test content',
          type: NoteType.mixed,
          status: NoteStatus.published,
          tags: ['test', 'mixed'],
          attachments: ['file1.pdf', 'image1.jpg'],
          summary: 'Mixed content note',
          transcript: 'Some transcript',
          keywords: ['mixed', 'content'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 2),
          metadata: {'version': 2},
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

      test('should support note equality comparison', () {
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
          id: 'note123',
          title: 'Test Note Model',
          content: 'Model content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['model', 'test'],
          attachments: [],
          keywords: ['model'],
          userId: 'user123',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        // Assert
        expect(noteModel, isA<Note>());
        expect(noteModel.title, 'Test Note Model');
        expect(noteModel.type, NoteType.text);
      });

      test('should create from Note entity', () {
        // Arrange
        final note = Note(
          id: 'note123',
          title: 'Original Note',
          content: 'Original content',
          type: NoteType.image,
          status: NoteStatus.published,
          tags: ['image'],
          attachments: ['image1.jpg'],
          keywords: ['image'],
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
      });

      test('should convert to Hive JSON format', () {
        // Arrange
        final noteModel = NoteModel(
          id: 'note123',
          title: 'Hive Note',
          content: 'Content for Hive storage',
          type: NoteType.pdf,
          status: NoteStatus.archived,
          tags: ['hive', 'storage'],
          attachments: ['document.pdf'],
          keywords: ['hive', 'pdf'],
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

    group('Error Handling Integration Tests', () {
      test('should handle different failure types correctly', () {
        // Create various failure types
        const networkFailure = NetworkFailure(
          message: '网络连接失败',
          code: 0,
        );
        
        const authFailure = AuthFailure(
          message: '认证失败',
          code: 401,
        );
        
        const validationFailure = ValidationFailure(
          message: '输入验证失败',
          code: 400,
        );

        // Test failure properties
        expect(networkFailure.message, '网络连接失败');
        expect(networkFailure.code, 0);
        expect(authFailure.message, '认证失败');
        expect(authFailure.code, 401);
        expect(validationFailure.message, '输入验证失败');
        expect(validationFailure.code, 400);

        // Test inheritance
        expect(networkFailure, isA<Failure>());
        expect(authFailure, isA<Failure>());
        expect(validationFailure, isA<Failure>());
      });

      test('should handle different exception types correctly', () {
        // Create various exception types
        const serverException = ServerException(
          message: '服务器错误',
          code: 500,
        );
        
        const cacheException = CacheException(
          message: '缓存操作失败',
        );
        
        const fileException = FileException(
          message: '文件操作失败',
          code: 404,
        );

        // Test exception properties
        expect(serverException.message, '服务器错误');
        expect(serverException.code, 500);
        expect(cacheException.message, '缓存操作失败');
        expect(cacheException.code, isNull);
        expect(fileException.message, '文件操作失败');
        expect(fileException.code, 404);

        // Test inheritance
        expect(serverException, isA<AppException>());
        expect(cacheException, isA<AppException>());
        expect(fileException, isA<AppException>());
        expect(serverException, isA<Exception>());
      });
    });

    group('Data Validation Integration Tests', () {
      test('should validate complex email formats', () {
        const validEmails = [
          'user@example.com',
          'user.name@example.com',
          'user+tag@example.com',
          'user123@example123.com',
          'user@subdomain.example.com',
          'user@example.co.uk',
          'a@b.co',
        ];

        const invalidEmails = [
          '',
          'invalid',
          'user@',
          '@example.com',
          'user@example',
          'user.example.com',
          'user@.com',
          'user@com',
          'user space@example.com',
        ];

        for (final email in validEmails) {
          expect(_isValidEmail(email), isTrue, reason: 'Should validate: $email');
        }

        for (final email in invalidEmails) {
          expect(_isValidEmail(email), isFalse, reason: 'Should invalidate: $email');
        }
      });

      test('should validate password requirements', () {
        const validPasswords = [
          'password123',
          'Password1',
          'StrongP@ss!',
          '123456',  // Minimum length
          'abcdefghijklmnop',  // Long password
        ];

        const invalidPasswords = [
          '',
          '12345',  // Too short
          'abc',    // Too short
          'a',      // Too short
        ];

        for (final password in validPasswords) {
          expect(_isValidPassword(password), isTrue, reason: 'Should validate: $password');
        }

        for (final password in invalidPasswords) {
          expect(_isValidPassword(password), isFalse, reason: 'Should invalidate: $password');
        }
      });

      test('should validate note data consistency', () {
        // Test valid note configurations
        final validNote = Note(
          id: 'note123',
          title: 'Valid Note',
          content: 'Valid content',
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: ['valid', 'test'],
          attachments: [],
          keywords: ['valid'],
          userId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(validNote.id.isNotEmpty, isTrue);
        expect(validNote.title.isNotEmpty, isTrue);
        expect(validNote.userId.isNotEmpty, isTrue);
        expect(validNote.createdAt.isBefore(DateTime.now().add(Duration(seconds: 1))), isTrue);
        expect(validNote.updatedAt.isAfter(validNote.createdAt.subtract(Duration(seconds: 1))), isTrue);
      });

      test('should handle edge cases in text processing', () {
        // Test empty and whitespace-only content
        expect(_formatNoteTitle(''), 'Untitled Note');
        expect(_formatNoteTitle('   '), 'Untitled Note');
        expect(_formatNoteTitle('\n\t  \n'), 'Untitled Note');

        // Test single word
        expect(_formatNoteTitle('hello'), 'Hello');
        expect(_formatNoteTitle('  WORLD  '), 'World');

        // Test multiple words with various cases
        expect(_formatNoteTitle('hello WORLD test'), 'Hello World Test');
        expect(_formatNoteTitle('camelCase test'), 'Camelcase Test');
      });

      test('should handle large data sets efficiently', () {
        // Test with large note content
        final largeContent = 'word ' * 1000;  // 1000 words, each 'word ' is 5 chars
        final readingTime = _calculateReadingTime(largeContent);
        
        expect(readingTime, greaterThan(4));  // Should be about 5 minutes (1000/200)
        expect(readingTime, lessThan(10));    // But not unreasonably high

        // Test with large tag list
        final largeTags = List.generate(100, (i) => 'tag$i');
        final note = Note(
          id: 'large-note',
          title: 'Large Note Test',
          content: largeContent,
          type: NoteType.text,
          status: NoteStatus.draft,
          tags: largeTags,
          attachments: [],
          keywords: ['large', 'test'],
          userId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(note.tags.length, 100);
        expect(note.content.length, greaterThan(4500));  // 1000 * 5 chars minus some space
        expect(note.content.length, lessThan(6000));     // Should be around 5000
      });
    });
  });
}

// Helper functions for validation
bool _isValidEmail(String email) {
  if (email.isEmpty) return false;
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
}

bool _isValidPassword(String password) {
  return password.isNotEmpty && password.length >= 6;
}

String _formatNoteTitle(String title) {
  final trimmed = title.trim();
  if (trimmed.isEmpty) return 'Untitled Note';
  
  return trimmed.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

int _calculateReadingTime(String text) {
  if (text.isEmpty) return 0;
  
  const wordsPerMinute = 200;
  final wordCount = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  final minutes = (wordCount / wordsPerMinute).ceil();
  
  return minutes < 1 ? 1 : minutes;
}
