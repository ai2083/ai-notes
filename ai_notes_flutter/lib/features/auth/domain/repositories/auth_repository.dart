import '../entities/user.dart';

abstract class AuthRepository {
  /// 获取当前用户
  Future<User?> getCurrentUser();
  
  /// 用户认证状态流
  Stream<User?> get authStateChanges;
  
  /// 使用邮箱密码登录
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  /// 使用邮箱密码注册
  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });
  
  /// 使用Google登录
  Future<User> signInWithGoogle();
  
  /// 使用Apple登录
  Future<User> signInWithApple();
  
  /// 发送邮箱验证
  Future<void> sendEmailVerification();
  
  /// 发送密码重置邮件
  Future<void> sendPasswordResetEmail(String email);
  
  /// 更新用户资料
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  });
  
  /// 更改密码
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// 删除账号
  Future<void> deleteAccount();
  
  /// 登出
  Future<void> signOut();
  
  /// 检查邮箱是否已注册
  Future<bool> isEmailRegistered(String email);
  
  /// 重新认证（用于敏感操作）
  Future<void> reauthenticate(String password);
}
