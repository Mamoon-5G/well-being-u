import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbeingu/providers/auth_provider.dart';
import 'package:wellbeingu/screens/auth/login_screen.dart';
import 'package:wellbeingu/screens/home/home_screen.dart';
import 'package:wellbeingu/config/theme.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay to show splash screen
    Future.delayed(const Duration(seconds: 3), () {
      _checkAuth();
    });
  }

  void _checkAuth() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Here we would use a Lottie animation
            // Replace this with your own animation file in assets/animations/
            Lottie.asset(
              'assets/animations/wellbeing.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              // Add placeholder for first run when asset might not exist
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.favorite, size: 100, color: Colors.white);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'WellBeingU',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your path to mental & nutritional wellness',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
