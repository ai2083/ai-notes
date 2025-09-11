import 'package:equatable/equatable.dart';

enum QuizQuestionType {
  multipleChoice,
  trueFalse,
  fillInTheBlank,
  shortAnswer,
}

enum QuizDifficulty {
  easy,
  medium,
  hard,
}

enum QuizQuestionStatus {
  active,
  archived,
  deleted,
}

class QuizOption extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;

  const QuizOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  QuizOption copyWith({
    String? id,
    String? text,
    bool? isCorrect,
  }) {
    return QuizOption(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
    };
  }

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }

  @override
  List<Object?> get props => [id, text, isCorrect];

  @override
  String toString() {
    return 'QuizOption{id: $id, text: $text, isCorrect: $isCorrect}';
  }
}

class Quiz extends Equatable {
  final String id;
  final String setId;  // 属于哪个QuizSet
  final String question;
  final QuizQuestionType type;
  final List<QuizOption> options; // 选择题选项
  final String? correctAnswer; // 填空题或简答题的正确答案
  final String? explanation; // 答案解释
  final QuizDifficulty difficulty;
  final QuizQuestionStatus status;
  final int points; // 题目分值
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const Quiz({
    required this.id,
    required this.setId,
    required this.question,
    required this.type,
    this.options = const [],
    this.correctAnswer,
    this.explanation,
    this.difficulty = QuizDifficulty.medium,
    this.status = QuizQuestionStatus.active,
    this.points = 1,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  Quiz copyWith({
    String? id,
    String? setId,
    String? question,
    QuizQuestionType? type,
    List<QuizOption>? options,
    String? correctAnswer,
    String? explanation,
    QuizDifficulty? difficulty,
    QuizQuestionStatus? status,
    int? points,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Quiz(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      question: question ?? this.question,
      type: type ?? this.type,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      points: points ?? this.points,
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
      'type': type.name,
      'options': options.map((option) => option.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'difficulty': difficulty.name,
      'status': status.name,
      'points': points,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      setId: json['setId'] as String,
      question: json['question'] as String,
      type: QuizQuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuizQuestionType.multipleChoice,
      ),
      options: (json['options'] as List<dynamic>?)
          ?.map((option) => QuizOption.fromJson(option as Map<String, dynamic>))
          .toList() ?? [],
      correctAnswer: json['correctAnswer'] as String?,
      explanation: json['explanation'] as String?,
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => QuizDifficulty.medium,
      ),
      status: QuizQuestionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QuizQuestionStatus.active,
      ),
      points: json['points'] as int? ?? 1,
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
    type,
    options,
    correctAnswer,
    explanation,
    difficulty,
    status,
    points,
    userId,
    createdAt,
    updatedAt,
    metadata,
  ];

  @override
  String toString() {
    return 'Quiz{id: $id, setId: $setId, question: $question, type: $type, '
        'options: $options, correctAnswer: $correctAnswer, explanation: $explanation, '
        'difficulty: $difficulty, status: $status, points: $points, userId: $userId, '
        'createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata}';
  }
}
