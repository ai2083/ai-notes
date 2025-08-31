import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String subscriptionType; // free, pro, team
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.createdAt,
    this.lastLoginAt,
    this.subscriptionType = 'free',
    this.isEmailVerified = false,
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? subscriptionType,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'subscriptionType': subscriptionType,
      'isEmailVerified': isEmailVerified,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      avatarUrl: map['avatarUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'])
          : null,
      subscriptionType: map['subscriptionType'] ?? 'free',
      isEmailVerified: map['isEmailVerified'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        createdAt,
        lastLoginAt,
        subscriptionType,
        isEmailVerified,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, subscriptionType: $subscriptionType)';
  }
}
