import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/save_note.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  LatLng _initialCamera = const LatLng(0, 0);
  LatLng? _userPosition;

  bool _loading = true;
  StreamSubscription<Position>? _positionStream;

  Marker? get _userMarker => _userPosition == null
      ? null
      : Marker(
          point: _userPosition!,
          width: 50,
          height: 50,
          child: const Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 50,
          ),
        );

  @override
  void initState() {
    super.initState();
    _initLocationAndMarkers();
    _startPositionStream();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _initLocationAndMarkers() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      _userPosition = LatLng(pos.latitude, pos.longitude);
      _initialCamera = _userPosition!;
    } catch (_) {}

    await _loadMarkers();
    setState(() => _loading = false);
  }

  Future<void> _loadMarkers() async {
    final getNotes = sl<GetNotes>();
    final notes = await getNotes();

    _markers
      ..clear()
      ..addAll(
        notes.map(
          (note) => Marker(
            point: LatLng(note.lat, note.lng),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showNoteDialog(note),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        ),
      );

    setState(() {});
  }

  void _showNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nota'),
        content: Text(note.text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _onMapLongPress(TapPosition tapPosition, LatLng pos) async {
    final controller = TextEditingController();

    final text = await showDialog<String?>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Nueva nota'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Texto'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (text != null && text.isNotEmpty) {
      final save = sl<SaveNote>();
      await save(Note(text: text, lat: pos.latitude, lng: pos.longitude));
      await _loadMarkers();
    }
  }

  void _startPositionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: settings).listen(
      (pos) {
        setState(() {
          _userPosition = LatLng(pos.latitude, pos.longitude);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Notas'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialCamera,
          initialZoom: 14,
          onLongPress: _onMapLongPress,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.tuapp',
          ),
          MarkerLayer(
            markers: [
              ..._markers,
              if (_userMarker != null) _userMarker!,
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () {
          if (_userPosition != null) {
            _mapController.move(_userPosition!, 14);
          }
        },
      ),
    );
  }
}
