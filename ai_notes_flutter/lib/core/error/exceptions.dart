/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'ServerException: $message';
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'CacheException: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'NetworkException: $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'AuthException: $message';
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'ValidationException: $message';
}

/// File-related exceptions
class FileException extends AppException {
  const FileException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'FileException: $message';
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'PermissionException: $message';
}

/// Timeout-related exceptions
class TimeoutException extends AppException {
  const TimeoutException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Parse-related exceptions
class ParseException extends AppException {
  const ParseException({
    required String message,
    int? code,
  }) : super(message: message, code: code);

  @override
  String toString() => 'ParseException: $message';
}
