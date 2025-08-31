import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ai_notes_flutter/features/auth/domain/entities/user.dart';
import 'package:ai_notes_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:ai_notes_flutter/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:ai_notes_flutter/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:ai_notes_flutter/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:ai_notes_flutter/core/error/failures.dart';

// Generate mocks for repository only
@GenerateMocks([AuthRepository])
import 'auth_test.mocks.dart';

void main() {
  group('Authentication Use Cases Tests', () {
    late MockAuthRepository mockAuthRepository;
    late SignInWithEmailUsecase signInUsecase;
    late SignUpWithEmailUsecase signUpUsecase;
    late SignOutUsecase signOutUsecase;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      signInUsecase = SignInWithEmailUsecase(mockAuthRepository);
      signUpUsecase = SignUpWithEmailUsecase(mockAuthRepository);
      signOutUsecase = SignOutUsecase(mockAuthRepository);
    });

    group('SignInWithEmailUsecase', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';
      final testUser = User(
        id: '123',
        email: testEmail,
        name: 'Test User',
        createdAt: DateTime.now(),
      );

      test('should return User when sign in is successful', () async {
        // Arrange
        when(mockAuthRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        )).thenAnswer((_) async => Right(testUser));

        // Act
        final result = await signInUsecase(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        expect(result, Right(testUser));
        verify(mockAuthRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        )).called(1);
      });

      test('should return AuthFailure when credentials are invalid', () async {
        // Arrange
        const failure = AuthFailure(message: 'Invalid credentials');
        when(mockAuthRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        )).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await signInUsecase(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        expect(result, const Left(failure));
        verify(mockAuthRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        )).called(1);
      });

      test('should return NetworkFailure when there is no internet', () async {
        // Arrange
        const failure = NetworkFailure(message: 'No internet connection');
        when(mockAuthRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        )).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await signInUsecase(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('SignUpWithEmailUsecase', () {
      const testEmail = 'newuser@example.com';
      const testPassword = 'password123';
      const testName = 'New User';
      final testUser = User(
        id: '456',
        email: testEmail,
        name: testName,
        createdAt: DateTime.now(),
      );

      test('should return User when sign up is successful', () async {
        // Arrange
        when(mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        )).thenAnswer((_) async => Right(testUser));

        // Act
        final result = await signUpUsecase(
          email: testEmail,
          password: testPassword,
          name: testName,
        );

        // Assert
        expect(result, Right(testUser));
        verify(mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        )).called(1);
      });

      test('should return AuthFailure when email is already in use', () async {
        // Arrange
        const failure = AuthFailure(message: 'Email already in use');
        when(mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        )).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await signUpUsecase(
          email: testEmail,
          password: testPassword,
          name: testName,
        );

        // Assert
        expect(result, const Left(failure));
      });

      test('should return ValidationFailure for weak password', () async {
        // Arrange
        const failure = ValidationFailure(message: 'Password too weak');
        when(mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: '123',
          name: testName,
        )).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await signUpUsecase(
          email: testEmail,
          password: '123',
          name: testName,
        );

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('SignOutUsecase', () {
      test('should return void when sign out is successful', () async {
        // Arrange
        when(mockAuthRepository.signOut())
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await signOutUsecase();

        // Assert
        expect(result, const Right(null));
        verify(mockAuthRepository.signOut()).called(1);
      });

      test('should return Failure when sign out fails', () async {
        // Arrange
        const failure = GeneralFailure(message: 'Sign out failed');
        when(mockAuthRepository.signOut())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await signOutUsecase();

        // Assert
        expect(result, const Left(failure));
      });
    });
  });

  group('User Entity Tests', () {
    test('should create User with all required fields', () {
      // Arrange & Act
      final user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.createdAt, isA<DateTime>());
    });

    test('should support optional fields', () {
      // Arrange & Act
      final user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/image.jpg',
        bio: 'Test bio',
        preferences: {'theme': 'dark'},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Assert
      expect(user.profileImageUrl, 'https://example.com/image.jpg');
      expect(user.bio, 'Test bio');
      expect(user.preferences, {'theme': 'dark'});
      expect(user.updatedAt, isA<DateTime>());
    });

    test('should create copy with updated fields', () {
      // Arrange
      final originalUser = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
      );

      // Act
      final updatedUser = originalUser.copyWith(
        name: 'Updated Name',
        bio: 'New bio',
      );

      // Assert
      expect(updatedUser.id, originalUser.id);
      expect(updatedUser.email, originalUser.email);
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.bio, 'New bio');
      expect(updatedUser.createdAt, originalUser.createdAt);
    });

    test('should convert to and from JSON', () {
      // Arrange
      final user = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/image.jpg',
        bio: 'Test bio',
        preferences: {'theme': 'dark'},
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );

      // Act
      final json = user.toJson();
      final userFromJson = User.fromJson(json);

      // Assert
      expect(userFromJson.id, user.id);
      expect(userFromJson.email, user.email);
      expect(userFromJson.name, user.name);
      expect(userFromJson.profileImageUrl, user.profileImageUrl);
      expect(userFromJson.bio, user.bio);
      expect(userFromJson.preferences, user.preferences);
      expect(userFromJson.createdAt, user.createdAt);
      expect(userFromJson.updatedAt, user.updatedAt);
    });

    test('should support equality comparison', () {
      // Arrange
      final user1 = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime(2023, 1, 1),
      );

      final user2 = User(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime(2023, 1, 1),
      );

      final user3 = User(
        id: '456',
        email: 'other@example.com',
        name: 'Other User',
        createdAt: DateTime(2023, 1, 1),
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });

  group('Input Validation Tests', () {
    test('should validate email format', () {
      // Valid emails
      expect(_isValidEmail('test@example.com'), isTrue);
      expect(_isValidEmail('user.name@domain.co.uk'), isTrue);
      expect(_isValidEmail('user+tag@example.org'), isTrue);

      // Invalid emails
      expect(_isValidEmail('invalid'), isFalse);
      expect(_isValidEmail('test@'), isFalse);
      expect(_isValidEmail('@example.com'), isFalse);
      expect(_isValidEmail('test.example.com'), isFalse);
    });

    test('should validate password strength', () {
      // Valid passwords
      expect(_isValidPassword('password123'), isTrue);
      expect(_isValidPassword('StrongP@ss1'), isTrue);
      expect(_isValidPassword('12345678'), isTrue);

      // Invalid passwords
      expect(_isValidPassword(''), isFalse);
      expect(_isValidPassword('123'), isFalse);
      expect(_isValidPassword('short'), isFalse);
    });

    test('should validate name format', () {
      // Valid names
      expect(_isValidName('John Doe'), isTrue);
      expect(_isValidName('张三'), isTrue);
      expect(_isValidName('A'), isTrue);

      // Invalid names
      expect(_isValidName(''), isFalse);
      expect(_isValidName('   '), isFalse);
    });
  });
}

// Helper functions for validation (these should match your actual validation logic)
bool _isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool _isValidPassword(String password) {
  return password.isNotEmpty && password.length >= 6;
}

bool _isValidName(String name) {
  return name.trim().isNotEmpty;
}
