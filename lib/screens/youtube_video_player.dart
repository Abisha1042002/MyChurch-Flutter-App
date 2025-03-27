import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({super.key, required this.videoId});

  @override
  YouTubePlayerScreenState createState() => YouTubePlayerScreenState();
}

class YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false, // Unmute the video
        enableJavaScript: true, // Ensure JavaScript is enabled
      ),
    )..loadVideoById(videoId: widget.videoId);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Player")),
      body: YoutubePlayerScaffold(
        controller: _controller,
        builder: (context, player) {
          return Center(child: player);
        },
      ),
    );
  }
}