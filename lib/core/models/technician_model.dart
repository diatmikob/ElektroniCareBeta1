class TechnicianModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String profileImage;
  final String specialization;
  final List<String> services;
  final double rating;
  final int totalReviews;
  final String experience;
  final String location;
  final bool isAvailable;
  final bool isVerified;
  final String description;
  final List<String> certifications;
  final Map<String, dynamic> workingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  TechnicianModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage = '',
    required this.specialization,
    required this.services,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.experience,
    required this.location,
    this.isAvailable = true,
    this.isVerified = false,
    this.description = '',
    this.certifications = const [],
    this.workingHours = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory TechnicianModel.fromMap(Map<String, dynamic> map) {
    return TechnicianModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'] ?? '',
      specialization: map['specialization'] ?? '',
      services: List<String>.from(map['services'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      experience: map['experience'] ?? '',
      location: map['location'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      isVerified: map['isVerified'] ?? false,
      description: map['description'] ?? '',
      certifications: List<String>.from(map['certifications'] ?? []),
      workingHours: Map<String, dynamic>.from(map['workingHours'] ?? {}),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'specialization': specialization,
      'services': services,
      'rating': rating,
      'totalReviews': totalReviews,
      'experience': experience,
      'location': location,
      'isAvailable': isAvailable,
      'isVerified': isVerified,
      'description': description,
      'certifications': certifications,
      'workingHours': workingHours,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TechnicianModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? profileImage,
    String? specialization,
    List<String>? services,
    double? rating,
    int? totalReviews,
    String? experience,
    String? location,
    bool? isAvailable,
    bool? isVerified,
    String? description,
    List<String>? certifications,
    Map<String, dynamic>? workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TechnicianModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      specialization: specialization ?? this.specialization,
      services: services ?? this.services,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      experience: experience ?? this.experience,
      location: location ?? this.location,
      isAvailable: isAvailable ?? this.isAvailable,
      isVerified: isVerified ?? this.isVerified,
      description: description ?? this.description,
      certifications: certifications ?? this.certifications,
      workingHours: workingHours ?? this.workingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedRating => rating.toStringAsFixed(1);
  
  String get experienceYears {
    final years = experience.split(' ').first;
    return '$years tahun';
  }
  
  bool get isOnline => isAvailable && isVerified;
  
  String get statusText {
    if (!isVerified) return 'Belum Terverifikasi';
    if (!isAvailable) return 'Tidak Tersedia';
    return 'Tersedia';
  }
}