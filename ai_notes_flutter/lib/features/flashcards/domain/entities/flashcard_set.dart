import 'package:equatable/equatable.dart';

class FlashcardSet extends Equatable {
  final String id;
  final String title;
  final String? description;
  final List<String> flashcardIds;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const FlashcardSet({
    required this.id,
    required this.title,
    this.description,
    this.flashcardIds = const [],
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  FlashcardSet copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? flashcardIds,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return FlashcardSet(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      flashcardIds: flashcardIds ?? this.flashcardIds,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'flashcardIds': flashcardIds,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FlashcardSet.fromJson(Map<String, dynamic> json) {
    return FlashcardSet(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      flashcardIds: (json['flashcardIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    flashcardIds,
    userId,
    createdAt,
    updatedAt,
    metadata,
  ];

  @override
  String toString() {
    return 'FlashcardSet{id: $id, title: $title, description: $description, '
        'flashcardIds: $flashcardIds, userId: $userId, createdAt: $createdAt, '
        'updatedAt: $updatedAt, metadata: $metadata}';
  }
}
