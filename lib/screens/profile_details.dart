import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileRowWidget extends StatefulWidget {
  const ProfileRowWidget({Key? key}) : super(key: key);

  @override
  State<ProfileRowWidget> createState() => _ProfileRowWidgetState();
}

class _ProfileRowWidgetState extends State<ProfileRowWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  String? _name;
  String? _profilePicBase64;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _dbRef.child('users/${user.uid}').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          _name = data['name'] ?? 'User';
          _profilePicBase64 = data['profilePic'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: _profilePicBase64 != null && _profilePicBase64!.isNotEmpty
              ? MemoryImage(base64Decode(_profilePicBase64!))
              : const AssetImage('assets/profile_pic.png') as ImageProvider,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            _name ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}