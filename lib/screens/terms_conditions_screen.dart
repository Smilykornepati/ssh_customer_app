import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE31E24).withOpacity(0.1),
                      const Color(0xFFE31E24).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFE31E24).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31E24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Terms of Service',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Effective: November 2025',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Section 1: Acceptance of Terms
              _buildSection(
                '1. Acceptance of Terms',
                'By accessing and using SSH Short Stay Hotels platform, you accept and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our services.',
              ),
              const SizedBox(height: 20),

              // Section 2: User Eligibility
              _buildSection(
                '2. User Eligibility',
                'You must be at least 18 years old to use our services. By using this platform, you represent that:\n\n• You are of legal age to form a binding contract\n• All information provided is accurate and current\n• You will maintain the security of your account\n• You will comply with all applicable laws',
              ),
              const SizedBox(height: 20),

              // Section 3: Booking and Payments
              _buildSection(
                '3. Booking and Payments',
                'When making a booking:\n\n• All prices are in Indian Rupees (INR)\n• Prices include applicable taxes unless stated otherwise\n• Full payment is required at the time of booking\n• We accept credit/debit cards, UPI, and digital wallets\n• Booking confirmation will be sent via email and SMS\n• You must present valid ID at check-in',
              ),
              const SizedBox(height: 20),

              // Section 4: Cancellation and Refund Policy
              _buildSection(
                '4. Cancellation and Refund Policy',
                'Cancellation terms:\n\n• Free cancellation up to 24 hours before check-in\n• 50% refund for cancellations within 24 hours\n• No refund for no-shows\n• Refunds processed within 7-10 business days\n• Some properties may have different policies\n• Force majeure situations handled case-by-case',
              ),
              const SizedBox(height: 20),

              // Section 5: User Conduct
              _buildSection(
                '5. User Conduct',
                'You agree to:\n\n• Use services only for lawful purposes\n• Respect property rules and regulations\n• Not damage or misuse property facilities\n• Maintain peaceful conduct\n• Not engage in illegal activities\n• Comply with maximum occupancy limits\n\nViolation may result in immediate eviction and account termination.',
              ),
              const SizedBox(height: 20),

              // Section 6: Property Partner Obligations
              _buildSection(
                '6. Property Partner Obligations',
                'Property partners must:\n\n• Maintain advertised standards\n• Provide accurate property information\n• Honor confirmed bookings\n• Maintain cleanliness and hygiene\n• Comply with safety regulations\n• Respond promptly to guest issues',
              ),
              const SizedBox(height: 20),

              // Section 7: Liability and Disclaimers
              _buildSection(
                '7. Liability and Disclaimers',
                'SSH Short Stay Hotels:\n\n• Acts as an intermediary platform\n• Is not responsible for property quality\n• Cannot guarantee availability\n• Is not liable for property-related incidents\n• Does not control property operations\n• Recommends travel insurance for guests',
              ),
              const SizedBox(height: 20),

              // Section 8: Intellectual Property
              _buildSection(
                '8. Intellectual Property',
                'All content on our platform, including logos, text, images, and software, is protected by intellectual property laws. You may not:\n\n• Copy or reproduce content without permission\n• Use our branding without authorization\n• Reverse engineer our software\n• Create derivative works',
              ),
              const SizedBox(height: 20),

              // Section 9: Dispute Resolution
              _buildSection(
                '9. Dispute Resolution',
                'Any disputes arising from use of our services will be:\n\n• First attempted through customer support\n• Subject to mediation if unresolved\n• Governed by Indian laws\n• Subject to Bangalore jurisdiction\n• Resolved through binding arbitration if necessary',
              ),
              const SizedBox(height: 20),

              // Section 10: Modifications
              _buildSection(
                '10. Modifications',
                'We reserve the right to modify these terms at any time. Changes become effective immediately upon posting. Continued use after modifications constitutes acceptance of updated terms.',
              ),
              const SizedBox(height: 30),

              // Contact Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Questions About Terms?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'For clarifications regarding these terms, contact us at:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: Color(0xFFE31E24),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'legal@sshhotels.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}