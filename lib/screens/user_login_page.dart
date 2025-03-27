import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_church/screens/donation_screen.dart';
import 'package:my_church/screens/user_register_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔐 Authenticate user from Firestore
  void _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    QuerySnapshot query = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();

    if (query.docs.isNotEmpty) {
      // Save user login info
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DonationPage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserRegisterPage()),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 50,
            ),
            const SizedBox(width: 20),
            const Text(
              'User Login',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'User Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email', Icons.email),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: _inputDecoration('Password', Icons.lock).copyWith(
                        suffixIcon: GestureDetector(
                          onTap: _togglePasswordVisibility,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                RotationTransition(turns: anim, child: child),
                            child: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              key: ValueKey(_obscureText),
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => _navigateToRegister(context),
                      child: const Text(
                        "Don't have an account? Register",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blueGrey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
