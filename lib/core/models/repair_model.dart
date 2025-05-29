import 'package:cloud_firestore/cloud_firestore.dart';

enum RepairStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case RepairStatus.pending:
        return 'Pending';
      case RepairStatus.confirmed:
        return 'Confirmed';
      case RepairStatus.inProgress:
        return 'In Progress';
      case RepairStatus.completed:
        return 'Completed';
      case RepairStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case RepairStatus.pending:
        return 'Waiting for confirmation';
      case RepairStatus.confirmed:
        return 'Repair confirmed, waiting for technician';
      case RepairStatus.inProgress:
        return 'Technician is working on your device';
      case RepairStatus.completed:
        return 'Repair completed successfully';
      case RepairStatus.cancelled:
        return 'Repair request cancelled';
    }
  }

  static RepairStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RepairStatus.pending;
      case 'confirmed':
        return RepairStatus.confirmed;
      case 'in_progress':
      case 'inprogress':
        return RepairStatus.inProgress;
      case 'completed':
        return RepairStatus.completed;
      case 'cancelled':
        return RepairStatus.cancelled;
      default:
        return RepairStatus.pending;
    }
  }
}

class RepairModel {
  final String id;
  final String userId;
  final String deviceType;
  final String deviceModel;
  final String issueDescription;
  final String? serviceId;
  final String? technicianEmail;
  final RepairStatus status;
  final double? estimatedCost;
  final DateTime? appointmentTimestamp;
  final DateTime? completedDate;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? images;
  final Map<String, dynamic>? metadata;
  final String? notes;

  const RepairModel({
    required this.id,
    required this.userId,
    required this.deviceType,
    required this.deviceModel,
    required this.issueDescription,
    this.serviceId,
    this.technicianEmail,
    this.status = RepairStatus.pending,
    this.estimatedCost,
    this.appointmentTimestamp,
    this.completedDate,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.metadata,
    this.notes,
  });

