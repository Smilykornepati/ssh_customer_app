import 'package:flutter/material.dart';
class Constants {
  // API Configuration
  static const String apiBaseUrl = 'http://customerbackend.eba-a9azu9nd.ap-southeast-2.elasticbeanstalk.com/api';
  
  // App Configuration
  static const String appName = 'SSH Hotels';
  static const String appVersion = '1.0.0';
  static const bool isDebug = true;
  
  // Colors
  static const primaryColor = Color(0xFFE31E24);
  static const secondaryColor = Color(0xFF2D3748);
  static const backgroundColor = Color(0xFFF5F7FA);
  static const textColor = Color(0xFF1A202C);
  static const accentColor = Color(0xFF4299E1);
  
  // Firebase Configuration
  static const firebaseConfig = {
    'apiKey': 'AIzaSyBDLPRwF05f77vlJ1F3JbJ2Ek8TTTCs2Qc',
    'authDomain': 'sshhotels-724c1.firebaseapp.com',
    'projectId': 'sshhotels-724c1',
    'storageBucket': 'sshhotels-724c1.firebasestorage.app',
    'messagingSenderId': '681070215434',
    'appId': '1:681070215434:android:bf0d50fa0069d992433af3',
     'iosAppId': '1:681070215434:ios:681119a2de767200433af3',
  };
  
  // Storage Keys
  static const String storageAccessToken = 'access_token';
  static const String storageRefreshToken = 'refresh_token';
  static const String storageUserId = 'user_id';
  static const String storageUserName = 'user_name';
  static const String storageUserPhone = 'user_phone';
  static const String storageUserEmail = 'user_email';
  static const String storageDeviceId = 'device_id';
  
  // API Endpoints
  static const String endpointHealth = '/health';
  static const String endpointSendOTP = '/auth/send-otp';
  static const String endpointVerifyOTP = '/auth/verify-otp';
  static const String endpointRefreshToken = '/auth/refresh-token';
  static const String endpointLogout = '/auth/logout';
  static const String endpointCheckAuth = '/auth/check';
  static const String endpointGetProfile = '/profile';
  static const String endpointUpdateProfile = '/profile';
  static const String endpointUpdateProfilePicture = '/profile/picture';
  static const String endpointDeleteAccount = '/profile/account';
  static const String endpointGetSessions = '/profile/sessions';
  static const String endpointUpdateNotifications = '/profile/notifications';
}