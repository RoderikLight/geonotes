import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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
  LatLng _initialCamera = LatLng(0, 0);
  bool _loading = true;

  LatLng? _userPosition; // Para mostrar la posición actual
  StreamSubscription<Position>? _positionStream;

  Marker? get _userMarker => _userPosition == null
      ? null
      : Marker(
          point: _userPosition!,
          width: 50,
          height: 50,
          child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 50),
        );

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocationAndMarkers();
    _startPositionStream(); // Inicia el seguimiento en tiempo real
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
    try {
      final getNotes = sl<GetNotes>();
      final notes = await getNotes();
      _markers.clear();
      for (var i = 0; i < notes.length; i++) {
        final note = notes[i];
        _markers.add(
          Marker(
            point: LatLng(note.lat, note.lng),
            width: 40,
            height: 40,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        );
      }
      setState(() {});
    } catch (e) {
      // ignore
    }
  }

  void _onMapLongPress(TapPosition tapPosition, LatLng pos) async {
    final controller = TextEditingController();
    final text = await showDialog<String?>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('New note'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Text')),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(c).pop(controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );

    if (text != null && text.isNotEmpty) {
      try {
        final save = sl<SaveNote>();
        await save(Note(text: text, lat: pos.latitude, lng: pos.longitude));
        await _loadMarkers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error saving note')));
      }
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1',
    );

    final response = await http.get(url, headers: {'User-Agent': 'com.tuapp'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        _mapController.move(LatLng(lat, lon), 14);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Direction not found')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error looking for adress')));
    }
  }

  void _startPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // actualiza cada 5 metros
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position pos) {
      setState(() {
        _userPosition = LatLng(pos.latitude, pos.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Map'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Buscar dirección...',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchAddress(_searchController.text),
                ),
              ],
            ),
          ),
        ),
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
