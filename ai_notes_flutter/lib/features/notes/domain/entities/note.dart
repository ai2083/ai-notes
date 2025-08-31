import 'package:equatable/equatable.dart';

enum NoteType {
  text,
  audio,
  video,
  image,
  pdf,
  mixed,
}

enum NoteStatus {
  draft,
  published,
  archived,
  deleted,
}

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final NoteType type;
  final NoteStatus status;
  final List<String> tags;
  final List<String> attachments;
  final String? summary;
  final String? transcript;
  final List<String> keywords;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, dynamic>? metadata;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.status,
    required this.tags,
    required this.attachments,
    this.summary,
    this.transcript,
    required this.keywords,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.metadata,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    NoteType? type,
    NoteStatus? status,
    List<String>? tags,
    List<String>? attachments,
    String? summary,
    String? transcript,
    List<String>? keywords,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      summary: summary ?? this.summary,
      transcript: transcript ?? this.transcript,
      keywords: keywords ?? this.keywords,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.name,
      'status': status.name,
      'tags': tags,
      'attachments': attachments,
      'summary': summary,
      'transcript': transcript,
      'keywords': keywords,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: NoteType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NoteType.text,
      ),
      status: NoteStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => NoteStatus.draft,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      attachments: List<String>.from(json['attachments'] ?? []),
      summary: json['summary'] as String?,
      transcript: json['transcript'] as String?,
      keywords: List<String>.from(json['keywords'] ?? []),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        status,
        tags,
        attachments,
        summary,
        transcript,
        keywords,
        userId,
        createdAt,
        updatedAt,
        deletedAt,
        metadata,
      ];
}
