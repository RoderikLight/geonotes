import 'package:flutter/material.dart';
import '../../../../injection_container.dart';
import '../../../core/security/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _signInAnon() async {
    setState(() => loading = true);
    try {
      await sl<AuthService>().signInAnonymously();
    } catch (e) {
      setState(() { error = 'Anonymous sign-in failed'; loading = false; });
    }
  }

  Future<void> _signInEmail() async {
    setState(() => loading = true);
    try {
      await sl<AuthService>().signInWithEmail(_email.text.trim(), _password.text);
    } catch (e) {
      setState(() { error = 'Email sign-in failed'; loading = false; });
    }
  }

  Future<void> _signUpEmail() async {
    setState(() => loading = true);
    try {
      await sl<AuthService>().registerWithEmail(_email.text.trim(), _password.text);
    } catch (e) {
      setState(() { error = 'Email sign-up failed'; loading = false; });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: loading ? null : _signInEmail, child: const Text('Sign in')),
            ElevatedButton(onPressed: loading ? null : _signUpEmail, child: const Text('Create account')),
            const Divider(),
            ElevatedButton(onPressed: loading ? null : _signInAnon, child: const Text('Continue anonymously')),
          ],
        ),
      ),
    );
  }
}
