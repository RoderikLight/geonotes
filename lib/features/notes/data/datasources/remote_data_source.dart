import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RemoteDataSource {
  Future<void> addNote({
    required String text,
    required double lat,
    required double lng,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref('notes');

  @override
  Future<void> addNote({
    required String text,
    required double lat,
    required double lng,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db.child(uid).push().set({
      'text': text,
      'lat': lat,
      'lng': lng,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
