import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/technician_model.dart';
import '../models/service_model.dart';

class SeederService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed technicians data
  Future<void> seedTechnicians() async {
    try {
      final technicians = _getTechnicianSeederData();
      
      for (final technician in technicians) {
        await _firestore
            .collection('technicians')
            .doc(technician.id)
            .set(technician.toMap());
      }
      
      print('Technicians seeded successfully');
    } catch (e) {
      print('Error seeding technicians: $e');
    }
  }

  /// Seed services data
  Future<void> seedServices() async {
    try {
      final services = _getServiceSeederData();
      
      for (final service in services) {
        await _firestore
            .collection('services')
            .doc(service.id)
            .set(service.toMap());
      }
      
      print('Services seeded successfully');
    } catch (e) {
      print('Error seeding services: $e');
    }
  }

  /// Seed all data
  Future<void> seedAll() async {
    await Future.wait([
      seedTechnicians(),
      seedServices(),
    ]);
  }

  /// Get technician seeder data
  List<TechnicianModel> _getTechnicianSeederData() {
    final now = DateTime.now();
    
    return [
      TechnicianModel(
        id: 'tech_001',
        fullName: 'Satria Wiangga',
        email: 'satriawiangga200@gmail.com',
        phone: '+62812-3456-7890',
        profileImage: 'https://res.cloudinary.com/demo/image/upload/v1/sample.jpg',
        specialization: 'Smartphone & Tablet',
        services: [
          'Perbaikan Layar',
          'Ganti Baterai',
          'Perbaikan Charging Port',
          'Software Troubleshooting',
          'Water Damage Repair'
        ],
        rating: 4.8,
        totalReviews: 127,
        experience: '5 tahun',
        location: 'Jakarta Selatan',
        isAvailable: true,
        isVerified: true,
        description: 'Teknisi berpengalaman dalam perbaikan smartphone dan tablet. Spesialis dalam perbaikan iPhone, Samsung, dan berbagai merek Android. Menggunakan spare part original dan memberikan garansi untuk setiap perbaikan.',
        certifications: [
          'Certified Mobile Repair Technician',
          'Apple Authorized Service Provider',
          'Samsung Certified Technician'
        ],
        workingHours: {
          'monday': {'start': '09:00', 'end': '18:00'},
          'tuesday': {'start': '09:00', 'end': '18:00'},
          'wednesday': {'start': '09:00', 'end': '18:00'},
          'thursday': {'start': '09:00', 'end': '18:00'},
          'friday': {'start': '09:00', 'end': '18:00'},
          'saturday': {'start': '10:00', 'end': '16:00'},
          'sunday': {'start': '10:00', 'end': '14:00'},
        },
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now,
      ),
      
      TechnicianModel(
        id: 'tech_002',
        fullName: 'Satria Lingga',
        email: 'satrialingga702@gmail.com',
        phone: '+62813-9876-5432',
        profileImage: 'https://res.cloudinary.com/demo/image/upload/v2/sample.jpg',
        specialization: 'Laptop & Computer',
        services: [
          'Perbaikan Hardware',
          'Upgrade RAM & Storage',
          'Cleaning & Maintenance',
          'OS Installation',
          'Virus Removal',
          'Data Recovery'
        ],
        rating: 4.9,
        totalReviews: 89,
        experience: '7 tahun',
        location: 'Jakarta Pusat',
        isAvailable: true,
        isVerified: true,
        description: 'Ahli dalam perbaikan laptop dan komputer desktop. Berpengalaman menangani berbagai merek seperti ASUS, Acer, Lenovo, HP, dan Dell. Menyediakan layanan upgrade hardware dan recovery data.',
        certifications: [
          'CompTIA A+ Certified',
          'Microsoft Certified Professional',
          'ASUS Authorized Service Center'
        ],
        workingHours: {
          'monday': {'start': '08:00', 'end': '17:00'},
          'tuesday': {'start': '08:00', 'end': '17:00'},
          'wednesday': {'start': '08:00', 'end': '17:00'},
          'thursday': {'start': '08:00', 'end': '17:00'},
          'friday': {'start': '08:00', 'end': '17:00'},
          'saturday': {'start': '09:00', 'end': '15:00'},
          'sunday': {'start': 'closed', 'end': 'closed'},
        },
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
      ),
      
      TechnicianModel(
        id: 'tech_003',
        fullName: 'Ahmad Rizki',
        email: 'ahmad.rizki@elektronicare.com',
        phone: '+62814-5555-1234',
        profileImage: 'https://res.cloudinary.com/demo/image/upload/v3/sample.jpg',
        specialization: 'Gaming Console',
        services: [
          'PlayStation Repair',
          'Xbox Repair',
          'Nintendo Switch Repair',
          'Controller Repair',
          'HDMI Port Repair'
        ],
        rating: 4.7,
        totalReviews: 64,
        experience: '4 tahun',
        location: 'Jakarta Barat',
        isAvailable: true,
        isVerified: true,
        description: 'Spesialis perbaikan gaming console. Menangani semua jenis kerusakan pada PlayStation, Xbox, dan Nintendo Switch. Berpengalaman dalam perbaikan hardware dan software gaming console.',
        certifications: [
          'Sony PlayStation Certified Technician',
          'Microsoft Xbox Authorized Repair'
        ],
        workingHours: {
          'monday': {'start': '10:00', 'end': '19:00'},
          'tuesday': {'start': '10:00', 'end': '19:00'},
          'wednesday': {'start': '10:00', 'end': '19:00'},
          'thursday': {'start': '10:00', 'end': '19:00'},
          'friday': {'start': '10:00', 'end': '19:00'},
          'saturday': {'start': '10:00', 'end': '17:00'},
          'sunday': {'start': '12:00', 'end': '16:00'},
        },
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now,
      ),
      
      TechnicianModel(
        id: 'tech_004',
        fullName: 'Sari Indah',
        email: 'sari.indah@elektronicare.com',
        phone: '+62815-7777-8888',
        profileImage: 'https://res.cloudinary.com/demo/image/upload/v4/sample.jpg',
        specialization: 'Home Appliances',
        services: [
          'AC Repair & Maintenance',
          'Washing Machine Repair',
          'Refrigerator Repair',
          'Microwave Repair',
          'TV Repair'
        ],
        rating: 4.6,
        totalReviews: 156,
        experience: '8 tahun',
        location: 'Jakarta Timur',
        isAvailable: true,
        isVerified: true,
        description: 'Teknisi berpengalaman dalam perbaikan peralatan rumah tangga. Menangani AC, mesin cuci, kulkas, microwave, dan TV. Menyediakan layanan maintenance berkala untuk menjaga performa optimal peralatan.',
        certifications: [
          'HVAC Certified Technician',
          'Home Appliance Repair Specialist',
          'Electrical Safety Certified'
        ],
        workingHours: {
          'monday': {'start': '08:00', 'end': '16:00'},
          'tuesday': {'start': '08:00', 'end': '16:00'},
          'wednesday': {'start': '08:00', 'end': '16:00'},
          'thursday': {'start': '08:00', 'end': '16:00'},
          'friday': {'start': '08:00', 'end': '16:00'},
          'saturday': {'start': '08:00', 'end': '12:00'},
          'sunday': {'start': 'closed', 'end': 'closed'},
        },
        createdAt: now.subtract(const Duration(days: 400)),
        updatedAt: now,
      ),
      
      TechnicianModel(
        id: 'tech_005',
        fullName: 'Budi Santoso',
        email: 'budi.santoso@elektronicare.com',
        phone: '+62816-9999-0000',
        profileImage: 'https://res.cloudinary.com/demo/image/upload/v5/sample.jpg',
        specialization: 'Audio & Video',
        services: [
          'Speaker Repair',
          'Headphone Repair',
          'Camera Repair',
          'Projector Repair',
          'Sound System Setup'
        ],
        rating: 4.5,
        totalReviews: 73,
        experience: '6 tahun',
        location: 'Jakarta Utara',
        isAvailable: false, // Currently not available
        isVerified: true,
        description: 'Ahli dalam perbaikan peralatan audio dan video. Menangani speaker, headphone, kamera, dan projector. Berpengalaman dalam setup sound system untuk acara dan instalasi home theater.',
        certifications: [
          'Audio Engineering Certified',
          'Video Equipment Specialist',
          'Canon Authorized Service'
        ],
        workingHours: {
          'monday': {'start': '09:00', 'end': '18:00'},
          'tuesday': {'start': '09:00', 'end': '18:00'},
          'wednesday': {'start': '09:00', 'end': '18:00'},
          'thursday': {'start': '09:00', 'end': '18:00'},
          'friday': {'start': '09:00', 'end': '18:00'},
          'saturday': {'start': '10:00', 'end': '15:00'},
          'sunday': {'start': 'closed', 'end': 'closed'},
        },
        createdAt: now.subtract(const Duration(days: 250)),
        updatedAt: now,
      ),
    ];
  }

  /// Get service seeder data
  List<ServiceModel> _getServiceSeederData() {
    final now = DateTime.now();
    
    return [
      // Smartphone Services
      ServiceModel(
        id: 'service_001',
        name: 'Perbaikan Layar Smartphone',
        description: 'Perbaikan layar retak, LCD mati, atau touchscreen tidak responsif',
        category: 'Smartphone',
        price: 150000,
        duration: '1-2 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/smartphone_screen.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      ServiceModel(
        id: 'service_002',
        name: 'Ganti Baterai Smartphone',
        description: 'Penggantian baterai yang sudah drop atau rusak',
        category: 'Smartphone',
        price: 100000,
        duration: '30 menit',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/smartphone_battery.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Laptop Services
      ServiceModel(
        id: 'service_003',
        name: 'Upgrade RAM Laptop',
        description: 'Upgrade RAM untuk meningkatkan performa laptop',
        category: 'Laptop',
        price: 200000,
        duration: '1 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/laptop_ram.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      ServiceModel(
        id: 'service_004',
        name: 'Cleaning Laptop',
        description: 'Pembersihan menyeluruh laptop dari debu dan kotoran',
        category: 'Laptop',
        price: 75000,
        duration: '2 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/laptop_cleaning.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Gaming Console Services
      ServiceModel(
        id: 'service_005',
        name: 'Perbaikan PlayStation',
        description: 'Perbaikan berbagai masalah pada PlayStation (PS4/PS5)',
        category: 'Gaming Console',
        price: 250000,
        duration: '2-4 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/playstation_repair.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Home Appliances Services
      ServiceModel(
        id: 'service_006',
        name: 'Service AC',
        description: 'Maintenance dan perbaikan AC rumah tangga',
        category: 'Home Appliances',
        price: 150000,
        duration: '2-3 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/ac_service.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      ServiceModel(
        id: 'service_007',
        name: 'Perbaikan Mesin Cuci',
        description: 'Perbaikan mesin cuci yang tidak berfungsi normal',
        category: 'Home Appliances',
        price: 200000,
        duration: '2-4 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/washing_machine.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      // Audio & Video Services
      ServiceModel(
        id: 'service_008',
        name: 'Perbaikan Speaker',
        description: 'Perbaikan speaker yang rusak atau suara tidak keluar',
        category: 'Audio & Video',
        price: 100000,
        duration: '1-2 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/speaker_repair.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      ServiceModel(
        id: 'service_009',
        name: 'Perbaikan Kamera',
        description: 'Perbaikan kamera digital dan DSLR',
        category: 'Audio & Video',
        price: 300000,
        duration: '3-5 jam',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/camera_repair.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      
      // General Services
      ServiceModel(
        id: 'service_010',
        name: 'Konsultasi Teknis',
        description: 'Konsultasi masalah teknis perangkat elektronik',
        category: 'Konsultasi',
        price: 50000,
        duration: '30 menit',
        imageUrl: 'https://res.cloudinary.com/demo/image/upload/consultation.jpg',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Check if data already exists
  Future<bool> isDataSeeded() async {
    try {
      final technicianSnapshot = await _firestore.collection('technicians').limit(1).get();
      final serviceSnapshot = await _firestore.collection('services').limit(1).get();
      
      return technicianSnapshot.docs.isNotEmpty && serviceSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking seeded data: $e');
      return false;
    }
  }

  /// Clear all seeded data (for development purposes)
  Future<void> clearSeededData() async {
    try {
      // Clear technicians
      final technicianSnapshot = await _firestore.collection('technicians').get();
      for (final doc in technicianSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear services
      final serviceSnapshot = await _firestore.collection('services').get();
      for (final doc in serviceSnapshot.docs) {
        await doc.reference.delete();
      }
      
      print('Seeded data cleared successfully');
    } catch (e) {
      print('Error clearing seeded data: $e');
    }
  }
}