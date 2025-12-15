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
  
  Future<void> initialize() async {
    await apiService.initialize();
    await _loadUserFromStorage();
    notifyListeners();
  }
  
  Future<void> _loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('access_token') != null;
    
    if (hasToken) {
      _isAuthenticated = true;
      try {
        final response = await apiService.getProfile();
        // Backend returns profile data directly
        _currentUser = UserModel.fromJson(response);
        _currentProfile = UserProfile.fromJson(response);
      } catch (error) {
        debugPrint('Load user error: $error');
        await logout();
      }
    }
    notifyListeners();
  }
  
  // FIXED: Removed verificationId and otp parameters
  Future<AuthResponse> loginWithPhone({
    required String firebaseToken,
    required String phoneNumber,
    String? deviceId,
    String? fcmToken,
  }) async {
    try {
      // Verify with backend API - only pass what backend expects
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
      // Log error for debugging
      debugPrint('Login error: $error');
      
      // Logout from Firebase on error
      await FirebaseAuthService.signOut();
      rethrow;
    }
  }
  
  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('access_token') != null;
    
    if (hasToken) {
      try {
        await apiService.getCurrentUser();
        _isAuthenticated = true;
        
        final response = await apiService.getProfile();
        _currentUser = UserModel.fromJson(response);
        _currentProfile = response['profile'] != null
            ? UserProfile.fromJson(response['profile'])
            : null;
        
        notifyListeners();
        return true;
      } catch (error) {
        await logout();
        return false;
      }
    }
    return false;
  }
  
  Future<void> logout({bool logoutAll = false}) async {
    try {
      final deviceId = await _getDeviceId();
      await apiService.logout(logoutAll: logoutAll, deviceId: deviceId);
    } catch (error) {
      debugPrint('Logout error: $error');
    } finally {
      await FirebaseAuthService.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _isAuthenticated = false;
      _currentUser = null;
      _currentProfile = null;
      
      notifyListeners();
    }
  }
  
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    
    if (deviceId == null) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('device_id', deviceId);
    }
    
    return deviceId;
  }
  
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiService.updateProfile(data);
      
      _currentUser = UserModel.fromJson(response);
      _currentProfile = response['profile'] != null
          ? UserProfile.fromJson(response['profile'])
          : null;
      
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
  
  Future<void> updateProfilePicture(String imageUrl) async {
    try {
      await apiService.updateProfilePicture(imageUrl);
      
      if (_currentUser != null) {
        _currentUser = UserModel.fromJson({
          ..._currentUser!.toJson(),
          'profile_image_url': imageUrl,
        });
        
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
  
  Future<List<dynamic>> getUserSessions() async {
    try {
      return await apiService.getUserSessions();
    } catch (error) {
      rethrow;
    }
  }
  
  Future<String?> getFCMToken() async {
    return null;
  }
  
  Stream<bool> get authStateChanges {
    return Stream.fromFuture(Future.value(_isAuthenticated));
  }
  
  Future<void> clearAuthState() async {
    await logout();
  }
}

final authService = AuthService();