import 'package:equatable/equatable.dart';

enum FlashcardDifficulty {
  easy,
  medium,
  hard,
}

enum FlashcardStatus {
  active,
  archived,
  deleted,
}

class Flashcard extends Equatable {
  final String id;
  final String setId;  // 属于哪个FlashcardSet
  final String question;
  final String answer;
  final String? hint;
  final FlashcardDifficulty difficulty;
  final FlashcardStatus status;
  final int reviewCount;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Flashcard({
    required this.id,
    required this.setId,
    required this.question,
    required this.answer,
    this.hint,
    this.difficulty = FlashcardDifficulty.medium,
    this.status = FlashcardStatus.active,
    this.reviewCount = 0,
    this.lastReviewedAt,
    this.nextReviewAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  Flashcard copyWith({
    String? id,
    String? setId,
    String? question,
    String? answer,
    String? hint,
    FlashcardDifficulty? difficulty,
    FlashcardStatus? status,
    int? reviewCount,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Flashcard(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      hint: hint ?? this.hint,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      reviewCount: reviewCount ?? this.reviewCount,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setId': setId,
      'question': question,
      'answer': answer,
      'hint': hint,
      'difficulty': difficulty.name,
      'status': status.name,
      'reviewCount': reviewCount,
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      'nextReviewAt': nextReviewAt?.toIso8601String(),
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      setId: json['setId'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      hint: json['hint'] as String?,
      difficulty: FlashcardDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => FlashcardDifficulty.medium,
      ),
      status: FlashcardStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FlashcardStatus.active,
      ),
      reviewCount: json['reviewCount'] as int? ?? 0,
      lastReviewedAt: json['lastReviewedAt'] != null
          ? DateTime.parse(json['lastReviewedAt'] as String)
          : null,
      nextReviewAt: json['nextReviewAt'] != null
          ? DateTime.parse(json['nextReviewAt'] as String)
          : null,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    setId,
    question,
    answer,
    hint,
    difficulty,
    status,
    reviewCount,
    lastReviewedAt,
    nextReviewAt,
    userId,
    createdAt,
    updatedAt,
    metadata,
  ];

  @override
  String toString() {
    return 'Flashcard{id: $id, setId: $setId, question: $question, answer: $answer, '
        'hint: $hint, difficulty: $difficulty, status: $status, reviewCount: $reviewCount, '
        'lastReviewedAt: $lastReviewedAt, nextReviewAt: $nextReviewAt, userId: $userId, '
        'createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata}';
  }
}
