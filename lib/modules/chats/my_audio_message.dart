import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyAudioMessage extends StatefulWidget {
  MyAudioMessage({Key? key, required this.url}) : super(key: key);
  String url;

  @override
  State<MyAudioMessage> createState() => _MyAudioMessageState();
}

class _MyAudioMessageState extends State<MyAudioMessage> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  // TODO: implement widget
  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration  p)  {
        setState(() {
          position = p;
        });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration.zero;
        isPlaying=false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(

      builder: (BuildContext context, BoxConstraints constraints) {
        //final height=constraints.maxHeight;
        final width =constraints.maxWidth;
        return SizedBox(
          width: width*.75,
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.play(UrlSource(widget.url));
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
