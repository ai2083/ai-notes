import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

// 通用错误
class GeneralFailure extends Failure {
  const GeneralFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 网络错误
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 服务器错误
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 缓存错误
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 认证错误
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 权限错误
class PermissionFailure extends Failure {
  const PermissionFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 验证错误
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 文件错误
class FileFailure extends Failure {
  const FileFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 数据解析错误
class ParseFailure extends Failure {
  const ParseFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 超时错误
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// 未找到错误
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}
