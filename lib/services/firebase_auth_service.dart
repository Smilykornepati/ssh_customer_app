import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Send OTP to phone number
  static Future<void> sendOTP({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String, int?) onCodeSent,
    required Function(String) onCodeAutoRetrievalTimeout,
    required BuildContext context,
  }) async {
    try {
      // Format phone number with country code
      final formattedPhone = '+91$phoneNumber';
      
      // Configure Firebase phone authentication settings
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: onVerificationCompleted,
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (error) {
      throw Exception('Failed to send OTP: $error');
    }
  }
  
  // Verify OTP
  static Future<UserCredential> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // Create PhoneAuthCredential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      
      // Sign in with credential
      return await _auth.signInWithCredential(credential);
    } catch (error) {
      throw Exception('Failed to verify OTP: $error');
    }
  }
  
  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  // Get Firebase ID token
  static Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
  
  // Sign out from Firebase
  static Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Check if user is authenticated
  static bool isAuthenticated() {
    return _auth.currentUser != null;
  }
  
  // Get phone number from Firebase user
  static String? getPhoneNumber() {
    final user = _auth.currentUser;
    if (user != null && user.phoneNumber != null) {
      // Remove country code
      return user.phoneNumber!.replaceAll('+91', '');
    }
    return null;
  }
  
  // Get Firebase UID
  static String? getUid() {
    return _auth.currentUser?.uid;
  }
  
  // Get user email
  static String? getEmail() {
    return _auth.currentUser?.email;
  }
  
  // Get display name
  static String? getDisplayName() {
    return _auth.currentUser?.displayName;
  }
  
  // Get photo URL
  static String? getPhotoURL() {
    return _auth.currentUser?.photoURL;
  }
  
  // Update user profile in Firebase
  static Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
    }
  }
  
  // Send email verification
  static Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
  
  // Reload user data
  static Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }
  
  // Stream of authentication state changes
  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
  
  // Stream of user changes
  static Stream<User?> userChanges() {
    return _auth.userChanges();
  }
  
  // Check if email is verified
  static bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }
  
  // Delete user account
  static Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
  
  // Re-authenticate user (for sensitive operations)
  static Future<void> reauthenticateWithCredential(AuthCredential credential) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reauthenticateWithCredential(credential);
    }
  }
  
  // Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}