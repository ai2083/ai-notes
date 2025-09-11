import 'package:equatable/equatable.dart';

enum QuizType {
  multipleChoice,
  trueFalse,
  fillInTheBlank,
  shortAnswer,
  mixed,
}

enum QuizStatus {
  draft,
  active,
  completed,
  archived,
  deleted,
}

class QuizSet extends Equatable {
  final String id;
  final String title;
  final String? description;
  final QuizType type;
  final QuizStatus status;
  final List<String> quizIds;
  final int timeLimit; // 时间限制（分钟），0表示无限制
  final bool shuffleQuestions;
  final bool showCorrectAnswers;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const QuizSet({
    required this.id,
    required this.title,
    this.description,
    this.type = QuizType.mixed,
    this.status = QuizStatus.draft,
    this.quizIds = const [],
    this.timeLimit = 0,
    this.shuffleQuestions = false,
    this.showCorrectAnswers = true,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  QuizSet copyWith({
    String? id,
    String? title,
    String? description,
    QuizType? type,
    QuizStatus? status,
    List<String>? quizIds,
    int? timeLimit,
    bool? shuffleQuestions,
    bool? showCorrectAnswers,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return QuizSet(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      quizIds: quizIds ?? this.quizIds,
      timeLimit: timeLimit ?? this.timeLimit,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      showCorrectAnswers: showCorrectAnswers ?? this.showCorrectAnswers,
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
      'type': type.name,
      'status': status.name,
      'quizIds': quizIds,
      'timeLimit': timeLimit,
      'shuffleQuestions': shuffleQuestions,
      'showCorrectAnswers': showCorrectAnswers,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory QuizSet.fromJson(Map<String, dynamic> json) {
    return QuizSet(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: QuizType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuizType.mixed,
      ),
      status: QuizStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QuizStatus.draft,
      ),
      quizIds: (json['quizIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      timeLimit: json['timeLimit'] as int? ?? 0,
      shuffleQuestions: json['shuffleQuestions'] as bool? ?? false,
      showCorrectAnswers: json['showCorrectAnswers'] as bool? ?? true,
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
    type,
    status,
    quizIds,
    timeLimit,
    shuffleQuestions,
    showCorrectAnswers,
    userId,
    createdAt,
    updatedAt,
    metadata,
  ];

  @override
  String toString() {
    return 'QuizSet{id: $id, title: $title, description: $description, type: $type, '
        'status: $status, quizIds: $quizIds, timeLimit: $timeLimit, '
        'shuffleQuestions: $shuffleQuestions, showCorrectAnswers: $showCorrectAnswers, '
        'userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata}';
  }
}
