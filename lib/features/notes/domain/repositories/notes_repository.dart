import '../entities/note.dart';

abstract class NotesRepository {
  Future<void> saveNote(Note note);
}
