import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'favourites_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'about_us_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'login_screen.dart';
import '../widgets/custom_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.checkAuthStatus();
      
      if (authService.isAuthenticated) {
        setState(() {
          _isLoading = false;
        });
      } else {
        // Not authenticated, navigate to login
        _navigateToLogin();
      }
    } catch (error) {
      setState(() => _isLoading = false);
      _showError('Failed to load profile');
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _handleLogout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await authService.logout();
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
                
                _showSuccess('Logged out successfully');
              } catch (error) {
                _showError('Logout failed');
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFE31E24),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogoutAllDevices() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout All Devices',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('This will log you out from all devices. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final authService = Provider.of<AuthService>(context, listen: false);
              
              try {
                await authService.logout(logoutAll: true);
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
                
                _showSuccess('Logged out from all devices');
              } catch (error) {
                _showError('Logout failed');
              }
            },
            child: const Text(
              'Logout All',
              style: TextStyle(
                color: Color(0xFFE31E24),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    CustomSnackbar.showError(context, message);
  }

  void _showSuccess(String message) {
    CustomSnackbar.showSuccess(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE31E24),
          ),
        ),
      );
    }

    if (!authService.isAuthenticated) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              Text(
                'Session Expired',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please login again',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _navigateToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE31E24),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Login Again'),
              ),
            ],
          ),
        ),
      );
    }

    final user = authService.currentUser;
    final profile = authService.currentProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Show profile picture options
                          _showProfilePictureOptions();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE31E24).withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: const Color(0xFFF5F7FA),
                            backgroundImage: user?.profileImageUrl != null
                                ? NetworkImage(user!.profileImageUrl!)
                                : null,
                            child: user?.profileImageUrl == null
                                ? const Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Color(0xFF2D3748),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user?.fullName ?? 'User',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+91 ${user?.phoneNumber ?? 'Loading...'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (user?.email != null)
                        Text(
                          user!.email!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          Icons.person_outline,
                          'Edit Profile',
                          'Update your personal information',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.favorite_border,
                          'Favorites',
                          'View your saved properties',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritesScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.notifications_outlined,
                          'Notifications',
                          'Manage notification preferences',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.devices_outlined,
                          'Active Sessions',
                          'Manage your active devices',
                          () => _showActiveSessions(),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.logout_outlined,
                          'Logout All Devices',
                          'Logout from all devices',
                          _handleLogoutAllDevices,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Support Section
                  Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          Icons.help_outline,
                          'Help & Support',
                          'Get help with your bookings',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.bug_report_outlined,
                          'Report a Bug',
                          'Report issues with the app',
                          () => _reportBug(),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.star_outline,
                          'Rate App',
                          'Rate us on Play Store/App Store',
                          () => _rateApp(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About Section
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          Icons.info_outline,
                          'About Us',
                          'Learn more about SSH Hotels',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.privacy_tip_outlined,
                          'Privacy Policy',
                          'Read our privacy policy',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          Icons.description_outlined,
                          'Terms & Conditions',
                          'View terms of service',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsConditionsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE31E24),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Version $_appVersion',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: _checkForUpdates,
                          child: Text(
                            'Check for updates',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[400],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2D3748),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A202C),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[200],
      ),
    );
  }

  void _showProfilePictureOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
            ),
            if (Provider.of<AuthService>(context, listen: false)
                .currentUser
                ?.profileImageUrl !=
                null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfilePicture();
                },
              ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    // Implement camera functionality using image_picker
    _showSuccess('Camera functionality to be implemented');
  }

  Future<void> _chooseFromGallery() async {
    // Implement gallery picker using image_picker
    _showSuccess('Gallery functionality to be implemented');
  }

  Future<void> _removeProfilePicture() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      await authService.updateProfilePicture('');
      _showSuccess('Profile picture removed');
    } catch (error) {
      _showError('Failed to remove profile picture');
    }
  }

 // In the _showActiveSessions method (around line 721), replace it with:

Future<void> _showActiveSessions() async {
  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final sessions = await authService.getUserSessions(); // This should work now
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: SizedBox(
          width: double.maxFinite,
          child: sessions.isEmpty
              ? const Text('No active sessions found')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      title: Text(session['device_type']?.toString() ?? 'Unknown Device'),
                      subtitle: Text(
                        'Last active: ${_formatDate(session['last_active_at']?.toString())}',
                      ),
                      trailing: session['is_active'] == true
                          ? const Icon(Icons.circle, color: Colors.green, size: 12)
                          : const Icon(Icons.circle, color: Colors.grey, size: 12),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  } catch (error) {
    _showError('Failed to load sessions');
  }
}

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _reportBug() {
    // Implement bug reporting
    _showSuccess('Bug reporting to be implemented');
  }

  void _rateApp() {
    // Implement app rating
    _showSuccess('App rating to be implemented');
  }

  void _checkForUpdates() {
    // Implement update check
    _showSuccess('App is up to date');
  }
}