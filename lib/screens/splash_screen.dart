import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String logoUrl =
        'https://ik.imagekit.io/psdoxljjy/logo-removebg-preview.png?updatedAt=1748393788409';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [const Color(0xFFF47521).withOpacity(0.15), Colors.black],
            center: Alignment.center,
            radius: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app_logo',
              child: Image.network(
                logoUrl,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.play_circle_fill,
                  size: 100,
                  color: Color(0xFFF47521),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'KAZE V1',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF47521), width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PREMIUM ANIME STREAMING',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xFFF47521),
                ),
              ),
            ),
            const SizedBox(height: 60),
            const SpinKitThreeBounce(color: Color(0xFFF47521), size: 24),
          ],
        ),
      ),
    );
  }
}
