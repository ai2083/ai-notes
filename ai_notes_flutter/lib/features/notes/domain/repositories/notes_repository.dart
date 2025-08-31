import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note.dart';

abstract class NotesRepository {
  /// 获取用户所有笔记
  Future<Either<Failure, List<Note>>> getNotes({
    String? userId,
    NoteStatus? status,
    NoteType? type,
    List<String>? tags,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// 根据ID获取笔记
  Future<Either<Failure, Note>> getNoteById(String noteId);

  /// 创建新笔记
  Future<Either<Failure, Note>> createNote(Note note);

  /// 更新笔记
  Future<Either<Failure, Note>> updateNote(Note note);

  /// 删除笔记
  Future<Either<Failure, void>> deleteNote(String noteId);

  /// 恢复已删除的笔记
  Future<Either<Failure, Note>> restoreNote(String noteId);

  /// 永久删除笔记
  Future<Either<Failure, void>> permanentlyDeleteNote(String noteId);

  /// 批量操作笔记
  Future<Either<Failure, List<Note>>> batchUpdateNotes(
    List<String> noteIds,
    Map<String, dynamic> updates,
  );

  /// 搜索笔记
  Future<Either<Failure, List<Note>>> searchNotes({
    required String query,
    String? userId,
    List<String>? tags,
    NoteType? type,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// 获取笔记标签
  Future<Either<Failure, List<String>>> getNoteTags(String? userId);

  /// 同步笔记（本地与远程）
  Future<Either<Failure, void>> syncNotes();

  /// 导出笔记
  Future<Either<Failure, String>> exportNotes({
    required List<String> noteIds,
    required String format, // pdf, markdown, json
  });

  /// 导入笔记
  Future<Either<Failure, List<Note>>> importNotes({
    required String filePath,
    required String format,
  });
}
