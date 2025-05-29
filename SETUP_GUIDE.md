# 🚀 ElektroniCare Flutter Setup Guide

Complete setup guide for the ElektroniCare Flutter application with dual user system.

## 📋 Prerequisites

Before starting, ensure you have:

- **Flutter SDK**: 3.32.0 or higher
- **Dart SDK**: 3.8.0 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control
- **Firebase account** (free tier is sufficient)
- **Cloudinary account** (free tier is sufficient)
- **Gmail account** for email notifications

## 🔧 Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone https://github.com/diatmikob/ElektroniCareBeta1.git
cd elektronicare-flutter
git checkout flutter-complete-app
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `elektronicare-app`
4. Enable Google Analytics (optional)
5. Create project

#### 3.2 Enable Firebase Services

In your Firebase project console:

1. **Authentication**:
   - Go to Authentication > Sign-in method
   - Enable "Email/Password"
   - Enable "Google" (download config files)

2. **Firestore Database**:
   - Go to Firestore Database
   - Create database in test mode
   - Choose location closest to your users

3. **Storage**:
   - Go to Storage
   - Get started with default rules

4. **Cloud Messaging**:
   - Go to Cloud Messaging
   - No additional setup needed

#### 3.3 Add Android App

1. In Firebase Console, click "Add app" > Android
2. Enter package name: `com.elektronicare.flutter`
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### 3.4 Add iOS App

1. In Firebase Console, click "Add app" > iOS
2. Enter bundle ID: `com.elektronicare.flutter`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

#### 3.5 Update Firebase Configuration

Update `lib/firebase_options.dart` with your project settings:

```dart
// Replace with your Firebase project configuration
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your_android_api_key',
  appId: 'your_android_app_id',
  messagingSenderId: 'your_messaging_sender_id',
  projectId: 'your_project_id',
  storageBucket: 'your_project_id.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your_ios_api_key',
  appId: 'your_ios_app_id',
  messagingSenderId: 'your_messaging_sender_id',
  projectId: 'your_project_id',
  storageBucket: 'your_project_id.appspot.com',
  iosBundleId: 'com.elektronicare.flutter',
);
```

### 4. Cloudinary Setup

#### 4.1 Create Cloudinary Account

1. Go to [Cloudinary](https://cloudinary.com/)
2. Sign up for free account
3. Note your Cloud Name from dashboard

#### 4.2 Create Upload Preset

1. Go to Settings > Upload
2. Click "Add upload preset"
3. Set preset name: `elektronicare_uploads`
4. Set signing mode: "Unsigned"
5. Save preset

#### 4.3 Update Cloudinary Configuration

Update `lib/core/services/cloudinary_service.dart`:

```dart
class CloudinaryService {
  static const String cloudName = 'your_cloud_name'; // Replace with your cloud name
  static const String uploadPreset = 'elektronicare_uploads'; // Or your preset name
  
  // ... rest of the code
}
```

### 5. Email Service Setup

#### 5.1 Enable Gmail App Passwords

1. Go to [Google Account Settings](https://myaccount.google.com/)
2. Security > 2-Step Verification (enable if not already)
3. App passwords > Generate new password
4. Select "Mail" and "Other (custom name)"
5. Copy the generated 16-character password

#### 5.2 Update Email Configuration

Update `lib/core/services/email_service.dart`:

```dart
class EmailService {
  static const String smtpUsername = 'your_email@gmail.com'; // Your Gmail
  static const String smtpPassword = 'your_app_password'; // 16-character app password
  
  // ... rest of the code
}
```

### 6. Google Sign-In Setup

#### 6.1 Android Configuration

The `google-services.json` file already contains the necessary configuration.

#### 6.2 iOS Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Add `GoogleService-Info.plist` to the Runner target
3. Update `ios/Runner/Info.plist` with URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from `GoogleService-Info.plist`.

### 7. Run the Application

#### 7.1 Check Flutter Setup

```bash
flutter doctor
```

Fix any issues reported by Flutter Doctor.

#### 7.2 Run on Android

```bash
flutter run -d android
```

#### 7.3 Run on iOS

```bash
flutter run -d ios
```

### 8. Initialize Sample Data

The app includes a seeder service that will automatically create sample data on first run:

- **Sample Technicians**:
  - satriawiangga200@gmail.com
  - satrialingga702@gmail.com

- **Sample Services**:
  - Smartphone Screen Repair
  - Laptop Keyboard Replacement
  - Tablet Battery Replacement
  - And 7 more services

### 9. Testing the Application

#### 9.1 Customer Flow

1. Open the app
2. Sign up with a new email or use Google Sign-In
3. Select "Customer" user type
4. Browse services and create a booking
5. Track repair progress

#### 9.2 Technician Flow

1. Open the app
2. Sign in with technician email (satriawiangga200@gmail.com)
3. Select "Technician" user type
4. View dashboard with stats
5. Manage incoming requests

### 10. Troubleshooting

#### Common Issues

1. **Firebase Connection Issues**:
   - Verify `google-services.json` and `GoogleService-Info.plist` are in correct locations
   - Check package name/bundle ID matches Firebase configuration

2. **Cloudinary Upload Fails**:
   - Verify cloud name and upload preset are correct
   - Check upload preset is set to "unsigned"

3. **Email Notifications Not Working**:
   - Verify Gmail app password is correct
   - Check 2-step verification is enabled

4. **Google Sign-In Issues**:
   - Verify SHA-1 fingerprint is added to Firebase (Android)
   - Check URL scheme is correct (iOS)

#### Getting SHA-1 Fingerprint (Android)

```bash
# Debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release keystore (if you have one)
keytool -list -v -keystore /path/to/your/keystore.jks -alias your_alias
```

Add the SHA-1 fingerprint to Firebase Console > Project Settings > Your Android App.

### 11. Building for Production

#### Android APK

```bash
flutter build apk --release
```

#### Android App Bundle

```bash
flutter build appbundle --release
```

#### iOS

```bash
flutter build ios --release
```

### 12. Environment Variables (Optional)

For better security, create a `.env` file:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_upload_preset
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
FIREBASE_PROJECT_ID=your_project_id
```

Then update the service files to read from environment variables.

## 🎉 Congratulations!

Your ElektroniCare Flutter app is now ready to use! The app includes:

- ✅ Dual user system (Customer + Technician)
- ✅ Google Sign-In authentication
- ✅ Cloudinary image storage
- ✅ Email notifications
- ✅ Firebase backend integration
- ✅ Modern Material Design 3 UI
- ✅ Push notifications support
- ✅ Sample data for testing

## 📞 Support

If you encounter any issues during setup:

1. Check the troubleshooting section above
2. Review Firebase and Cloudinary documentation
3. Create an issue on the GitHub repository
4. Contact: diatmikob@gmail.com

## 🔄 Next Steps

- Customize the app branding and colors
- Add more service categories
- Implement payment gateway
- Add real-time chat features
- Deploy to app stores

---

**Happy coding! 🚀**