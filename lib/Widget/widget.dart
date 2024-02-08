import 'package:flutter/material.dart';

import '../Service/MusicService.dart';
import '../Service/Service.dart';

class PlayPauseWidget extends StatefulWidget {
  const PlayPauseWidget({super.key});

  @override
  _PlayPauseWidgetState createState() => _PlayPauseWidgetState();
}

class _PlayPauseWidgetState extends State<PlayPauseWidget> {
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
      width: 50,
      height: 50,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          musicService.pauseSong();

        },
        child: IconButton(
          icon: Icon(
            isPlaying
                ? Icons.play_arrow
                : Icons.pause,color: Colors.black,
            size: 32.0,
          ),
          onPressed: () {
            togglePlayPause();

            if (isPlaying) {
              musicService.pauseSong();
            } else {
              musicService.resumeSong();
            }
          },
        ),
      ),
    );
  }
}


