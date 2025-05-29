import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.basePrice,
    this.estimatedTime,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.tags,
    this.metadata,
  });

  // Create ServiceModel from Firestore document
  factory ServiceModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      basePrice: (data['basePrice'] ?? 0.0).toDouble(),
      estimatedTime: data['estimatedTime'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      metadata: data['metadata'],
    );
  }

  // Create ServiceModel from Map
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      basePrice: (map['basePrice'] ?? 0.0).toDouble(),
      estimatedTime: map['estimatedTime'],
      imageUrl: map['imageUrl'],
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
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      metadata: map['metadata'],
    );
  }
  final String id;
  final String name;
  final String description;
  final String category;
  final double basePrice;
  final String? estimatedTime;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;

  // Convert ServiceModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'basePrice': basePrice,
      'estimatedTime': estimatedTime,
      'imageUrl': imageUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'tags': tags,
      'metadata': metadata,
    };
  }

  // Convert ServiceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'basePrice': basePrice,
      'estimatedTime': estimatedTime,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'tags': tags,
      'metadata': metadata,
    };
  }

  // Create a copy of ServiceModel with updated fields
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? basePrice,
    String? estimatedTime,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      basePrice: basePrice ?? this.basePrice,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get formatted price
  String get formattedPrice {
    if (basePrice == 0) return 'Free';
    return 'Rp ${basePrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Get category icon
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'smartphone':
        return '📱';
      case 'laptop':
        return '💻';
      case 'tv':
        return '📺';
      case 'audio':
        return '🎵';
      case 'gaming':
        return '🎮';
      case 'appliances':
        return '🏠';
      default:
        return '🔧';
    }
  }

  // Get estimated duration in hours
  int? get estimatedHours {
    if (estimatedTime == null) return null;
    final match = RegExp(r'(\d+)').firstMatch(estimatedTime!);
    if (match != null) {
      final number = int.tryParse(match.group(1)!);
      if (estimatedTime!.toLowerCase().contains('day')) {
        return number != null ? number * 24 : null;
      }
      return number;
    }
    return null;
  }

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, description: $description, category: $category, basePrice: $basePrice, estimatedTime: $estimatedTime, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, tags: $tags, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.category == category &&
        other.basePrice == basePrice &&
        other.estimatedTime == estimatedTime &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        category.hashCode ^
        basePrice.hashCode ^
        estimatedTime.hashCode ^
        imageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode;
  }
}