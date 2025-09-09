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
      String filePath = widget.songs[currentIndex]['file'];

      if (filePath.startsWith("assets/")) {
        await widget.audioPlayer.setAudioSource(AudioSource.asset(filePath));
      } else {
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
      currentIndex = (currentIndex + 1) % widget.songs.length;
    });
    widget.onSongChange(currentIndex);
    _setAudio();
  }

  void _skipPrevious() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.songs.length) % widget.songs.length;
    });
    widget.onSongChange(currentIndex);
    _setAudio();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[currentIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              currentSong['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 5),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white38,
                thumbColor: Colors.white,
              ),
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                onChanged: (value) async {
                  final newPosition = Duration(seconds: value.toInt());
                  await widget.audioPlayer.seek(newPosition);
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position), style: const TextStyle(color: Colors.white)),
                Text(formatTime(duration), style: const TextStyle(color: Colors.white)),
              ],
            ),

            const SizedBox(height: 30),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 45,
                  onPressed: _skipPrevious,
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  iconSize: 45,
                  onPressed: _skipNext,
                ),
              ],
            ),
          ],
        ),
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