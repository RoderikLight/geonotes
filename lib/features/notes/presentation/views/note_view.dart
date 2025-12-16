import 'package:flutter/material.dart';
import '../../../../injection_container.dart';
import '../../../../core/security/auth_service.dart';
import '../presenter/notes_presenter.dart';
import '../../domain/entities/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> implements NotesViewContract {
  late NotesPresenter presenter;
  List<Note> notes = [];
  bool loading = true;
  String? error;
  String? userEmail;

  late final AuthService _authService;
  late final StreamSubscription<User?> _authSub;

  @override void initState() {
    super.initState();
    presenter = sl<NotesPresenter>();
    presenter.attachView(this);
    presenter.loadNotes();

    _authService = sl<AuthService>();
  }

  @override
  void dispose() {
    _authSub.cancel();
    presenter.detachView();
    super.dispose();
  }

  // ===== MVP callbacks =====

  @override
  void showNotes(List<Note> notes) {
    setState(() {
      this.notes = notes;
      loading = false;
      error = null;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      error = message;
      loading = false;
    });
  }

  // ===== UI =====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GeoNotes'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Mapa',
            icon: const Icon(Icons.map),
            onPressed: () async {
              await Navigator.pushNamed(context, '/map');
              presenter.loadNotes(); // recarga notas al volver del mapa
            },
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : notes.isEmpty
                  ? const Center(child: Text('No hay notas'))
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (_, index) {
                        final note = notes[index];
                        return ListTile(
                          title: Text(note.text),
                          subtitle: Text('Lat: ${note.lat}, Lng: ${note.lng}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              presenter.removeNote(note);
                            },
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          presenter.loadNotes(); // recarga notas al volver de agregar nota
        },
      ),
    );
  }
}
