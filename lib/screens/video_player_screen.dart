import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoUrl;

  const YouTubePlayerScreen({super.key, required this.videoUrl});

  @override
  YouTubePlayerScreenState createState() => YouTubePlayerScreenState();
}

class YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

    if (videoId == null) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid YouTube URL")),
        );
        Navigator.pop(context);
      });
      return;
    }

    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: videoId);
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