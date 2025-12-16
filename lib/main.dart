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
      theme: ThemeData(primarySwatch: Colors.blue),
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
      // Inicializar Firebase solo si no hay apps
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
          print('Firebase inicializado');
        } else {
          print('Firebase ya estaba inicializado: ${Firebase.apps.map((a) => a.name).toList()}');
        }
      } on FirebaseException catch (e) {
        if (e.code == 'duplicate-app') {
          print('Firebase ya estaba inicializado, usando instancia existente');
        } else {
          rethrow;
        }
      }

      // Inicialización de inyección de dependencias
      init();

      // Comprobar permisos de ubicación
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage = 'Servicio de localización no habilitado.';
        setState(() {});
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        errorMessage =
            'Permisos de ubicación denegados permanentemente. Actívelos en ajustes.';
        setState(() {});
        return;
      }

      // Navegar a la pantalla principal según autenticación
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
              if (snapshot.hasData) {
                return const NotesView();
              }
              return const LoginView();
            },
          ),
        ),
      );
    } catch (e, st) {
      print('Error al inicializar la app: $e');
      print('Stack trace:\n$st');
      errorMessage = 'Error al inicializar la app: $e';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: errorMessage != null
            ? Text(errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Cargando GeoNotes...',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
      ),
    );
  }
}
