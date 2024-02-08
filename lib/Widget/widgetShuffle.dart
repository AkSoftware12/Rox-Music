import 'package:flutter/material.dart';

import '../Service/MusicService.dart';

class ShuffleWidget extends StatefulWidget {
  const ShuffleWidget({super.key});

  @override
  _PlayPauseWidgetState createState() => _PlayPauseWidgetState();
}

class _PlayPauseWidgetState extends State<ShuffleWidget> {
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
              ? Icons.shuffle
              : Icons.shuffle,
          size: 25.0,color: isPlaying ? Colors.white : Colors.grey,
        ),
        onPressed: () {
          togglePlayPause();
        },
      ),
    );
  }
}


