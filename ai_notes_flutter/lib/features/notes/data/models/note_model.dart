import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required String id,
    required String title,
    required String content,
    required NoteType type,
    required NoteStatus status,
    required List<String> tags,
    required List<String> attachments,
    String? summary,
    String? transcript,
    required List<String> keywords,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          title: title,
          content: content,
          type: type,
          status: status,
          tags: tags,
          attachments: attachments,
          summary: summary,
          transcript: transcript,
          keywords: keywords,
          userId: userId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          metadata: metadata,
        );

  factory NoteModel.fromNote(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      type: note.type,
      status: note.status,
      tags: note.tags,
      attachments: note.attachments,
      summary: note.summary,
      transcript: note.transcript,
      keywords: note.keywords,
      userId: note.userId,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      deletedAt: note.deletedAt,
      metadata: note.metadata,
    );
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
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
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      deletedAt: json['deletedAt'] != null
          ? (json['deletedAt'] as Timestamp).toDate()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
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
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'metadata': metadata,
    };
  }

  Map<String, dynamic> toHiveJson() {
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

  factory NoteModel.fromHiveJson(Map<String, dynamic> json) {
    return NoteModel(
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
}
