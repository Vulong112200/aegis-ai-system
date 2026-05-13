class CameraModel {
  final String id;
  final String name;
  final String ipAddress;
  final bool isOnline;
  final String location;

  CameraModel({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.isOnline,
    required this.location,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'],
      name: json['name'],
      ipAddress: json['ip_address'],
      isOnline: json['is_online'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip_address': ipAddress,
      'is_online': isOnline,
      'location': location,
    };
  }
}