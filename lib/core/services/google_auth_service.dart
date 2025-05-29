import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Create or update user in Firestore
      if (userCredential.user != null) {
        await _createOrUpdateUserInFirestore(userCredential.user);
      }

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign out from Google and Firebase
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  /// Create or update user in Firestore after Google sign-in
  Future<void> _createOrUpdateUserInFirestore(User firebaseUser) async {
    try {
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      final now = DateTime.now();
      
      if (!userDoc.exists) {
        // Create new user
        final newUser = UserModel(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          profileImageUrl: firebaseUser.photoURL,
          isEmailVerified: firebaseUser.emailVerified,
          createdAt: now,
          updatedAt: now,
        );
        
        await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toMap());
      } else {
        // Update existing user
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'updatedAt': Timestamp.fromDate(now),
          'isEmailVerified': firebaseUser.emailVerified,
          if (firebaseUser.photoURL != null) 'profileImageUrl': firebaseUser.photoURL,
        });
      }
    } catch (e) {
      print('Error creating/updating user in Firestore: $e');
      rethrow;
    }
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Get user stream
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Link Google account to existing account
  Future<UserCredential?> linkWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link the credential to the current user
      final UserCredential userCredential = await _auth.currentUser!.linkWithCredential(credential);
      
      // Update user in Firestore
      if (userCredential.user != null) {
        await _updateUserAfterLinking(userCredential.user);
      }

      return userCredential;
    } catch (e) {
      print('Error linking Google account: $e');
      rethrow;
    }
  }

  /// Update user after linking Google account
  Future<void> _updateUserAfterLinking(User firebaseUser) async {
    try {
      await _firestore.collection('users').doc(firebaseUser.uid).update({
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'isEmailVerified': firebaseUser.emailVerified,
        if (firebaseUser.photoURL != null) 'profileImageUrl': firebaseUser.photoURL,
      });
    } catch (e) {
      print('Error updating user after linking: $e');
      rethrow;
    }
  }

  /// Unlink Google account
  Future<void> unlinkGoogle() async {
    try {
      await _auth.currentUser?.unlink(GoogleAuthProvider.PROVIDER_ID);
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error unlinking Google account: $e');
      rethrow;
    }
  }

  /// Check if current user has Google provider
  bool get hasGoogleProvider {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    return user.providerData.any((provider) => provider.providerId == GoogleAuthProvider.PROVIDER_ID);
  }

  /// Re-authenticate with Google (for sensitive operations)
  Future<UserCredential?> reauthenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.currentUser?.reauthenticateWithCredential(credential);
    } catch (e) {
      print('Error re-authenticating with Google: $e');
      rethrow;
    }
  }
}