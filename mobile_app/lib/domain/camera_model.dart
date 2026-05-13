class CameraModel {
  final String id;
  final String name;
  final String room;
  final String status;
  final String latestSnapshotUrl;

  CameraModel({
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.latestSnapshotUrl,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Camera',
      room: json['room'] ?? 'UNKNOWN',
      status: json['status'] ?? 'OFFLINE',
      latestSnapshotUrl: json['latest_snapshot_url'] ?? '',
    );
  }
}