import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/note.dart';
import '../models/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemoteDataSource {
  DatabaseReference _userRef() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated - cannot access remote notes');
    }
    final path = 'notes/$uid';
    return FirebaseDatabase.instance.ref(path);
  }

  Future<void> saveNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    await _userRef().push().set(model.toJson());
  }

  Future<List<Note>> getNotes() async {
    final snapshot = await _userRef().get();

    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map<Note>((entry) {
      return NoteModel.fromJson(
        Map<String, dynamic>.from(entry.value),
      ).toEntity();
    }).toList();
  }

  Future<void> deleteNote(Note note) async {
    final snapshot = await _userRef().get();
    if (!snapshot.exists) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    for (final entry in data.entries) {
      final model = NoteModel.fromJson(
        Map<String, dynamic>.from(entry.value),
      );

      if (model.text == note.text &&
          model.lat == note.lat &&
          model.lng == note.lng) {
        await _userRef().child(entry.key).remove();
        break;
      }
    }
  }
}
