import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_church/screens/youtube_video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  VideoUploadScreenState createState() => VideoUploadScreenState();
}

class VideoUploadScreenState extends State<VideoUploadScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  /// 🔄 Load Videos from Firestore
  Future<void> _loadVideos() async {
    QuerySnapshot snapshot = await _firestore.collection('videos').get();
    setState(() {
      videos = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "title": doc["title"],
          "description": doc["description"] ?? '',
          "date": doc["date"]?.toDate() ?? DateTime.now(),
          "videoUrl": doc["videoUrl"],
        };
      }).toList();
    });
  }

  /// 📥 Insert New Video (YouTube URL)
  Future<void> _insertVideo(String title, String description, String videoUrl) async {
    await _firestore.collection('videos').add({
      "title": title,
      "description": description,
      "date": DateTime.now(),
      "videoUrl": videoUrl,
    });
    _loadVideos();
  }

  /// 📌 Open YouTube Video
  void _openYouTubePlayer(BuildContext context, String videoUrl) {
    String? videoId = YoutubePlayer.convertUrlToId(videoUrl); // Extract YouTube video ID

    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubePlayerScreen(videoId: videoId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid YouTube URL")),
      );
    }
  }

  /// 🗑 Delete Video from Firestore
  Future<void> _deleteVideo(String docId) async {
    await _firestore.collection('videos').doc(docId).delete();
    _loadVideos();
  }

  /// 📤 Show Dialog to Add Video
  Future<void> _showAddVideoDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController videoUrlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Video Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: videoUrlController, decoration: const InputDecoration(labelText: "YouTube URL")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && videoUrlController.text.isNotEmpty) {
                _insertVideo(titleController.text, descriptionController.text, videoUrlController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Upload"),
          ),
        ],
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
            const Text('YouTube Videos', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: videos.isEmpty
          ? const Center(child: Text("No videos uploaded yet!", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: Image.asset("assets/youtubelogo.png", width: 50, height: 50), // YouTube Logo
              title: Text(videos[index]["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(videos[index]["description"], style: const TextStyle(color: Colors.grey)),
                  Text(timeago.format(videos[index]["date"]), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteVideo(videos[index]['id']),
              ),
              onTap: () => _openYouTubePlayer(context, videos[index]["videoUrl"]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVideoDialog(context),
        child: const Icon(Icons.video_call),
      ),
    );
  }
}