import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Service/MusicService.dart';
import '../../Widget/widget.dart';

class MiniPlayer extends StatefulWidget {
  MiniPlayer({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  MusicService musicService = MusicService();
  bool isPlaying = false;
  double currentSliderValue = 0.0;
  bool isVisible = false;
  bool isLoading = false;



  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      musicService.resumeSong();
    } else {
      musicService.pauseSong();
    }
   // Save the current song state when play/pause is toggled
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayerListeners();
  }

  void _initAudioPlayerListeners() {
    // Listen to changes in playback position
    musicService.getPositionStream().listen((Duration? position) {
      if (position != null) {
        setState(() {
          currentSliderValue = position.inMilliseconds.toDouble();
        });
      }
    });
  }

  void _onSliderChange(double value) {
    musicService.seekTo(Duration(milliseconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        color: colorTheme.onBackground,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 71.0,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => widget.onTap(),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => widget.onTap(),
                      child: Container(
                        width: 70,
                        height: 70,
                        child: Image.network(
                          musicService.getImageUrl(),
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Image.asset('assets/no_image_icons.png', fit: BoxFit.fill);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onTap(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              MusicService().title,
                              style: TextStyle(color: colorTheme.onPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 8, height: 8),
                            Text(
                              MusicService().subtitle,
                              style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    PlayPauseWidget(

                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              Visibility(
                visible: isVisible,
                child: StreamBuilder<Duration?>(
                  stream: musicService.getDurationStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      double maxDuration = snapshot.data!.inMilliseconds.toDouble();
                      return Slider(
                        value: currentSliderValue,
                        min: 0.0,
                        max: maxDuration,
                        onChanged: _onSliderChange,
                      );
                    } else {
                      return Slider(
                        value: 0.0,
                        min: 0.0,
                        max: 1.0,
                        onChanged: null,
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible: isLoading,
                child: CircularProgressIndicator(),
              ),
              Divider(color: colorTheme.background, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
