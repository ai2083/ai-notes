import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNotes {
  final NotesRepository repository;

  GetNotes(this.repository);

  Future<Either<Failure, List<Note>>> call({
    String? userId,
    NoteStatus? status,
    NoteType? type,
    List<String>? tags,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    return await repository.getNotes(
      userId: userId,
      status: status,
      type: type,
      tags: tags,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
}
