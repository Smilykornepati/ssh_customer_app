import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ssh_customer/firebase_options.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/booking_service.dart'; // NEW
import 'services/api_service.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => BookingService()), // NEW
      ],
      child: MaterialApp(
        title: Constants.appName,
        theme: ThemeData(
          primaryColor: Constants.primaryColor,
          scaffoldBackgroundColor: Constants.backgroundColor,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const AppLoader(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize API service
      await apiService.initialize();
      
      // Initialize Auth service
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.initialize();
      
      // Check if user is already authenticated
      final isAuthenticated = await authService.checkAuthStatus();
      
      setState(() => _isInitializing = false);
      
      if (isAuthenticated) {
        // Load user bookings
        final bookingService = Provider.of<BookingService>(context, listen: false);
        await bookingService.fetchBookings();
        
        // Navigate to home screen
        // You'll need to import your home/bottom navigation screen
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Navigate to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (error) {
      setState(() => _isInitializing = false);
      
      // Show error and navigate to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logowhite.png.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            
            // App name
            Text(
              Constants.appName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            
            // Loading indicator
            if (_isInitializing)
              const CircularProgressIndicator(
                color: Constants.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}