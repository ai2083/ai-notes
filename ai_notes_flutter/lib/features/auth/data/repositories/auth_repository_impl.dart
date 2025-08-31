import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<domain.User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    // 从Firestore获取完整用户信息
    final userDoc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      // 如果Firestore中没有用户信息，创建一个基础用户
      return _createDomainUser(firebaseUser, {});
    }

    return _createDomainUser(firebaseUser, userDoc.data()!);
  }

  @override
  Stream<domain.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      return _createDomainUser(
        firebaseUser,
        userDoc.exists ? userDoc.data()! : {},
      );
    });
  }

  @override
  Future<domain.User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Login failed');
      }

      // 更新最后登录时间
      await _updateLastLoginTime(firebaseUser.uid);

      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      return _createDomainUser(
        firebaseUser,
        userDoc.exists ? userDoc.data()! : {},
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<domain.User> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('Registration failed');
      }

      // 更新用户显示名称
      await firebaseUser.updateDisplayName(displayName);

      // 在Firestore中创建用户文档
      final userData = {
        'email': email,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'subscriptionType': 'free',
        'isEmailVerified': false,
      };

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userData);

      // 发送邮箱验证
      await firebaseUser.sendEmailVerification();

      return _createDomainUser(firebaseUser, userData);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<domain.User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Google sign in failed');
      }

      // 检查是否是新用户
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        // 创建用户文档
        final userData = {
          'email': firebaseUser.email!,
          'displayName': firebaseUser.displayName ?? 'User',
          'avatarUrl': firebaseUser.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'subscriptionType': 'free',
          'isEmailVerified': firebaseUser.emailVerified,
        };

        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userData);

        return _createDomainUser(firebaseUser, userData);
      } else {
        // 更新最后登录时间
        await _updateLastLoginTime(firebaseUser.uid);

        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        return _createDomainUser(
          firebaseUser,
          userDoc.exists ? userDoc.data()! : {},
        );
      }
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<domain.User> signInWithApple() async {
    // TODO: 实现Apple登录
    throw UnimplementedError('Apple sign in not implemented yet');
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // 更新Firebase Auth用户信息
    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (avatarUrl != null) {
      await user.updatePhotoURL(avatarUrl);
    }

    // 更新Firestore用户文档
    final updateData = <String, dynamic>{};
    if (displayName != null) updateData['displayName'] = displayName;
    if (avatarUrl != null) updateData['avatarUrl'] = avatarUrl;

    if (updateData.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(updateData);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // 重新认证
    await reauthenticate(currentPassword);

    // 更新密码
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // 删除Firestore用户文档
    await _firestore
        .collection('users')
        .doc(user.uid)
        .delete();

    // 删除Firebase Auth用户
    await user.delete();
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    try {
      final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> reauthenticate(String password) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final credential = firebase_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  // 私有方法

  domain.User _createDomainUser(
    firebase_auth.User firebaseUser,
    Map<String, dynamic> firestoreData,
  ) {
    return domain.User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? firestoreData['displayName'] ?? 'User',
      avatarUrl: firebaseUser.photoURL ?? firestoreData['avatarUrl'],
      createdAt: _timestampToDateTime(firestoreData['createdAt']) ?? DateTime.now(),
      lastLoginAt: _timestampToDateTime(firestoreData['lastLoginAt']),
      subscriptionType: firestoreData['subscriptionType'] ?? 'free',
      isEmailVerified: firebaseUser.emailVerified,
    );
  }

  DateTime? _timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return null;
  }

  Future<void> _updateLastLoginTime(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  Exception _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Wrong password');
      case 'email-already-in-use':
        return Exception('Email is already registered');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('User account has been disabled');
      case 'too-many-requests':
        return Exception('Too many requests. Please try again later');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
