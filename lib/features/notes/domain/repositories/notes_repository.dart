import '../entities/note.dart';

abstract class NotesRepository {
  Future<void> saveNote(String userId, Note note);
  Future<List<Note>> getNotes(String userId);
}
