import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import './api_service.dart';
import './firebase_auth_service.dart';
import '../utils/constants.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  UserProfile? _currentProfile;
  
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  UserProfile? get currentProfile => _currentProfile;
  
  // Initialize auth service
  Future<void> initialize() async {
    await apiService.initialize();
    await _loadUserFromStorage();
    notifyListeners();
  }
  
  // Load user from shared preferences
  Future<void> _loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('access_token') != null;
    
    if (hasToken) {
      _isAuthenticated = true;
      // Optionally load user data from API
      try {
        final response = await apiService.getProfile();
        _currentUser = UserModel.fromJson(response['user']);
        _currentProfile = response['profile'] != null
            ? UserProfile.fromJson(response['profile'])
            : null;
      } catch (error) {
        // Token might be expired
        await logout();
      }
    }
    notifyListeners();
  }
  
  // Login with Firebase OTP
  Future<AuthResponse> loginWithPhone({
    required String firebaseToken,
    required String phoneNumber,
    required String verificationId,
    required String otp,
    String? deviceId,
    String? fcmToken,
  }) async {
    try {
      // Verify with backend API
      final authResponse = await apiService.verifyOTP(
        firebaseToken: firebaseToken,
        phoneNumber: phoneNumber,
        deviceId: deviceId,
        fcmToken: fcmToken,
      );
      
      // Update local state
      _isAuthenticated = true;
      _currentUser = authResponse.user;
      _currentProfile = authResponse.profile;
      
      // Store user data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_phone', phoneNumber);
      if (authResponse.user.fullName != null) {
        await prefs.setString('user_name', authResponse.user.fullName!);
      }
      if (authResponse.user.email != null) {
        await prefs.setString('user_email', authResponse.user.email!);
      }
      
      notifyListeners();
      return authResponse;
    } catch (error) {
      // Logout from Firebase on error
      await FirebaseAuthService.signOut();
      rethrow;
    }
  }
  
  // Check authentication status
  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('access_token') != null;
    
    if (hasToken) {
      try {
        // Verify token is still valid
        await apiService.getCurrentUser();
        _isAuthenticated = true;
        
        // Load user data
        final response = await apiService.getProfile();
        _currentUser = UserModel.fromJson(response['user']);
        _currentProfile = response['profile'] != null
            ? UserProfile.fromJson(response['profile'])
            : null;
        
        notifyListeners();
        return true;
      } catch (error) {
        // Token expired or invalid
        await logout();
        return false;
      }
    }
    return false;
  }
  
  // Logout
  Future<void> logout({bool logoutAll = false}) async {
    try {
      // Logout from backend
      final deviceId = await _getDeviceId();
      await apiService.logout(logoutAll: logoutAll, deviceId: deviceId);
    } catch (error) {
      // Continue with local logout even if API fails
    } finally {
      // Clear Firebase session
      await FirebaseAuthService.signOut();
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Reset state
      _isAuthenticated = false;
      _currentUser = null;
      _currentProfile = null;
      
      notifyListeners();
    }
  }
  
  // Get device ID
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    
    if (deviceId == null) {
      // Generate new device ID
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('device_id', deviceId);
    }
    
    return deviceId;
  }
  
  // Update user profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiService.updateProfile(data);
      
      // Update local state
      _currentUser = UserModel.fromJson(response['user']);
      _currentProfile = response['profile'] != null
          ? UserProfile.fromJson(response['profile'])
          : null;
      
      // Update shared preferences
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser!.fullName != null) {
        await prefs.setString('user_name', _currentUser!.fullName!);
      }
      if (_currentUser!.email != null) {
        await prefs.setString('user_email', _currentUser!.email!);
      }
      
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
  
  // Update profile picture
  Future<void> updateProfilePicture(String imageUrl) async {
    try {
      await apiService.updateProfilePicture(imageUrl);
      
      // Update local state
      if (_currentUser != null) {
        _currentUser = UserModel.fromJson({
          ..._currentUser!.toJson(),
          'profile_image_url': imageUrl,
        });
        
        // Update Firebase profile
        await FirebaseAuthService.updateProfile(
          photoURL: imageUrl,
          displayName: _currentUser!.fullName,
        );
        
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
  
  // Get user sessions
  Future<List<dynamic>> getUserSessions() async {
    try {
      return await apiService.getUserSessions();
    } catch (error) {
      rethrow;
    }
  }
  
  // Get FCM token (placeholder - implement with firebase_messaging)
  Future<String?> getFCMToken() async {
    // Implementation depends on firebase_messaging package
    return null;
  }
  
  // Listen to auth state changes
  Stream<bool> get authStateChanges {
    return Stream.fromFuture(Future.value(_isAuthenticated));
  }
  
  // Clear auth state (for testing/debugging)
  Future<void> clearAuthState() async {
    await logout();
  }
}

// Singleton instance
final authService = AuthService();