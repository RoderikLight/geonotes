import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/remote_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final RemoteDataSource remoteDataSource;

  NotesRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> saveNote(Note note) async {
    await remoteDataSource.addNote(
      text: note.text,
      lat: note.lat,
      lng: note.lng,
    );
  }
}
