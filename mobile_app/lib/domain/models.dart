import 'package:uuid/uuid.dart';

/// Person Model - Đại diện cho một người được nhận diện
class Person {
  final String id;
  final String name;
  final bool isUnknown;
  final DateTime createdAt;
  final List<String> embeddingIds; // ID của các Face Embeddings

  Person({
    String? id,
    required this.name,
    this.isUnknown = false,
    DateTime? createdAt,
    this.embeddingIds = const [],
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // JSON Serialization
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      isUnknown: json['is_unknown'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      embeddingIds: List<String>.from(json['embedding_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_unknown': isUnknown,
      'created_at': createdAt.toIso8601String(),
      'embedding_ids': embeddingIds,
    };
  }
}

/// Camera Model - Đại diện cho một chiếc camera
class Camera {
  final String id;
  final String name;
  final String? room;
  final String streamUrl;
  final String mode; // RECOGNITION_ON, SILENT, PRIVACY
  final String status; // ONLINE, OFFLINE
  final int cooldownMinutes;

  Camera({
    String? id,
    required this.name,
    this.room,
    required this.streamUrl,
    this.mode = 'RECOGNITION_ON',
    this.status = 'ONLINE',
    this.cooldownMinutes = 10,
  }) : id = id ?? const Uuid().v4();

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'],
      name: json['name'],
      room: json['room'],
      streamUrl: json['stream_url'],
      mode: json['mode'] ?? 'RECOGNITION_ON',
      status: json['status'] ?? 'ONLINE',
      cooldownMinutes: json['cooldown_minutes'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'room': room,
      'stream_url': streamUrl,
      'mode': mode,
      'status': status,
      'cooldown_minutes': cooldownMinutes,
    };
  }
}

/// Recognition Session Model - Kết quả nhận diện mỗi lần
class RecognitionSession {
  final String id;
  final String cameraId;
  final String? matchedPersonId;
  final String status; // PROCESSING, SUCCESS, FAILED_UNKNOWN, POSSIBLE_MATCH
  final String? bestSnapshotUrl;
  final double? confidenceScore;
  final DateTime startedAt;
  final DateTime? endedAt;

  RecognitionSession({
    String? id,
    required this.cameraId,
    this.matchedPersonId,
    this.status = 'PROCESSING',
    this.bestSnapshotUrl,
    this.confidenceScore,
    DateTime? startedAt,
    this.endedAt,
  })  : id = id ?? const Uuid().v4(),
        startedAt = startedAt ?? DateTime.now();

  factory RecognitionSession.fromJson(Map<String, dynamic> json) {
    return RecognitionSession(
      id: json['id'],
      cameraId: json['camera_id'],
      matchedPersonId: json['matched_person_id'],
      status: json['status'],
      bestSnapshotUrl: json['best_snapshot_url'],
      confidenceScore: json['confidence_score']?.toDouble(),
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'camera_id': cameraId,
      'matched_person_id': matchedPersonId,
      'status': status,
      'best_snapshot_url': bestSnapshotUrl,
      'confidence_score': confidenceScore,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
    };
  }
}

/// Recognition Alert Model - Thông báo khi có người được nhận diện
class RecognitionAlert {
  final String sessionId;
  final Person person;
  final Camera camera;
  final double confidence;
  final String snapshotUrl;
  final DateTime detectedAt;

  RecognitionAlert({
    required this.sessionId,
    required this.person,
    required this.camera,
    required this.confidence,
    required this.snapshotUrl,
    required this.detectedAt,
  });
}
