class EventModel {
  final String id;
  final String cameraId;
  final String personId;
  final DateTime timestamp;
  final String eventType; // 'recognized', 'unknown'
  final double confidence;

  EventModel({
    required this.id,
    required this.cameraId,
    required this.personId,
    required this.timestamp,
    required this.eventType,
    required this.confidence,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      cameraId: json['camera_id'],
      personId: json['person_id'],
      timestamp: DateTime.parse(json['timestamp']),
      eventType: json['event_type'],
      confidence: json['confidence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'camera_id': cameraId,
      'person_id': personId,
      'timestamp': timestamp.toIso8601String(),
      'event_type': eventType,
      'confidence': confidence,
    };
  }
}