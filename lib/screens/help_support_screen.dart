import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
        title: const Text('Help & Support', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Us', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
                child: Column(
                  children: [
                    _buildContactTile('Call Us', '+91 1800-123-4567', Icons.phone, Colors.green, () {}),
                    _buildDivider(),
                    _buildContactTile('Email Us', 'support@sshhotels.com', Icons.email, const Color(0xFFE31E24), () {}),
                    _buildDivider(),
                    _buildContactTile('WhatsApp', 'Chat with us on WhatsApp', Icons.chat, Colors.green[700]!, () {}),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Frequently Asked Questions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 12),
              _buildFAQItem('How do I make a booking?', 'Select your preferred property type, location, dates, and number of guests. Browse available properties and click "Book Now" to complete your reservation.'),
              const SizedBox(height: 10),
              _buildFAQItem('What is the cancellation policy?', 'Cancellations made 24 hours before check-in receive a full refund. Cancellations within 24 hours are subject to a 50% cancellation fee.'),
              const SizedBox(height: 10),
              _buildFAQItem('How do I modify my booking?', 'Go to "My Bookings" section, select your booking, and click on "Modify Booking". You can change dates, number of guests, or cancel your reservation.'),
              const SizedBox(height: 10),
              _buildFAQItem('What payment methods are accepted?', 'We accept all major credit/debit cards, UPI, net banking, and digital wallets including Paytm, PhonePe, and Google Pay.'),
              const SizedBox(height: 10),
              _buildFAQItem('Is my payment information secure?', 'Yes, all transactions are encrypted using industry-standard SSL technology. We never store your card details on our servers.'),
              const SizedBox(height: 24),
              Text('Quick Actions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildQuickActionCard('Report Issue', Icons.report_problem_outlined, Colors.orange, () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickActionCard('Feedback', Icons.feedback_outlined, Colors.blue, () {})),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A202C))),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A202C))),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(answer, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A202C)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(height: 1, thickness: 1, color: Colors.grey[200]),
    );
  }
}