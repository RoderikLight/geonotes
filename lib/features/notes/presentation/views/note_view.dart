import 'package:flutter/material.dart';
import '../../../../injection_container.dart';
import '../../../../core/security/auth_service.dart';
import '../presenter/notes_presenter.dart';
import '../../domain/entities/note.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView>
    implements NotesViewContract {
  late NotesPresenter presenter;
  List<Note> notes = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    presenter = sl<NotesPresenter>();
    presenter.attachView(this);
    presenter.loadNotes();
  }
  
  @override
  void dispose() {
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
      appBar: AppBar(title: const Text('GeoNotes'), actions: [
        IconButton(
          tooltip: 'Sign out',
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await sl<AuthService>().signOut();
          },
        ),
      ]),
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
                          subtitle: Text(
                            'Lat: ${note.lat}, Lng: ${note.lng}',
                          ),
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
          presenter.loadNotes();
        },
      ),
    );
  }
}
