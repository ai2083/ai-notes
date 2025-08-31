import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';

// 依赖注入
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>((ref) {
  return SignInWithEmailUseCase(ref.read(authRepositoryProvider));
});

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>((ref) {
  return SignUpWithEmailUseCase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

// 认证状态
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.authStateChanges;
});

// 当前用户
final currentUserProvider = FutureProvider<User?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.getCurrentUser();
});

// 认证状态管理
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, user: $user, error: $error)';
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithEmailUseCase _signInUseCase;
  final SignUpWithEmailUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final AuthRepository _repository;

  AuthNotifier({
    required SignInWithEmailUseCase signInUseCase,
    required SignUpWithEmailUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthRepository repository,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _repository = repository,
        super(const AuthState());

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _signInUseCase(
        email: email,
        password: password,
      );
      
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _signUpUseCase(
        email: email,
        password: password,
        displayName: displayName,
        confirmPassword: confirmPassword,
      );
      
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _repository.signInWithGoogle();
      
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _signOutUseCase();
      
      state = state.copyWith(
        isLoading: false,
        user: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signInUseCase: ref.read(signInWithEmailUseCaseProvider),
    signUpUseCase: ref.read(signUpWithEmailUseCaseProvider),
    signOutUseCase: ref.read(signOutUseCaseProvider),
    repository: ref.read(authRepositoryProvider),
  );
});
