import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart';
import 'core/security/auth_service.dart';
import 'features/auth/presentation/login_view.dart';
import 'features/notes/presentation/views/note_view.dart';
import 'features/notes/domain/usecases/get_notes.dart';
import 'features/notes/domain/usecases/save_note.dart';
import 'features/notes/domain/usecases/delete_note.dart';
import 'features/notes/presentation/presenter/notes_presenter.dart';
import 'features/notes/presentation/views/add_note_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBUhdtR614vo6QIIMMhS-oV2GzMbLcBBKo",
      authDomain: "geonotes-app-667eb.firebaseapp.com",
      projectId: "geonotes-app-667eb",
      storageBucket: "geonotes-app-667eb.firebasestorage.app",
      messagingSenderId: "7657832372",
      appId: "1:7657832372:web:1:7657832372:web:c75cd6653e6307a1d37ce1", 
      databaseURL: "https://geonotes-app-667eb-default-rtdb.firebaseio.com",
    ),
  );
  init(); // inyección de dependencias
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoNotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/add': (c) => const AddNoteView(),
        '/login': (c) => const LoginView(),
      },
      home: StreamBuilder<Object?>(
        stream: sl<AuthService>().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const NotesView();
          }
          return const LoginView();
        },
      ),
    );
  }
}

class NotesViewScreen extends StatefulWidget {
  const NotesViewScreen({super.key});

  @override
  State<NotesViewScreen> createState() => _NotesViewScreenState();
}

class _NotesViewScreenState extends State<NotesViewScreen>
    implements NotesViewContract {
  late NotesPresenter presenter;
  List notes = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    presenter = NotesPresenter(
      getNotes: sl<GetNotes>(),
      saveNote: sl<SaveNote>(),
      deleteNote: sl<DeleteNote>(),
    );

    presenter.attachView(this);
    presenter.loadNotes();
  }

  @override
  void dispose() {
    presenter.detachView();
    super.dispose();
  }

  @override
  void showError(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  void showNotes(List n) {
    setState(() {
      notes = n;
      errorMessage = null;
    });
  }

  void _deleteNote(int index) {
    final note = notes[index];
    presenter.removeNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeoNotes')),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.text),
                  subtitle: Text('Lat: ${note.lat}, Lng: ${note.lng}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
