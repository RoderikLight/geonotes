import '../../domain/entities/note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/save_note.dart';
import '../../domain/usecases/delete_note.dart';

abstract class NotesViewContract {
  void showNotes(List<Note> notes);
  void showError(String message);
}

class NotesPresenter {
  final GetNotes getNotes;
  final SaveNote saveNote;
  final DeleteNote deleteNote;

  NotesViewContract? view;

  NotesPresenter({
    required this.getNotes,
    required this.saveNote,
    required this.deleteNote,
  });

  void attachView(NotesViewContract view) {
    this.view = view;
  }

  void detachView() {
    view = null;
  }

  Future<void> loadNotes() async {
    try {
      final notes = await getNotes();
      view?.showNotes(notes);
    } catch (e) {
      view?.showError('Error loading notes');
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await saveNote(note);
      await loadNotes();
    } catch (e) {
      view?.showError('Error saving note');
    }
  }

  Future<void> removeNote(Note note) async {
    try {
      await deleteNote(note);
      await loadNotes();
    } catch (e) {
      view?.showError('Error deleting note');
    }
  }
}
