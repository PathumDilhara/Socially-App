import 'package:flutter/material.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )
      ..addListener(() {
        if (_controller.value.isInitialized && !_isInitialized) {
          setState(() {
            _isInitialized = true;
          });
        }
      })
      ..setLooping(true)
      ..initialize().then((_) {
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      }).catchError((err) {
        print("###################### Error initializing video player");
      });
  }

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  //play and pause video player
  void _togglePlayerPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
              )
            : Center(
                child: CircularProgressIndicator(
                  color: mainOrangeColor,
                ),
              ),
        Positioned(
          child: Center(
            child: IconButton(
              onPressed: _togglePlayerPause,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ),
        ),
      ],
    );
  }
}
