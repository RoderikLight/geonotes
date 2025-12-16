import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHttpClient extends http.BaseClient {
  final http.Client _inner;

  FirebaseAuthHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }
    return _inner.send(request);
  }
}
