import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Aligns content to the center
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with animated effect
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.store,
                size: 120,
                color: Colors.white, // Color of the icon
              ),
            ),
            const SizedBox(height: 30),  // Adds spacing between icon and text

            // Text with better styling
            Text(
              "Selamat Datang di Marketplace Sekolah",
              style: TextStyle(
                fontSize: 28,  // Slightly smaller font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,  // Italic style for a modern look
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),  // Shadow effect for text
                    offset: Offset(2.0, 2.0),  // Shadow offset
                  ),
                ],
              ),
              textAlign: TextAlign.center,  // Center-align text
            ),
          ],
        ),
      ),
    );
  }
}
