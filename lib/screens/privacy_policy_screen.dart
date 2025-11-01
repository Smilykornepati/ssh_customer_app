import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  border: Border.all(color: const Color(0xFFE31E24).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31E24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.privacy_tip, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Privacy Matters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Last updated: November 2025',
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
              _buildSection(
                '1. Information We Collect',
                'We collect information you provide directly to us, including:\n\n• Personal information (name, email, phone number)\n• Payment information\n• Booking details and preferences\n• Device and usage information\n• Location data (with your permission)',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '2. How We Use Your Information',
                'We use the information we collect to:\n\n• Process your bookings and payments\n• Communicate with you about your reservations\n• Send you promotional offers (with your consent)\n• Improve our services and user experience\n• Comply with legal obligations\n• Prevent fraud and ensure platform security',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '3. Information Sharing',
                'We may share your information with:\n\n• Property partners to facilitate bookings\n• Payment processors for transaction handling\n• Service providers who assist our operations\n• Law enforcement when required by law\n\nWe never sell your personal information to third parties.',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '4. Data Security',
                'We implement industry-standard security measures to protect your data:\n\n• SSL encryption for all transactions\n• Secure servers and databases\n• Regular security audits\n• Limited access to personal information\n• Two-factor authentication options',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '5. Your Rights',
                'You have the right to:\n\n• Access your personal data\n• Request corrections to your information\n• Delete your account and data\n• Opt-out of marketing communications\n• Export your data\n• Lodge complaints with data protection authorities',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '6. Cookies and Tracking',
                'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze site traffic and usage\n• Personalize content and ads\n• Improve platform performance\n\nYou can control cookie settings in your browser.',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '7. Children\'s Privacy',
                'Our services are not intended for users under 18 years of age. We do not knowingly collect information from children. If you believe we have collected information from a child, please contact us immediately.',
              ),
              const SizedBox(height: 20),
              _buildSection(
                '8. Changes to This Policy',
                'We may update this Privacy Policy periodically. We will notify you of significant changes via email or app notification. Continued use of our services after changes constitutes acceptance of the updated policy.',
              ),
              const SizedBox(height: 30),
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
                      'Questions About Privacy?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'If you have any questions about this Privacy Policy, please contact us at:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Color(0xFFE31E24), size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'privacy@sshhotels.com',
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