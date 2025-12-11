class Validators {
  // Phone number validation (Indian format)
  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }
  
  // Email validation
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
  
  // OTP validation (6 digits)
  static bool isValidOTP(String otp) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(otp);
  }
  
  // Name validation
  static bool isValidName(String name) {
    return name.length >= 2 && name.length <= 100;
  }
  
  // Password validation
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  // Validate date of birth (must be in the past)
  static bool isValidDateOfBirth(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  // Validate gender
  static bool isValidGender(String gender) {
    final validGenders = ['Male', 'Female', 'Other'];
    return validGenders.contains(gender);
  }
  
  // Validate pincode (Indian format)
  static bool isValidPincode(String pincode) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(pincode);
  }
  
  // Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Validate phone with error message
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhone(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }
  
  // Validate email with error message
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  // Validate OTP with error message
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (!isValidOTP(value)) {
      return 'Please enter a valid 6-digit OTP';
    }
    return null;
  }
}