import '../../domain/entities/note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/save_note.dart';

abstract class NotesView {
  void showNotes(List<Note> notes);
  void showError(String message);
}

class NotesPresenter {
  final GetNotes getNotes;
  final SaveNote saveNote;
  NotesView? view;

  NotesPresenter({
    required this.getNotes,
    required this.saveNote,
  });

  void attachView(NotesView view) {
    this.view = view;
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
      loadNotes();
    } catch (e) {
      view?.showError('Error saving note');
    }
  }
}
