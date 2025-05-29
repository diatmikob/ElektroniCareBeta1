# ElektroniCare Flutter 🔧📱

A comprehensive electronic repair service application built with Flutter, featuring a **dual user system** for customers and technicians with modern UI/UX and complete backend integration.

## ✨ Key Highlights

🎯 **Dual User System**: Separate interfaces for Customers and Technicians  
🔐 **Google Sign-In**: Seamless authentication with Firebase  
☁️ **Cloudinary Integration**: Optimized image storage and management  
📧 **Email Notifications**: HTML email templates for updates  
📊 **Analytics Dashboard**: Comprehensive stats and earnings tracking  
🎨 **Material Design 3**: Modern and immersive interface  
🔔 **Push Notifications**: Real-time updates and alerts

## 🚀 Features

### Core Features
- **User Authentication**: Secure login/register with Firebase Auth
- **Device Repair Booking**: Easy-to-use booking system for various electronic devices
- **Real-time Tracking**: Track repair progress with live updates
- **Service Management**: Browse and select from various repair services
- **Profile Management**: Complete user profile with image upload
- **Repair History**: View all past and current repair requests
- **Notifications**: Push notifications for repair updates and appointments
- **Multi-platform Support**: Works on both Android and iOS

### Technical Features
- **Modern UI/UX**: Material Design 3 with custom theming
- **State Management**: Riverpod for efficient state management
- **Navigation**: GoRouter for declarative routing
- **Image Handling**: Camera and gallery integration for device photos
- **Form Validation**: Comprehensive form validation
- **Error Handling**: Robust error handling and user feedback
- **Offline Support**: Basic offline functionality
- **Performance Optimized**: Lazy loading and efficient rendering

## 📱 Screenshots

### Authentication Flow
- Onboarding screens with smooth animations
- Login/Register with email validation
- Forgot password functionality

### Main Features
- Dashboard with quick actions and recent repairs
- Service catalog with filtering and search
- Booking form with image upload
- Repair tracking with status updates
- User profile with edit capabilities

## 🛠 Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Material Design 3**: UI design system

### State Management & Navigation
- **Riverpod**: State management solution
- **GoRouter**: Declarative routing

### Backend & Services
- **Firebase Auth**: User authentication
- **Cloud Firestore**: NoSQL database
- **Firebase Storage**: File storage for images
- **Firebase Cloud Messaging**: Push notifications

### UI & Animations
- **Google Fonts**: Custom typography (Poppins)
- **Flutter Staggered Animations**: Smooth page transitions
- **Shimmer**: Loading animations
- **Lottie**: Vector animations

### Image & Media
- **Image Picker**: Camera and gallery access
- **Cached Network Image**: Efficient image loading
- **Flutter SVG**: SVG support

### Forms & Validation
- **Flutter Form Builder**: Advanced form handling
- **Form Builder Validators**: Input validation

### Storage
- **Shared Preferences**: Local key-value storage
- **Hive**: Local database for offline data

## 📋 Prerequisites

Before running this project, make sure you have:

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase project setup
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/elektronicare-flutter.git
cd elektronicare-flutter
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Android Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an Android app to your Firebase project
3. Download `google-services.json` and place it in `android/app/`
4. Enable Authentication, Firestore, and Storage in Firebase Console

#### iOS Setup
1. Add an iOS app to your Firebase project
2. Download `GoogleService-Info.plist` and place it in `ios/Runner/`
3. Follow Firebase iOS setup instructions

### 4. Configure Firebase Services

Enable the following Firebase services:
- **Authentication**: Email/Password provider
- **Cloud Firestore**: Database for app data
- **Storage**: For image uploads
- **Cloud Messaging**: For push notifications (optional)

### 5. Run the Application

#### Debug Mode
```bash
flutter run
```

#### Release Mode
```bash
flutter run --release
```

#### Specific Platform
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configurations
│   ├── models/            # Data models
│   ├── services/          # Firebase and API services
│   ├── theme/             # App theming
│   └── utils/             # Utility functions and routing
├── features/
│   ├── auth/              # Authentication features
│   ├── booking/           # Repair booking features
│   ├── dashboard/         # Dashboard and home features
│   ├── history/           # Repair history features
│   ├── notifications/     # Notification features
│   ├── onboarding/        # App onboarding
│   ├── profile/           # User profile features
│   └── services/          # Service catalog features
├── shared/
│   └── widgets/           # Reusable UI components
└── main.dart              # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: Blue (#2196F3)
- **Secondary**: Orange (#FF9800)
- **Success**: Green (#4CAF50)
- **Warning**: Amber (#FFC107)
- **Error**: Red (#F44336)

### Typography
- **Font Family**: Poppins
- **Weights**: 300, 400, 500, 600, 700

### Components
- Custom text fields with validation
- Loading buttons with animations
- Cards with elevation and shadows
- Bottom navigation with badges
- Modal bottom sheets
- Dialogs and alerts

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Coverage
The project includes:
- Widget tests for UI components
- Unit tests for business logic
- Integration tests for user flows
- Model tests for data validation

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
```

### App Configuration
Update `lib/core/constants/app_constants.dart` with your app-specific values:
- App name and version
- Support contact information
- Service categories
- Default settings

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Email: support@elektronicare.com
- Phone: +62 812-3456-7890
- Website: https://elektronicare.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design team for design guidelines
- Open source community for various packages used

## 📈 Roadmap

### Version 2.0
- [ ] Real-time chat with technicians
- [ ] Video call support for remote diagnosis
- [ ] AI-powered issue detection
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Technician app integration

### Version 2.1
- [ ] Payment gateway integration
- [ ] Loyalty program
- [ ] Service reviews and ratings
- [ ] Advanced analytics dashboard
- [ ] API for third-party integrations

---

Made with ❤️ by the ElektroniCare Team