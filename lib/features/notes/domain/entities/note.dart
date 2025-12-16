class Note {
  final String id;
  final String content;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });
}
