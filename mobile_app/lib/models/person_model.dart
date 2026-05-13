class PersonModel {
  final String id;
  final String name;
  final String? imageUrl;
  final bool isKnown;
  final List<double>? faceVector;

  PersonModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.isKnown,
    this.faceVector,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      isKnown: json['is_known'],
      faceVector: json['face_vector']?.cast<double>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'is_known': isKnown,
      'face_vector': faceVector,
    };
  }
}