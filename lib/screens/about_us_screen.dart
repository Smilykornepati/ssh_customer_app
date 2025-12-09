import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
        title: const Text('About Us', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE31E24),
                    const Color(0xFFE31E24).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logowhite.png.jpeg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.hotel, size: 100, color: Color(0xFFE31E24));
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'SSH Short Stay Hotels',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Stay Short, Pay Smart',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Our Story
                  _buildSectionCard(
                    icon: Icons.history,
                    iconColor: const Color(0xFFE31E24),
                    title: 'Our Story',
                    content: 'Founded in 2025 by Niranjani Reddy in Bangalore, SSH Short Stay Hotels was born from a vision to revolutionize the hospitality industry. We recognized the need for flexible, affordable, and quality accommodations for travelers who need a place to stay for just a few hours.',
                  ),
                  const SizedBox(height: 15),
                  
                  // Our Mission
                  _buildSectionCard(
                    icon: Icons.flag,
                    iconColor: Colors.blue,
                    title: 'Our Mission',
                    content: 'To provide travelers with comfortable, hygienic, and affordable short-stay accommodations without compromising on quality. We believe in making hospitality accessible to everyone, whether you need a quick rest between meetings or a few hours to refresh during a long journey.',
                  ),
                  const SizedBox(height: 15),
                  
                  // What We Offer
                  _buildSectionCard(
                    icon: Icons.apartment,
                    iconColor: Colors.green,
                    title: 'What We Offer',
                    content: 'From luxurious resorts to modern co-living spaces and comfortable hotels, we partner with premium properties across India to give you the flexibility to book by the hour. Our platform makes it easy to find, book, and enjoy quality accommodations on your schedule.',
                  ),
                  const SizedBox(height: 15),
                  
                  // Our Values
                  _buildSectionCard(
                    icon: Icons.verified,
                    iconColor: Colors.orange,
                    title: 'Our Values',
                    content: 'Transparency, Quality, and Customer Satisfaction drive everything we do. We carefully vet every property on our platform to ensure they meet our high standards for cleanliness, safety, and service.',
                  ),
                  const SizedBox(height: 30),
                  
                  // Stats Section
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
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE31E24).withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Our Journey So Far',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A202C),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('50+', 'Properties'),
                            _buildStatItem('15+', 'Cities'),
                            _buildStatItem('1000+', 'Happy Guests'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Founder Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE31E24).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFFE31E24),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'C. Niranjani Reddy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A202C),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Founder & CEO',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Bangalore, Karnataka',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Contact Section
                  const Text(
                    'Get In Touch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildContactItem(Icons.location_on, 'Bangalore, Karnataka, India'),
                  const SizedBox(height: 10),
                  _buildContactItem(Icons.email, 'info@sshhotels.com'),
                  const SizedBox(height: 10),
                  _buildContactItem(Icons.phone, '+91 1800-123-4567'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE31E24),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE31E24), size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}