import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> songs;
  final int currentIndex;
  final AudioPlayer audioPlayer;
  final Function(int) onSongChange;

  const PlayerScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.audioPlayer,
    required this.onSongChange,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late int currentIndex;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    _setAudio();

    widget.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    widget.audioPlayer.positionStream.listen((pos) {
      setState(() {
        position = pos;
      });
    });

    widget.audioPlayer.durationStream.listen((dur) {
      setState(() {
        duration = dur ?? Duration.zero;
      });
    });
  }

  void _setAudio() async {
    try {
      //await widget.audioPlayer.setFilePath(widget.songs[currentIndex]['file']);
      String filePath = widget.songs[currentIndex]['file'];

      if (filePath.startsWith("assets/")) {
        // If file is from assets, use AudioSource.asset()
        await widget.audioPlayer.setAudioSource(AudioSource.asset(filePath));
      } else {
        // For normal file paths, use Uri
        await widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(filePath)));
      }
      await widget.audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await widget.audioPlayer.pause();
    } else {
      await widget.audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _skipNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.songs.length; // Loop back to first song
    });
    widget.onSongChange(currentIndex);
    _setAudio();
  }

  void _skipPrevious() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.songs.length) % widget.songs.length; // Loop to last song
    });
    widget.onSongChange(currentIndex);
    _setAudio();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Only show the music note icon instead of the image
          const Icon(Icons.music_note, size: 100, color: Colors.yellow),
          const SizedBox(height: 20),
          Text(
            currentSong['title'],
            style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final newPosition = Duration(seconds: value.toInt());
              await widget.audioPlayer.seek(newPosition);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(formatTime(position), style: const TextStyle(color: Colors.black)),
              Text(formatTime(duration), style: const TextStyle(color: Colors.black)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 50, color: Colors.black),
                onPressed: _skipPrevious,
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 50, color: Colors.black),
                onPressed: _skipNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}