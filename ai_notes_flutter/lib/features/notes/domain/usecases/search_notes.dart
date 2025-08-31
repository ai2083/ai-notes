import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class SearchNotes {
  final NotesRepository repository;

  SearchNotes(this.repository);

  Future<Either<Failure, List<Note>>> call({
    required String query,
    String? userId,
    List<String>? tags,
    NoteType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.searchNotes(
      query: query,
      userId: userId,
      tags: tags,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
