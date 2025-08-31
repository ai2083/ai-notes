import 'package:flutter_test/flutter_test.dart';
import 'package:ai_notes_flutter/core/error/failures.dart';
import 'package:ai_notes_flutter/core/error/exceptions.dart';

void main() {
  group('Core Error Handling Tests', () {
    group('Failures Tests', () {
      test('should create GeneralFailure with message and code', () {
        // Arrange & Act
        const failure = GeneralFailure(
          message: 'Something went wrong',
          code: 500,
        );

        // Assert
        expect(failure.message, 'Something went wrong');
        expect(failure.code, 500);
        expect(failure, isA<Failure>());
      });

      test('should create NetworkFailure with message only', () {
        // Arrange & Act
        const failure = NetworkFailure(message: 'No internet connection');

        // Assert
        expect(failure.message, 'No internet connection');
        expect(failure.code, isNull);
        expect(failure, isA<Failure>());
      });

      test('should create AuthFailure with authentication error', () {
        // Arrange & Act
        const failure = AuthFailure(
          message: 'Invalid credentials',
          code: 401,
        );

        // Assert
        expect(failure.message, 'Invalid credentials');
        expect(failure.code, 401);
        expect(failure, isA<Failure>());
      });

      test('should create ServerFailure with server error', () {
        // Arrange & Act
        const failure = ServerFailure(
          message: 'Internal server error',
          code: 500,
        );

        // Assert
        expect(failure.message, 'Internal server error');
        expect(failure.code, 500);
        expect(failure, isA<Failure>());
      });

      test('should create ValidationFailure with validation error', () {
        // Arrange & Act
        const failure = ValidationFailure(
          message: 'Email format is invalid',
          code: 400,
        );

        // Assert
        expect(failure.message, 'Email format is invalid');
        expect(failure.code, 400);
        expect(failure, isA<Failure>());
      });

      test('should create FileFailure with file operation error', () {
        // Arrange & Act
        const failure = FileFailure(
          message: 'File not found',
          code: 404,
        );

        // Assert
        expect(failure.message, 'File not found');
        expect(failure.code, 404);
        expect(failure, isA<Failure>());
      });

      test('should create CacheFailure with cache error', () {
        // Arrange & Act
        const failure = CacheFailure(
          message: 'Cache write failed',
        );

        // Assert
        expect(failure.message, 'Cache write failed');
        expect(failure.code, isNull);
        expect(failure, isA<Failure>());
      });

      test('should create PermissionFailure with permission error', () {
        // Arrange & Act
        const failure = PermissionFailure(
          message: 'Storage permission denied',
          code: 403,
        );

        // Assert
        expect(failure.message, 'Storage permission denied');
        expect(failure.code, 403);
        expect(failure, isA<Failure>());
      });

      test('should create TimeoutFailure with timeout error', () {
        // Arrange & Act
        const failure = TimeoutFailure(
          message: 'Request timeout',
          code: 408,
        );

        // Assert
        expect(failure.message, 'Request timeout');
        expect(failure.code, 408);
        expect(failure, isA<Failure>());
      });

      test('should create ParseFailure with parsing error', () {
        // Arrange & Act
        const failure = ParseFailure(
          message: 'JSON parsing failed',
        );

        // Assert
        expect(failure.message, 'JSON parsing failed');
        expect(failure.code, isNull);
        expect(failure, isA<Failure>());
      });

      test('should support equality comparison', () {
        // Arrange
        const failure1 = NetworkFailure(message: 'No internet');
        const failure2 = NetworkFailure(message: 'No internet');
        const failure3 = NetworkFailure(message: 'Different message');

        // Assert
        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });

      test('should have correct props for equality', () {
        // Arrange
        const failure = ServerFailure(
          message: 'Server error',
          code: 500,
        );

        // Assert
        expect(failure.props, ['Server error', 500]);
      });
    });

    group('Exceptions Tests', () {
      test('should create ServerException with message and code', () {
        // Arrange & Act
        const exception = ServerException(
          message: 'Server error occurred',
          code: 500,
        );

        // Assert
        expect(exception.message, 'Server error occurred');
        expect(exception.code, 500);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('ServerException'));
      });

      test('should create CacheException with message only', () {
        // Arrange & Act
        const exception = CacheException(message: 'Cache operation failed');

        // Assert
        expect(exception.message, 'Cache operation failed');
        expect(exception.code, isNull);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('CacheException'));
      });

      test('should create NetworkException with network error', () {
        // Arrange & Act
        const exception = NetworkException(
          message: 'Network unreachable',
          code: 0,
        );

        // Assert
        expect(exception.message, 'Network unreachable');
        expect(exception.code, 0);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('NetworkException'));
      });

      test('should create AuthException with auth error', () {
        // Arrange & Act
        const exception = AuthException(
          message: 'Authentication failed',
          code: 401,
        );

        // Assert
        expect(exception.message, 'Authentication failed');
        expect(exception.code, 401);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('AuthException'));
      });

      test('should create ValidationException with validation error', () {
        // Arrange & Act
        const exception = ValidationException(
          message: 'Validation failed',
          code: 400,
        );

        // Assert
        expect(exception.message, 'Validation failed');
        expect(exception.code, 400);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('ValidationException'));
      });

      test('should create FileException with file error', () {
        // Arrange & Act
        const exception = FileException(
          message: 'File operation failed',
          code: 404,
        );

        // Assert
        expect(exception.message, 'File operation failed');
        expect(exception.code, 404);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('FileException'));
      });

      test('should create PermissionException with permission error', () {
        // Arrange & Act
        const exception = PermissionException(
          message: 'Permission denied',
          code: 403,
        );

        // Assert
        expect(exception.message, 'Permission denied');
        expect(exception.code, 403);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('PermissionException'));
      });

      test('should create TimeoutException with timeout error', () {
        // Arrange & Act
        const exception = TimeoutException(
          message: 'Operation timeout',
          code: 408,
        );

        // Assert
        expect(exception.message, 'Operation timeout');
        expect(exception.code, 408);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('TimeoutException'));
      });

      test('should create ParseException with parsing error', () {
        // Arrange & Act
        const exception = ParseException(
          message: 'Parsing failed',
        );

        // Assert
        expect(exception.message, 'Parsing failed');
        expect(exception.code, isNull);
        expect(exception, isA<AppException>());
        expect(exception.toString(), contains('ParseException'));
      });

      test('should implement Exception interface', () {
        // Arrange & Act
        const exception = ServerException(message: 'Test');

        // Assert
        expect(exception, isA<Exception>());
      });
    });

    group('Error Message Tests', () {
      test('should create appropriate error messages for common scenarios', () {
        // Network errors
        const networkError = NetworkFailure(
          message: 'Please check your internet connection and try again',
        );
        expect(networkError.message, contains('internet connection'));

        // Authentication errors
        const authError = AuthFailure(
          message: 'Invalid email or password. Please try again.',
        );
        expect(authError.message, contains('Invalid email or password'));

        // Validation errors
        const validationError = ValidationFailure(
          message: 'Email address format is invalid',
        );
        expect(validationError.message, contains('Email address format'));

        // Server errors
        const serverError = ServerFailure(
          message: 'Server is temporarily unavailable. Please try again later.',
        );
        expect(serverError.message, contains('Server is temporarily unavailable'));
      });

      test('should handle error codes correctly', () {
        const errors = [
          NetworkFailure(message: 'Network error', code: 0),
          AuthFailure(message: 'Unauthorized', code: 401),
          ValidationFailure(message: 'Bad request', code: 400),
          PermissionFailure(message: 'Forbidden', code: 403),
          ServerFailure(message: 'Not found', code: 404),
          TimeoutFailure(message: 'Timeout', code: 408),
          ServerFailure(message: 'Internal error', code: 500),
        ];

        for (final error in errors) {
          expect(error.code, isA<int>());
          expect(error.message, isA<String>());
          expect(error.message.isNotEmpty, isTrue);
        }
      });
    });

    group('Error Handling Utilities Tests', () {
      test('should categorize errors by type', () {
        final errors = [
          const NetworkFailure(message: 'Network error'),
          const AuthFailure(message: 'Auth error'),
          const ValidationFailure(message: 'Validation error'),
          const ServerFailure(message: 'Server error'),
          const CacheFailure(message: 'Cache error'),
        ];

        // Test error categorization
        final networkErrors = errors.whereType<NetworkFailure>().toList();
        final authErrors = errors.whereType<AuthFailure>().toList();
        final validationErrors = errors.whereType<ValidationFailure>().toList();
        final serverErrors = errors.whereType<ServerFailure>().toList();
        final cacheErrors = errors.whereType<CacheFailure>().toList();

        expect(networkErrors.length, 1);
        expect(authErrors.length, 1);
        expect(validationErrors.length, 1);
        expect(serverErrors.length, 1);
        expect(cacheErrors.length, 1);
      });

      test('should determine if error is retryable', () {
        // Retryable errors
        expect(_isRetryableError(const NetworkFailure(message: 'Network error')), isTrue);
        expect(_isRetryableError(const TimeoutFailure(message: 'Timeout')), isTrue);
        expect(_isRetryableError(const ServerFailure(message: 'Server error', code: 500)), isTrue);

        // Non-retryable errors
        expect(_isRetryableError(const AuthFailure(message: 'Auth error')), isFalse);
        expect(_isRetryableError(const ValidationFailure(message: 'Validation error')), isFalse);
        expect(_isRetryableError(const PermissionFailure(message: 'Permission error')), isFalse);
      });

      test('should get user-friendly error messages', () {
        const errors = [
          NetworkFailure(message: 'Network connection failed'),
          AuthFailure(message: 'Invalid credentials'),
          ValidationFailure(message: 'Email format invalid'),
          ServerFailure(message: 'Internal server error'),
        ];

        for (final error in errors) {
          final userMessage = _getUserFriendlyMessage(error);
          expect(userMessage, isA<String>());
          expect(userMessage.isNotEmpty, isTrue);
          // User-friendly messages should not contain technical terms
          expect(userMessage.toLowerCase(), isNot(contains('exception')));
          expect(userMessage.toLowerCase(), isNot(contains('null')));
        }
      });
    });
  });
}

// Helper functions for error handling
bool _isRetryableError(Failure failure) {
  return failure is NetworkFailure ||
      failure is TimeoutFailure ||
      (failure is ServerFailure && (failure.code == null || failure.code! >= 500));
}

String _getUserFriendlyMessage(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return '网络连接失败，请检查您的网络设置后重试';
    case AuthFailure:
      return '登录失败，请检查您的邮箱和密码';
    case ValidationFailure:
      return '输入信息有误，请检查后重试';
    case ServerFailure:
      return '服务器暂时无法响应，请稍后重试';
    case CacheFailure:
      return '本地数据访问失败，请重启应用';
    case PermissionFailure:
      return '缺少必要权限，请在设置中允许相关权限';
    case TimeoutFailure:
      return '请求超时，请检查网络后重试';
    case FileFailure:
      return '文件操作失败，请检查存储空间和权限';
    case ParseFailure:
      return '数据解析失败，请重试';
    default:
      return '发生未知错误，请重试';
  }
}
