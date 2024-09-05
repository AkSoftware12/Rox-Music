import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../Service/MusicService.dart';
import '../Service/Service.dart';

class PlayPauseWidget extends StatefulWidget {
  const PlayPauseWidget({super.key});

  @override
  _PlayPauseWidgetState createState() => _PlayPauseWidgetState();
}

class _PlayPauseWidgetState extends State<PlayPauseWidget> {
  bool isPlaying = false;
  bool _showProgress = true;

  MusicService musicService = MusicService();

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();
    // Start a timer to stop the progress after 5 seconds
    Timer(Duration(seconds: 5), () {
      setState(() {
        _showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        children: [
          Container(
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
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
          Center(
            child: _showProgress
                ? SizedBox(
                    height: 35,
                    width: 35,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      backgroundColor: Colors.white.withOpacity(0.8),
                    ),
                  )
                : Container(), // You can replace Container() with any other widget you want to show after stopping the progress
          )
        ],
      ),
    );
  }
}


