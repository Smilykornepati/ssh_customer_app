import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final String baseUrl = Constants.apiBaseUrl;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized
        if (error.response?.statusCode == 401) {
          final refreshToken = prefs.getString('refresh_token');
          if (refreshToken != null) {
            try {
              // Try to refresh token
              final newTokens = await refreshAuthToken(refreshToken);
              if (newTokens != null) {
                // Update request with new token
                error.requestOptions.headers['Authorization'] = 
                    'Bearer ${newTokens.accessToken}';
                // Retry the request
                return handler.resolve(
                  await _dio.fetch(error.requestOptions),
                );
              }
            } catch (e) {
              // Refresh failed, logout user
              await logout();
            }
          }
        }
        return handler.next(error);
      },
    ));

    // Add logger for debugging
    if (Constants.isDebug) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }
  }

  // Auth APIs
  Future<AuthResponse> verifyOTP({
    required String firebaseToken,
    required String phoneNumber,
    String? deviceId,
    String? fcmToken,
  }) async {
    final response = await _dio.post('/auth/verify-otp', data: {
      'firebase_token': firebaseToken,
      'phone_number': phoneNumber,
      'device_id': deviceId,
      'fcm_token': fcmToken,
      'device_type': 'mobile',
      'user_agent': 'Flutter App',
    });

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(response.data['data']);
      
      // Store tokens
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', authResponse.tokens.accessToken);
      await prefs.setString('refresh_token', authResponse.tokens.refreshToken);
      await prefs.setInt('user_id', authResponse.user.id);
      
      return authResponse;
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  Future<AuthTokens?> refreshAuthToken(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh-token', data: {
        'refresh_token': refreshToken,
      });

      if (response.statusCode == 200) {
        final tokens = AuthTokens.fromJson(response.data['data']);
        
        // Store new tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', tokens.accessToken);
        await prefs.setString('refresh_token', tokens.refreshToken);
        
        return tokens;
      }
    } catch (error) {
      print('Token refresh failed: $error');
    }
    return null;
  }

  Future<void> logout({bool logoutAll = false, String? deviceId}) async {
    try {
      await _dio.post('/auth/logout', data: {
        'logout_all': logoutAll,
        'device_id': deviceId,
      });
    } finally {
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get('/auth/check');
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']['user']);
    } else {
      throw Exception('Failed to get user');
    }
  }

  // Profile APIs
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get('/profile');
    
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Failed to get profile');
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put('/profile', data: data);
    
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> updateProfilePicture(String imageUrl) async {
    final response = await _dio.put('/profile/picture', data: {
      'profile_image_url': imageUrl,
    });
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile picture');
    }
  }

  Future<void> deleteAccount() async {
    final response = await _dio.delete('/profile/account');
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete account');
    }
  }

  Future<List<dynamic>> getUserSessions() async {
    final response = await _dio.get('/profile/sessions');
    
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception('Failed to get sessions');
    }
  }

  Future<void> updateNotificationPreferences(Map<String, dynamic> preferences) async {
    final response = await _dio.put('/profile/notifications', data: {
      'preferences': preferences,
    });
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update notification preferences');
    }
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  // Helper method for error handling
  String getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'];
        }
      }
      return error.message ?? 'Network error occurred';
    }
    return error.toString();
  }
}

// Singleton instance
final apiService = ApiService();