import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String videoPath;
  final double height;

  const AppVideoPlayer({
    super.key,
    required this.videoPath,
    required this.height,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true)
      ..setVolume(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}