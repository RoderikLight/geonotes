import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class AuthServiceTestable extends AuthService {
  final FirebaseAuth firebaseAuth;

  AuthServiceTestable(this.firebaseAuth);

  @override
  FirebaseAuth get auth => firebaseAuth;
}
