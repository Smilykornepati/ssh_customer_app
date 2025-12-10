// razorpay_service.dart
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  
  // TODO: Replace with your correct Razorpay key
  static const String _razorpayKey = 'rzp_test_RpCBfTtB7Lga2z';
  
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;
  Function(ExternalWalletResponse)? onWallet;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onWallet?.call(response);
  }

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': _razorpayKey,
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': 'SSH Hotels',
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'theme': {
        'color': '#E31E24'
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'googlepay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}

// payment_screen.dart - Add this to property_detail_screen.dart
class PaymentHandler {
  final BuildContext context;
  final RazorpayService razorpayService = RazorpayService();

  PaymentHandler(this.context) {
    razorpayService.onSuccess = _handlePaymentSuccess;
    razorpayService.onFailure = _handlePaymentError;
    razorpayService.onWallet = _handleExternalWallet;
  }

  void initiatePayment({
    required double amount,
    required String propertyName,
    required String contact,
    required String email,
  }) {
    razorpayService.openCheckout(
      amount: amount,
      name: propertyName,
      description: 'Booking at $propertyName',
      contact: contact,
      email: email,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your booking has been confirmed!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment ID',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    response.paymentId ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31E24),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet: ${response.walletName}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void dispose() {
    razorpayService.dispose();
  }
}