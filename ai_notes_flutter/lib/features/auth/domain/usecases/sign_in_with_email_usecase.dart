import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) async {
    // 验证输入
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return await repository.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
