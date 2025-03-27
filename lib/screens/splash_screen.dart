import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _backgroundAnimation = ColorTween(
      begin: Colors.orange.shade100,
      end: Colors.orange.shade100,
    ).animate(_animationController);

    _navigateToHome();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundAnimation.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Shimmer.fromColors(
                    baseColor: Colors.brown,
                    highlightColor: Colors.redAccent,
                    child: const Text(
                      'Welcome to My Church',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Shimmer.fromColors(
                    baseColor: Colors.brown.shade700,
                    highlightColor: Colors.redAccent,
                    child: const Text(
                      'Connecting you with your faith',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}