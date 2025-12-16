import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Future<User?> signInAnonymously() async {
    final result = await _firebaseAuth.signInAnonymously();
    return result.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
