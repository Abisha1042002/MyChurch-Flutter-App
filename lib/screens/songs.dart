import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'playsong.dart'; // Import the PlayerScreen

class SongListPage extends StatefulWidget {
  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  List<Map<String, dynamic>> songs = []; // Initialize songs as an empty list
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create an instance of AudioPlayer

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  // Function to load songs from the assets (JSON file)
  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/audio_files.json');
    final Map<String, dynamic> data = json.decode(response); // Decode as a Map
    setState(() {
      // Access the 'audio_files' list inside the map
      songs = List<Map<String, dynamic>>.from(data['audio_files']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Song List")),
      body: songs.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator if songs are not loaded
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Card(
            elevation: 5.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: const Icon(Icons.music_note, size: 50),
              title: Text(
                song['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(song['file']), // Display the file path (or another info if needed)
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      songs: songs,
                      currentIndex: index,
                      audioPlayer: _audioPlayer,
                      onSongChange: (newIndex) {
                        setState(() {
                          // Handle song change if needed
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

