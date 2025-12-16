import 'package:http/http.dart' as http;
import '../security/token_storage.dart';
import '../security/auth_api.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final TokenStorage storage;
  final AuthApi authApi;

  AuthHttpClient(this._inner, {required this.storage, required this.authApi});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) {
      // Try refresh once
      final refreshed = await authApi.refresh();
      if (refreshed) {
        final newToken = await storage.getAccessToken();
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
          return await _inner.send(request);
        }
      }
    }

    return response;
  }
}
