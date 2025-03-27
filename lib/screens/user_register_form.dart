import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_church/screens/donation_screen.dart';
import 'package:my_church/screens/user_login_page.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => UserRegisterPageState();
}

class UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔄 Register new user in Firestore
  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        // Check if email already exists
        QuerySnapshot existingUser = await _firestore
            .collection("users")
            .where("email", isEqualTo: email)
            .get();

        if (existingUser.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email already exists! Try logging in."),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        // Save user in Firestore
        await _firestore.collection("users").add({
          "name": name,
          "email": email,
          "password": password, // ⚠️ Passwords should be hashed in real applications
          "createdAt": FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome, $name!"),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DonationPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8860B),
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 40, height: 50),
            const SizedBox(width: 10),
            const Text('User Registration', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', width: 80, height: 80),
                    const SizedBox(height: 10),
                    const Text(
                      'Create an Account',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Full Name', Icons.person),
                      validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email', Icons.email),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: _inputDecoration('Password', Icons.lock).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blueGrey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        elevation: 5,
                      ),
                      child: const Text('REGISTER', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => _navigateToLogin(context),
                      child: const Text(
                        "Already have an account? Login",
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
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