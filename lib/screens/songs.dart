import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'playsong.dart';

class SongListPage extends StatefulWidget {
  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  List<Map<String, dynamic>> songs = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final String response = await rootBundle.loadString('assets/audio_files.json');
    final Map<String, dynamic> data = json.decode(response);
    setState(() {
      songs = List<Map<String, dynamic>>.from(data['audio_files']);
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
            Image.asset('assets/logo.png', width: 40, height: 50),
            const SizedBox(width: 10),
            const Text('Worahip Songs', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: songs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    songs: songs,
                    currentIndex: index,
                    audioPlayer: _audioPlayer,
                    onSongChange: (newIndex) {
                      setState(() {});
                    },
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: const Icon(Icons.library_music, color: Colors.white, size: 40),
                title: Text(
                  song['title'],
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.play_circle_fill, color: Colors.white, size: 35),
              ),
            ),
          );
        },
      ),
    );
  }
}