  // Create RepairModel from Firestore document
  factory RepairModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RepairModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      deviceType: data['deviceType'] ?? 'Electronic Device',
      deviceModel: data['deviceModel'] ?? 'Unknown Model',
      issueDescription: data['issueDescription'] ?? '',
      serviceId: data['serviceId'],
      technicianEmail: data['technicianEmail'],
      status: RepairStatus.fromString(data['status'] ?? 'pending'),
      estimatedCost: (data['estimatedCost'] ?? 0.0).toDouble(),
      appointmentTimestamp: (data['appointmentTimestamp'] as Timestamp?)?.toDate(),
      completedDate: (data['completedDate'] as Timestamp?)?.toDate(),
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      metadata: data['metadata'],
      notes: data['notes'],
    );
  }

  // Create RepairModel from Map
  factory RepairModel.fromMap(Map<String, dynamic> map) {
    return RepairModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      deviceType: map['deviceType'] ?? 'Electronic Device',
      deviceModel: map['deviceModel'] ?? 'Unknown Model',
      issueDescription: map['issueDescription'] ?? '',
      serviceId: map['serviceId'],
      technicianEmail: map['technicianEmail'],
      status: RepairStatus.fromString(map['status'] ?? 'pending'),
      estimatedCost: map['estimatedCost'] != null ? (map['estimatedCost'] as num).toDouble() : null,
      appointmentTimestamp: map['appointmentTimestamp'] is Timestamp 
          ? (map['appointmentTimestamp'] as Timestamp).toDate()
          : map['appointmentTimestamp'] is String
              ? DateTime.tryParse(map['appointmentTimestamp'])
              : null,
      completedDate: map['completedDate'] is Timestamp 
          ? (map['completedDate'] as Timestamp).toDate()
          : map['completedDate'] is String
              ? DateTime.tryParse(map['completedDate'])
              : null,
      location: map['location'],
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
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      metadata: map['metadata'],
      notes: map['notes'],
    );
  }

  // Convert RepairModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'deviceType': deviceType,
      'deviceModel': deviceModel,
      'issueDescription': issueDescription,
      'serviceId': serviceId,
      'technicianEmail': technicianEmail,
      'status': status.name,
      'estimatedCost': estimatedCost,
      'appointmentTimestamp': appointmentTimestamp != null ? Timestamp.fromDate(appointmentTimestamp!) : null,
      'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'location': location,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'images': images,
      'metadata': metadata,
      'notes': notes,
    };
  }

  // Convert RepairModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'deviceType': deviceType,
      'deviceModel': deviceModel,
      'issueDescription': issueDescription,
      'serviceId': serviceId,
      'technicianEmail': technicianEmail,
      'status': status.name,
      'estimatedCost': estimatedCost,
      'appointmentTimestamp': appointmentTimestamp?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'location': location,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'images': images,
      'metadata': metadata,
      'notes': notes,
    };
  }

  // Create a copy of RepairModel with updated fields
  RepairModel copyWith({
    String? id,
    String? userId,
    String? deviceType,
    String? deviceModel,
    String? issueDescription,
    String? serviceId,
    String? technicianEmail,
    RepairStatus? status,
    double? estimatedCost,
    DateTime? appointmentTimestamp,
    DateTime? completedDate,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    Map<String, dynamic>? metadata,
    String? notes,
  }) {
    return RepairModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceType: deviceType ?? this.deviceType,
      deviceModel: deviceModel ?? this.deviceModel,
      issueDescription: issueDescription ?? this.issueDescription,
      serviceId: serviceId ?? this.serviceId,
      technicianEmail: technicianEmail ?? this.technicianEmail,
      status: status ?? this.status,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      appointmentTimestamp: appointmentTimestamp ?? this.appointmentTimestamp,
      completedDate: completedDate ?? this.completedDate,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      metadata: metadata ?? this.metadata,
      notes: notes ?? this.notes,
    );
  }

  // Get formatted cost
  String get formattedCost {
    if (estimatedCost == null || estimatedCost == 0) return 'To be determined';
    return 'Rp ${estimatedCost!.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Get device display name
  String get deviceDisplayName {
    return '$deviceType - $deviceModel';
  }

  // Check if repair is active
  bool get isActive {
    return status != RepairStatus.completed && status != RepairStatus.cancelled;
  }

  // Check if repair can be cancelled
  bool get canBeCancelled {
    return status == RepairStatus.pending || status == RepairStatus.confirmed;
  }

  // Get status color
  String get statusColor {
    switch (status) {
      case RepairStatus.pending:
        return '#FFA500'; // Orange
      case RepairStatus.confirmed:
        return '#2196F3'; // Blue
      case RepairStatus.inProgress:
        return '#FF9800'; // Amber
      case RepairStatus.completed:
        return '#4CAF50'; // Green
      case RepairStatus.cancelled:
        return '#F44336'; // Red
    }
  }

  // Get days since created
  int? get daysSinceCreated {
    if (createdAt == null) return null;
    return DateTime.now().difference(createdAt!).inDays;
  }

  @override
  String toString() {
    return 'RepairModel(id: $id, userId: $userId, deviceType: $deviceType, deviceModel: $deviceModel, issueDescription: $issueDescription, serviceId: $serviceId, technicianEmail: $technicianEmail, status: $status, estimatedCost: $estimatedCost, appointmentTimestamp: $appointmentTimestamp, completedDate: $completedDate, location: $location, createdAt: $createdAt, updatedAt: $updatedAt, images: $images, metadata: $metadata, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RepairModel &&
        other.id == id &&
        other.userId == userId &&
        other.deviceType == deviceType &&
        other.deviceModel == deviceModel &&
        other.issueDescription == issueDescription &&
        other.serviceId == serviceId &&
        other.technicianEmail == technicianEmail &&
        other.status == status &&
        other.estimatedCost == estimatedCost &&
        other.appointmentTimestamp == appointmentTimestamp &&
        other.completedDate == completedDate &&
        other.location == location &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        deviceType.hashCode ^
        deviceModel.hashCode ^
        issueDescription.hashCode ^
        serviceId.hashCode ^
        technicianEmail.hashCode ^
        status.hashCode ^
        estimatedCost.hashCode ^
        appointmentTimestamp.hashCode ^
        completedDate.hashCode ^
        location.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}