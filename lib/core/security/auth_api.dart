import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class AuthApi {
  final String baseUrl;
  final http.Client client;
  final TokenStorage storage;

  AuthApi({required this.baseUrl, required this.client, required this.storage});

  Future<void> login(String email, String password) async {
    final res = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final access = data['access_token'] as String?;
      final refresh = data['refresh_token'] as String?;
      if (access != null && refresh != null) {
        await storage.saveTokens(access, refresh);
        return;
      }
    }
    throw Exception('Login failed: ${res.statusCode}');
  }

  Future<bool> refresh() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) return false;

    final res = await client.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final access = data['access_token'] as String?;
      final refresh = data['refresh_token'] as String?;
      if (access != null && refresh != null) {
        await storage.saveTokens(access, refresh);
        return true;
      }
    }

    return false;
  }
}
