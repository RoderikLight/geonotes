import 'package:geonotes/features/notes/domain/entities/note.dart';


class NoteModel {
  final String text;
  final double lat;
  final double lng;

  NoteModel({
    required this.text,
    required this.lat,
    required this.lng,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      text: json['text'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'lat': lat,
      'lng': lng,
    };
  }

  Note toEntity() {
    return Note(
      text: text,
      lat: lat,
      lng: lng,
    );
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      text: note.text,
      lat: note.lat,
      lng: note.lng,
    );
  }
}
