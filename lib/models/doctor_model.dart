class DoctorModel {
  final int id;
  final String name;
  final String role;
  final String tag;
  final double rating;
  final String specializedArea;
  final String contactNumber;
  final String email;
  final String photoUrl;

  DoctorModel({
    required this.id,
    required this.name,
    required this.role,
    required this.tag,
    required this.rating,
    required this.specializedArea,
    required this.contactNumber,
    required this.email,
    required this.photoUrl,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as int,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      tag: map['tag'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      specializedArea: map['specialized_area'] ?? '',
      contactNumber: map['contact_number'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photo_url'] ?? '',
    );
  }
}