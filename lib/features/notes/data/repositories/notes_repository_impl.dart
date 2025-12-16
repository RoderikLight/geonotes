import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/remote_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final RemoteDataSource remoteDataSource;

  NotesRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> saveNote(String userId, Note note) {
    return remoteDataSource.saveNote(userId, note);
  }

  @override
  Future<List<Note>> getNotes(String userId) {
    return remoteDataSource.getNotes(userId);
  }
}
