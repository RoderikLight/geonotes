import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/note.dart';
import '../models/note_model.dart';

class RemoteDataSource {
  final DatabaseReference db =
      FirebaseDatabase.instance.refFromURL('https://geonotes-app-667eb-default-rtdb.firebaseio.com/notes');

  Future<void> saveNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    await db.push().set(model.toJson());
  }

  Future<List<Note>> getNotes() async {
    final snapshot = await db.get();

    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map<Note>((entry) {
      return NoteModel.fromJson(
        Map<String, dynamic>.from(entry.value),
      ).toEntity();
    }).toList();
  }

  Future<void> deleteNote(Note note) async {
    final snapshot = await db.get();
    if (!snapshot.exists) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    for (final entry in data.entries) {
      final model = NoteModel.fromJson(
        Map<String, dynamic>.from(entry.value),
      );

      if (model.text == note.text &&
          model.lat == note.lat &&
          model.lng == note.lng) {
        await db.child(entry.key).remove();
        break;
      }
    }
  }
}
