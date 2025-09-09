import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Green tick animation (use lottie animation for nice look)
            SizedBox(
              height: 250,
              width: 250,
              child: Lottie.asset('assets/success_tick.json'), // download from lottiefiles.com
            ),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB8860B),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Thank you for your donation!",
              style: TextStyle(fontSize: 25, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back or go to home screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Done", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}