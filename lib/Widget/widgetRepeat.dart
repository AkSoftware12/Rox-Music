import 'package:flutter/material.dart';

import '../Service/MusicService.dart';

class RepeatWidget extends StatefulWidget {
  const RepeatWidget({super.key});

  @override
  _PlayPauseWidgetState createState() => _PlayPauseWidgetState();
}

class _PlayPauseWidgetState extends State<RepeatWidget> {
  bool isPlaying = false;
  MusicService musicService = MusicService();
  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,

      child: IconButton(
        icon: Icon(
          isPlaying
              ? Icons.repeat_one
              : Icons.repeat,
          size: 25.0,color: isPlaying ? Colors.white : Colors.grey,
        ),
        onPressed: () {
          musicService.toggleRepeatMode();
          setState(() {
            togglePlayPause();

          });
        },
      ),
    );
  }
}


