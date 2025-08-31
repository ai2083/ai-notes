import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String displayName,
    required String confirmPassword,
  }) async {
    // 验证输入
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      throw ArgumentError('All fields are required');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (password != confirmPassword) {
      throw ArgumentError('Passwords do not match');
    }

    if (password.length < 8) {
      throw ArgumentError('Password must be at least 8 characters');
    }

    if (!_isStrongPassword(password)) {
      throw ArgumentError('Password must contain at least one uppercase letter, one lowercase letter, and one number');
    }

    if (displayName.length < 2) {
      throw ArgumentError('Display name must be at least 2 characters');
    }

    // 检查邮箱是否已注册
    final isRegistered = await repository.isEmailRegistered(email);
    if (isRegistered) {
      throw ArgumentError('Email is already registered');
    }

    return await repository.signUpWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
      displayName: displayName.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    // 至少包含一个大写字母、一个小写字母和一个数字
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(password);
  }
}
