import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  ImageGalleryScreenState createState() => ImageGalleryScreenState();
}

class ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<Map<String, String>> imageList = []; // Stores image ID and base64
  final picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  /// 🔥 Loads images from Firebase Firestore
  Future<void> _loadImages() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('images').get();
      setState(() {
        imageList = snapshot.docs
            .map((doc) => {"id": doc.id, "base64": doc['base64'] as String})
            .toList();
      });
    } catch (e) {
      print("Error loading images: $e");
    }
  }

  /// 🔥 Picks image from Gallery
  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String? base64String = await _convertImageToBase64(pickedFile);
      if (base64String != null) {
        DocumentReference docRef =
        await _firestore.collection('images').add({'base64': base64String});
        setState(() => imageList.add({"id": docRef.id, "base64": base64String}));
      }
    }
  }

  /// 🔥 Converts Image to Base64 (Handles Web, Android, Windows)
  Future<String?> _convertImageToBase64(XFile file) async {
    try {
      Uint8List bytes;

      if (kIsWeb) {
        // ✅ Web-friendly way (No File object required)
        bytes = await file.readAsBytes();
      } else {
        File imageFile = File(file.path);
        List<int> imageBytes = await imageFile.readAsBytes();

        // ✅ Mobile & Windows: Compress image before converting
        Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
          Uint8List.fromList(imageBytes),
          quality: 70, // Reduce quality for smaller size
        );

        if (compressedBytes == null) {
          print("Compression failed");
          return null;
        }

        bytes = compressedBytes;
      }

      return base64Encode(bytes);
    } catch (e) {
      print("Error converting image: $e");
      return null;
    }
  }

  /// 🔥 Deletes image from Firebase and updates UI
  Future<void> removeImage(int index) async {
    try {
      String docId = imageList[index]["id"]!;
      await _firestore.collection('images').doc(docId).delete();
      setState(() => imageList.removeAt(index));
    } catch (e) {
      print("Error deleting image: $e");
    }
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
            const Text('Gallery Upload', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: imageList.isEmpty
          ? const Center(
          child: Text('No images added yet!', style: TextStyle(fontSize: 18, color: Colors.black54)))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            try {
              Uint8List imageBytes = base64Decode(imageList[index]["base64"]!);
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.memory(imageBytes,
                        fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration:
                          BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                          child: const Icon(Icons.delete, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } catch (e) {
              return const Center(child: Text('Error loading image', style: TextStyle(color: Colors.red)));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}