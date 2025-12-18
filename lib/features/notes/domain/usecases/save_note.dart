import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class SaveNote {
  final NotesRepository repository;

  SaveNote(this.repository);

  Future<void> call(Note note) async {
    await repository.saveNote(note);
  }
}
