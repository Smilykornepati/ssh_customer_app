class UserModel {
  final int id;
  final String firebaseUid;
  final String phoneNumber;
  final String? email;
  final String? fullName;
  final String? profileImageUrl;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.firebaseUid,
    required this.phoneNumber,
    this.email,
    this.fullName,
    this.profileImageUrl,
    this.isEmailVerified = false,
    this.isPhoneVerified = true,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firebaseUid: json['firebase_uid'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'],
      fullName: json['full_name'],
      profileImageUrl: json['profile_image_url'],
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'phone_number': phoneNumber,
      'email': email,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}

class UserProfile {
  final int id;
  final int userId;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> notificationSettings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.preferences = const {},
    this.notificationSettings = const {
      'email': true,
      'push': true,
      'sms': true,
    },
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
      preferences: json['preferences'] != null
          ? Map<String, dynamic>.from(json['preferences'])
          : {},
      notificationSettings: json['notification_settings'] != null
          ? Map<String, dynamic>.from(json['notification_settings'])
          : {
              'email': true,
              'push': true,
              'sms': true,
            },
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'preferences': preferences,
      'notification_settings': notificationSettings,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class AuthResponse {
  final UserModel user;
  final UserProfile? profile;
  final AuthTokens tokens;

  AuthResponse({
    required this.user,
    this.profile,
    required this.tokens,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user']),
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
      tokens: AuthTokens.fromJson(json['tokens']),
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }
}