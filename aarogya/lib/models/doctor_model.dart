class Doctor {
  final String name;
  final String speciality;
  final String imageUrl;
  final String rating;
  final String hospitalName;

  Doctor({
    required this.name,
    required this.speciality,
    required this.imageUrl,
    required this.rating,
    required this.hospitalName,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      speciality: json['speciality'],
      imageUrl: json['image_url'], // Adjust if the actual field is different
      rating: json['rating'],
      hospitalName: json['hospital_name'], // Adjust the field name as needed
    );
  }
}
