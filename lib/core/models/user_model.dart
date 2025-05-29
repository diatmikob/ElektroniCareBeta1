import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { customer, technician }

class UserModel {

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
    this.profileImageUrl,
    this.userType = UserType.customer,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.preferences,
  });

  // Create UserModel from Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      address: data['address'],
      profileImageUrl: data['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (type) => type.name == data['userType'],
        orElse: () => UserType.customer,
      ),
      isEmailVerified: data['isEmailVerified'] ?? false,
      isPhoneVerified: data['isPhoneVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
      preferences: data['preferences'],
    );
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      address: map['address'],
      profileImageUrl: map['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (type) => type.name == map['userType'],
        orElse: () => UserType.customer,
      ),
      isEmailVerified: map['isEmailVerified'] ?? false,
      isPhoneVerified: map['isPhoneVerified'] ?? false,
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] is String
              ? DateTime.tryParse(map['createdAt'])
              : null,
      updatedAt: map['updatedAt'] is Timestamp 
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'] is String
              ? DateTime.tryParse(map['updatedAt'])
              : null,
      isActive: map['isActive'] ?? true,
      preferences: map['preferences'],
    );
  }
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;
  final String? profileImageUrl;
  final UserType userType;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final Map<String, dynamic>? preferences;

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'userType': userType.name,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'preferences': preferences,
    };
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'userType': userType.name,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'preferences': preferences,
    };
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    UserType? userType,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }

  // Get user initials for avatar
  String get initials {
    final names = fullName.trim().split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names.first[0].toUpperCase();
    }
    return 'U';
  }

  // Get display name
  String get displayName {
    return fullName.isNotEmpty ? fullName : email.split('@').first;
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return fullName.isNotEmpty && 
           email.isNotEmpty && 
           phone != null && 
           phone!.isNotEmpty &&
           address != null && 
           address!.isNotEmpty;
  }

  // User type helpers
  bool get isTechnician => userType == UserType.technician;
  bool get isCustomer => userType == UserType.customer;

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phone: $phone, address: $address, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.profileImageUrl == profileImageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        profileImageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode;
  }
}