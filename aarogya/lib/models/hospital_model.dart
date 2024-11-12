// models/hospital_model.dart
class Hospital {
  final String name;
  final String address;
  final String imageUrl;
  final String rating;

  Hospital({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'],
      address: json['address'],
      imageUrl: json['image_url'],
      rating: json['rating'] ?? "5.0",
    );
  }
}
