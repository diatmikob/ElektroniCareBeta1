class AppConstants {
  // App Info
  static const String appName = 'ElektroniCare';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Electronic Repair Service App';
  
  // API & Services
  static const String baseUrl = 'https://api.elektronicare.com';
  static const String cloudinaryCloudName = 'elektronicare';
  static const String cloudinaryUploadPreset = 'elektronicare_uploads';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String servicesCollection = 'services';
  static const String repairsCollection = 'repairs';
  static const String techniciansCollection = 'technicians';
  static const String notificationsCollection = 'notifications';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String onboardingKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // UI Constants
  static const double defaultPadding = 16;
  static const double smallPadding = 8;
  static const double largePadding = 24;
  static const double borderRadius = 12;
  static const double cardElevation = 4;
  
  // Service Categories
  static const List<String> serviceCategories = [
    'Smartphone',
    'Laptop',
    'TV',
    'Audio',
    'Gaming',
    'Appliances',
    'Others',
  ];
  
  // Repair Status
  static const List<String> repairStatuses = [
    'pending',
    'confirmed',
    'in_progress',
    'completed',
    'cancelled',
  ];
  
  // Contact Info
  static const String supportEmail = 'support@elektronicare.com';
  static const String supportPhone = '+62 812-3456-7890';
  static const String whatsappNumber = '6281234567890';
  
  // Social Media
  static const String instagramUrl = 'https://instagram.com/elektronicare';
  static const String facebookUrl = 'https://facebook.com/elektronicare';
  static const String twitterUrl = 'https://twitter.com/elektronicare';
  
  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String authError = 'Authentication failed. Please login again.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String repairRequestSuccess = 'Repair request submitted successfully!';
}