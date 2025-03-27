import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  ImageGalleryScreenState createState() => ImageGalleryScreenState();
}

class ImageGalleryScreenState extends State<ImageGalleryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> imageList = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  /// 🔄 Load Images from Firestore
  Future<void> _loadImages() async {
    QuerySnapshot snapshot = await _firestore.collection('images').get();
    setState(() {
      imageList = snapshot.docs.map((doc) {
        return {"id": doc.id, "base64": doc['base64'] as String};
      }).toList();
    });
  }

  /// 🔍 Open Full-Screen Image Preview
  void _openImagePreview(int index, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          imageBase64: imageList[index]["base64"],
        ),
      ),
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
          const SizedBox(width: 30),
          const Text('Gallery', style: TextStyle(color: Colors.white)),
        ],
      ),
      ),
      body: imageList.isEmpty
          ? const Center(child: Text("No images found!"))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => _openImagePreview(index, context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      base64Decode(imageList[index]["base64"]!), // ✅ Decode Base64
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 📌 Full-Screen Image Preview
class FullScreenImage extends StatelessWidget {
  final String imageBase64;

  const FullScreenImage({super.key, required this.imageBase64});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Image.memory(
          base64Decode(imageBase64),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}