import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/note.dart';
import '../models/note_model.dart';

abstract class RemoteDataSource {
  Future<void> saveNote(String userId, Note note);
  Future<List<Note>> getNotes(String userId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref().child('notes');

  @override
  Future<void> saveNote(String userId, Note note) async {
    final noteModel = NoteModel.fromEntity(note);
    await _db.child(userId).push().set(noteModel.toJson());
  }

  @override
  Future<List<Note>> getNotes(String userId) async {
    final snapshot = await _db.child(userId).get();

    if (!snapshot.exists) return [];

    final data = snapshot.value as Map;
    return data.values.map<Note>((e) {
      return NoteModel.fromJson(
        Map<String, dynamic>.from(e),
      ).toEntity();
    }).toList();
  }
}
