class ReportModel {
  final String id;
  final String ticketId;
  final String type;
  final String description;
  final String location;
  final String? evidencePath;
  final DateTime timestamp;

  const ReportModel({
    required this.id,
    required this.ticketId,
    required this.type,
    required this.description,
    this.location = '',
    this.evidencePath,
    required this.timestamp,
  });

  ReportModel copyWith({
    String? type,
    String? description,
    String? location,
    String? evidencePath,
  }) =>
      ReportModel(
        id: id,
        ticketId: ticketId,
        type: type ?? this.type,
        description: description ?? this.description,
        location: location ?? this.location,
        evidencePath: evidencePath ?? this.evidencePath,
        timestamp: timestamp,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ticketId': ticketId,
        'type': type,
        'description': description,
        'location': location,
        'evidencePath': evidencePath,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'] ?? '',
        ticketId: json['ticketId'] ?? '',
        type: json['type'] ?? '',
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        evidencePath: json['evidencePath'],
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      );
}

/// Generate a locally-generated ticket ID: RPT-YYYYMMDD-HHMMSS
String generateTicketId() {
  final now = DateTime.now();
  final y = now.year;
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  final h = now.hour.toString().padLeft(2, '0');
  final min = now.minute.toString().padLeft(2, '0');
  final s = now.second.toString().padLeft(2, '0');
  final ms = now.millisecondsSinceEpoch % 1000;
  return 'RPT-$y$m${d}-$h$min$s-${ms.toString().padLeft(3, '0')}';
}
