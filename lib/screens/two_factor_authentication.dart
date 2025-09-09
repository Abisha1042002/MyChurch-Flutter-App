import 'package:flutter/material.dart';

class Enable2FAScreen extends StatefulWidget {
  final String userEmail;

  const Enable2FAScreen({super.key, required this.userEmail});

  @override
  State<Enable2FAScreen> createState() => _Enable2FAScreenState();
}

class _Enable2FAScreenState extends State<Enable2FAScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isVerified = false;
  String _generatedOtp = '';

  void _sendOtp() {
    // Simulate OTP generation
    setState(() {
      _generatedOtp = '123456'; // Simulated OTP
      _otpSent = true;
      _isVerified = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to ${widget.userEmail}')),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.trim() == _generatedOtp) {
      setState(() {
        _isVerified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('2FA enabled successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enable Two-Factor Authentication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Enable 2FA for: ${widget.userEmail}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _sendOtp,
              icon: const Icon(Icons.sms),
              label: const Text("Send OTP"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
            const SizedBox(height: 30),
            if (_otpSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text("Verify OTP"),
              ),
            ],
            if (_isVerified) ...[
              const SizedBox(height: 30),
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 10),
              const Text(
                "Two-Factor Authentication Enabled!",
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
            ]
          ],
        ),
      ),
    );
  }
}