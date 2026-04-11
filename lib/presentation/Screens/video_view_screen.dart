import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart'
    show FlickManager, FlickVideoPlayer;
import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  VideoViewScreen({super.key, required this.videoPath});
  final String videoPath;

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  late FlickManager flickManager;
  void initState() {
    super.initState();
    // this contain the video path.
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(widget.videoPath)),
    );
  }

  // to end the screen because RAM
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.secondary),
      backgroundColor: AppColors.secondary,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          // Full widget built in Flick_video_Player to handle custom video tools
          child: FlickVideoPlayer(flickManager: flickManager),
        ),
      ),
    );
  }
}
