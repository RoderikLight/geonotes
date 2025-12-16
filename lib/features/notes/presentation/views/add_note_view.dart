import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/note.dart';
import '../presenter/notes_presenter.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});
  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final TextEditingController _textCtrl = TextEditingController();
  late NotesPresenter presenter;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    presenter = sl<NotesPresenter>();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _save() async {
    setState(() => loading = true);
    try {
      final pos = await _determinePosition();

      final note = Note(text: _textCtrl.text, lat: pos.latitude, lng: pos.longitude);
      await presenter.addNote(note);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      final msg = e.toString() ?? 'Error saving note';
      setState(() {
        error = msg.contains('permanently')
            ? 'Location permission permanently denied. Open settings to enable.'
            : msg;
        loading = false;
      });

      if (e.toString().contains('permanently')) {
        // Offer to open app settings
        _showOpenSettingsDialog();
      }
    }
  }

  void _showOpenSettingsDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission'),
        content: const Text('Please enable location permission in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _textCtrl, decoration: const InputDecoration(labelText: 'Note')),
            const SizedBox(height: 16),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            const Spacer(),
            ElevatedButton(
              onPressed: loading ? null : _save,
              child: loading ? const CircularProgressIndicator() : const Text('Save with GPS'),
            ),
          ],
        ),
      ),
    );
  }
}