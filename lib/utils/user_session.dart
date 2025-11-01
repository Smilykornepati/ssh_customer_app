class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String? _userName;
  String? _userPhone;
  String? _userEmail;

  void setUserData({String? name, String? phone, String? email}) {
    _userName = name;
    _userPhone = phone;
    _userEmail = email;
  }

  String get userName => _userName ?? 'User';
  String get userPhone => _userPhone ?? '';
  String get userEmail => _userEmail ?? '';
  
  bool get hasUserData => _userName != null && _userPhone != null;
}