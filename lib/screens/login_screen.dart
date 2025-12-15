import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/custom_snackbar.dart';
import 'bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _verificationId = '';
  int? _resendToken;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (!Validators.isValidPhone(phone)) {
      _showError('Please enter a valid 10-digit mobile number');
      return;
    }

    setState(() => _isLoading = true);
    debugPrint('🔵 Sending OTP to +91$phone');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
    } catch (error) {
      debugPrint('🔴 Send OTP Error: $error');
      setState(() => _isLoading = false);
      _showError('Failed to send OTP. Please try again.');
    }
  }

  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    debugPrint('🟢 Auto verification completed');
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('🟢 Firebase sign in successful');
      
      if (userCredential.user != null) {
        final firebaseToken = await userCredential.user!.getIdToken();
        debugPrint('🟢 Got Firebase token: ${firebaseToken?.substring(0, 20)}...');
        
        if (firebaseToken != null) {
          await _verifyWithBackend(firebaseToken);
        } else {
          setState(() => _isLoading = false);
          _showError('Failed to get authentication token');
        }
      }
    } catch (error) {
      debugPrint('🔴 Auto verification error: $error');
      setState(() => _isLoading = false);
      _showError('Verification failed: $error');
    }
  }

  void _onVerificationFailed(FirebaseAuthException error) {
    debugPrint('🔴 Verification failed: ${error.code} - ${error.message}');
    setState(() => _isLoading = false);
    
    String errorMessage = 'Failed to verify phone number';
    switch (error.code) {
      case 'invalid-phone-number':
        errorMessage = 'Invalid phone number format';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many attempts. Please try again later';
        break;
      case 'quota-exceeded':
        errorMessage = 'SMS quota exceeded. Please try again later';
        break;
      case 'user-disabled':
        errorMessage = 'This user has been disabled';
        break;
      default:
        errorMessage = error.message ?? errorMessage;
    }
    
    _showError(errorMessage);
  }

  void _onCodeSent(String verificationId, int? resendToken) {
    debugPrint('🟢 OTP sent successfully. Verification ID: ${verificationId.substring(0, 20)}...');
    setState(() {
      _isLoading = false;
      _isOtpSent = true;
      _verificationId = verificationId;
      _resendToken = resendToken;
    });
    
    _showSuccess('OTP sent successfully to +91 ${_phoneController.text}');
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    debugPrint('🟡 Auto retrieval timeout');
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showError('Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);
    debugPrint('🔵 Verifying OTP: $otp');

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      debugPrint('🟢 Created phone credential');

      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('🟢 Firebase sign in successful. UID: ${userCredential.user?.uid}');
      
      if (userCredential.user != null) {
        final firebaseToken = await userCredential.user!.getIdToken();
        debugPrint('🟢 Got Firebase token: ${firebaseToken?.substring(0, 20)}...');
        
        if (firebaseToken != null) {
          await _verifyWithBackend(firebaseToken);
        } else {
          setState(() => _isLoading = false);
          _showError('Failed to get authentication token');
        }
      }
    } on FirebaseAuthException catch (error) {
      debugPrint('🔴 Firebase Auth Error: ${error.code} - ${error.message}');
      setState(() => _isLoading = false);
      
      String errorMessage = 'Invalid OTP';
      if (error.code == 'invalid-verification-code') {
        errorMessage = 'Invalid OTP entered';
      } else if (error.code == 'session-expired') {
        errorMessage = 'OTP expired. Please request a new one';
      } else {
        errorMessage = error.message ?? errorMessage;
      }
      
      _showError(errorMessage);
    } catch (error) {
      debugPrint('🔴 Unexpected error: $error');
      setState(() => _isLoading = false);
      _showError('Verification failed. Please try again.');
    }
  }

  Future<void> _verifyWithBackend(String firebaseToken) async {
    debugPrint('🔵 Starting backend verification...');
    debugPrint('Firebase Token: ${firebaseToken.substring(0, 50)}...');
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final phone = _phoneController.text.trim();
      final deviceId = await _getDeviceId();
      
      debugPrint('🔵 Phone: +91$phone');
      debugPrint('🔵 Device ID: $deviceId');
      
      final authResponse = await authService.loginWithPhone(
        firebaseToken: firebaseToken,
        phoneNumber: phone,
        deviceId: deviceId,
        fcmToken: await _getFCMToken(),
      );
      
      debugPrint('🟢 Backend verification successful!');
      debugPrint('🟢 User ID: ${authResponse.user.id}');
      debugPrint('🟢 User Name: ${authResponse.user.fullName}');
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(),
          ),
          (route) => false,
        );
      }
      
    } catch (error, stackTrace) {
      debugPrint('🔴 ============ BACKEND ERROR ============');
      debugPrint('🔴 Error Type: ${error.runtimeType}');
      debugPrint('🔴 Error Message: $error');
      debugPrint('🔴 Stack Trace: $stackTrace');
      debugPrint('🔴 =====================================');
      
      setState(() => _isLoading = false);
      
      // Show detailed error to user
      String errorMessage = 'Login failed: $error';
      if (error.toString().contains('401')) {
        errorMessage = 'Authentication failed. Please try again.';
      } else if (error.toString().contains('network') || error.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      }
      
      _showError(errorMessage);
      
      // Sign out from Firebase on error
      await _auth.signOut();
    }
  }

  Future<String> _getDeviceId() async {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<String?> _getFCMToken() async {
    return null;
  }

  Future<void> _resendOtp() async {
    setState(() {
      _otpController.clear();
      _isLoading = true;
    });
    
    await _sendOtp();
  }

  void _showError(String message) {
    if (mounted) {
      CustomSnackbar.showError(context, message);
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      CustomSnackbar.showSuccess(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logincover.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 30,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          'assets/images/logowhite.png.jpeg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOtpSent ? 'Verify OTP' : 'Login',
                        style: const TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black87
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isOtpSent
                            ? 'Enter the 6-digit code sent to\n+91 ${_phoneController.text}'
                            : 'Enter your mobile number to continue',
                        style: TextStyle(
                          fontSize: 14, 
                          color: Colors.grey[600], 
                          height: 1.5
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      if (!_isOtpSent) ...[
                        _buildPhoneInput(),
                        const SizedBox(height: 25),
                      ],
                      
                      if (_isOtpSent) ...[
                        _buildOtpInput(),
                        const SizedBox(height: 15),
                        _buildOtpActions(),
                        const SizedBox(height: 10),
                      ],
                      
                      _buildSubmitButton(),
                      const SizedBox(height: 20),
                      
                      _buildTermsText(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number', 
          style: TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w600, 
            color: Colors.black87
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const Text('🇮🇳', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    const Text(
                      '+91', 
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.black87
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(height: 30, width: 1, color: Colors.grey[300]),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                    letterSpacing: 1.2
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(
                      color: Colors.grey, 
                      fontWeight: FontWeight.w400, 
                      letterSpacing: 0
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter OTP', 
          style: TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w600, 
            color: Colors.black87
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 8
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '○ ○ ○ ○ ○ ○',
              hintStyle: TextStyle(
                color: Colors.grey, 
                fontSize: 24, 
                letterSpacing: 8
              ),
              counterText: '',
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _isLoading ? null : () {
            setState(() {
              _isOtpSent = false;
              _otpController.clear();
              _verificationId = '';
            });
          },
          child: const Text(
            'Change Number', 
            style: TextStyle(
              color: Color(0xFFE31E24), 
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _resendOtp,
          child: const Text(
            'Resend OTP', 
            style: TextStyle(
              color: Color(0xFFE31E24), 
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _sendOtp),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE31E24),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          disabledBackgroundColor: const Color(0xFFE31E24).withOpacity(0.6),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _isOtpSent ? 'Verify OTP' : 'Send OTP',
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 0.5
                ),
              ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'By continuing, you agree to our\n',
          style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
          children: const [
            TextSpan(
              text: 'Terms of Service', 
              style: TextStyle(
                color: Color(0xFFE31E24), 
                fontWeight: FontWeight.w600
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy', 
              style: TextStyle(
                color: Color(0xFFE31E24), 
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}