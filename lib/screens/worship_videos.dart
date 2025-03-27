import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_church/screens/video_player_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  VideoListScreenState createState() => VideoListScreenState();
}

class VideoListScreenState extends State<VideoListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  /// 🔄 Load videos from Firestore
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

  /// 📌 Open Embedded YouTube Player
  void _openYouTubePlayer(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreen(videoUrl: videoUrl),
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
            const SizedBox(width: 10),
            const Text('Worship Videos', style: TextStyle(color: Colors.white)),
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
              trailing: const Icon(Icons.play_arrow, color: Colors.blue),
              onTap: () => _openYouTubePlayer(context, videos[index]["videoUrl"]),
            ),
          );
        },
      ),
    );
  }
}