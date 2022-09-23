import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  VideoItem({Key? key, required this.videoPlayerController, this.looping=true,required this.height}) : super(key: key);
  final VideoPlayerController videoPlayerController;
  bool looping=true;
  double height;

  @override
  State<VideoItem> createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<VideoItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController =
        ChewieController(
          videoPlayerController: widget.videoPlayerController,
          aspectRatio: 16/9,
          autoInitialize: true,
          looping: widget.looping,
          errorBuilder:(context,errorMessage){
            return Center(
              child: Text(
                errorMessage.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .25*widget.height,
      width: double.infinity,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}