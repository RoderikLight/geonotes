import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';

import 'injection_container.dart';
import 'core/security/auth_service.dart';
import 'features/auth/presentation/login_view.dart';
import 'features/notes/presentation/views/note_view.dart';
import 'features/notes/presentation/views/add_note_view.dart';
import 'features/notes/presentation/views/map_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoNotes',

      // 🎨 TEMA GLOBAL
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white,
        ),
      ),

      routes: {
        '/add': (c) => const AddNoteView(),
        '/map': (c) => const MapView(),
        '/login': (c) => const LoginView(),
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBUhdtR614vo6QIIMMhS-oV2GzMbLcBBKo",
            authDomain: "geonotes-app-667eb.firebaseapp.com",
            projectId: "geonotes-app-667eb",
            storageBucket: "geonotes-app-667eb.firebasestorage.app",
            messagingSenderId: "7657832372",
            appId: "1:7657832372:web:c75cd6653e6307a1d37ce1",
            databaseURL:
                "https://geonotes-app-667eb-default-rtdb.firebaseio.com",
          ),
        );
      }

      init();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Servicio de localización no habilitado.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Permisos de ubicación denegados permanentemente.',
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => StreamBuilder<Object?>(
            stream: sl<AuthService>().authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return snapshot.hasData
                  ? const NotesView()
                  : const LoginView();
            },
          ),
        ),
      );
    } catch (e) {
      setState(() => errorMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: errorMessage != null
              ? Card(
                  margin: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on,
                        size: 80, color: Colors.white),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Cargando GeoNotes...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
