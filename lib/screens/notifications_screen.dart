import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _bookingUpdates = true;
  bool _specialOffers = true;
  bool _newsletter = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

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
        title: const Text('Notifications', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification Preferences', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
                child: Column(
                  children: [
                    _buildSwitchTile('Booking Updates', 'Get notified about booking confirmations and updates', Icons.bookmark_border, _bookingUpdates, (value) => setState(() => _bookingUpdates = value)),
                    _buildDivider(),
                    _buildSwitchTile('Special Offers', 'Receive exclusive deals and discounts', Icons.local_offer_outlined, _specialOffers, (value) => setState(() => _specialOffers = value)),
                    _buildDivider(),
                    _buildSwitchTile('Newsletter', 'Stay updated with travel tips and news', Icons.mail_outline, _newsletter, (value) => setState(() => _newsletter = value)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Communication Channels', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
                child: Column(
                  children: [
                    _buildSwitchTile('Push Notifications', 'Instant updates on your device', Icons.notifications_outlined, _pushNotifications, (value) => setState(() => _pushNotifications = value)),
                    _buildDivider(),
                   
                    _buildSwitchTile('SMS Notifications', 'Get text message alerts', Icons.sms_outlined, _smsNotifications, (value) => setState(() => _smsNotifications = value)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text('Recent Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 0.5)),
              const SizedBox(height: 12),
              _buildNotificationItem('Booking Confirmed', 'Your booking at Luxury Beach Resort has been confirmed', '2 hours ago', Icons.check_circle, Colors.green),
              const SizedBox(height: 10),
              _buildNotificationItem('Special Offer', 'Get 20% off on your next booking. Limited time offer!', '1 day ago', Icons.local_offer, const Color(0xFFE31E24)),
              const SizedBox(height: 10),
              _buildNotificationItem('Reminder', 'Your check-in at Mountain Paradise Resort is tomorrow', '2 days ago', Icons.access_time, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF2D3748), size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A202C))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFFE31E24)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
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