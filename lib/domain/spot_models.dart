class SpotEntry {
  final String id;
  DateTime observedAt;
  String location;
  String aircraftTypeId;
  String registration;
  String airline;
  String note;
  bool hasPhoto;

  SpotEntry({
    required this.id,
    required this.observedAt,
    required this.location,
    required this.aircraftTypeId,
    required this.registration,
    required this.airline,
    this.note = '',
    this.hasPhoto = false,
  });

  String get monthKey =>
      '${observedAt.year}-${observedAt.month.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'observedAt': observedAt.toIso8601String(),
        'location': location,
        'type': aircraftTypeId,
        'registration': registration,
        'airline': airline,
        'note': note,
        'hasPhoto': hasPhoto,
      };

  static SpotEntry fromJson(Map<String, dynamic> j) => SpotEntry(
        id: j['id'] as String,
        observedAt: DateTime.parse(j['observedAt'] as String),
        location: j['location'] as String? ?? '',
        aircraftTypeId: j['type'] as String? ?? '',
        registration: j['registration'] as String? ?? '',
        airline: j['airline'] as String? ?? '',
        note: j['note'] as String? ?? '',
        hasPhoto: j['hasPhoto'] as bool? ?? false,
      );
}
