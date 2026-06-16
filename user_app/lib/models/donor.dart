class Donor {
  final String id;
  final String name;
  final String phone;
  final String bloodGroup;
  final String upazila;
  final String address;
  final String photoUrl;
  final bool isRegistered;
  final String createdAt;

  Donor({
    required this.id,
    required this.name,
    required this.phone,
    required this.bloodGroup,
    required this.upazila,
    required this.address,
    this.photoUrl = '',
    this.isRegistered = false,
    this.createdAt = '',
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      upazila: json['upazila'] ?? '',
      address: json['address'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      isRegistered: json['is_registered'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
