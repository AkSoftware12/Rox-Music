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
      child: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              musicService.pauseSong();
            },
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.play_arrow : Icons.pause,
                color: Colors.black,
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
          // Circular Progress Indicator
          // Center(
          //   child: SizedBox(
          //     height: 35,
          //     width: 35,
          //     child: Positioned.fill(
          //       child: CircularProgressIndicator(
          //         valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          //          // You need to provide the progress value here
          //         backgroundColor: Colors.white.withOpacity(0.8),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),




    );
  }
}


