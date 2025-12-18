import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/remote_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final RemoteDataSource remoteDataSource;

  NotesRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> saveNote(Note note) async {
    await remoteDataSource.saveNote(note);
  }

  @override
  Future<List<Note>> getNotes() async {
    return await remoteDataSource.getNotes();
  }

  @override
  Future<void> deleteNote(Note note) async {
    await remoteDataSource.deleteNote(note);
  }
}
