import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Widget/widgetShuffle.dart';
import 'package:share/share.dart';
import '../../Service/MusicService.dart';
import '../../Service/Service.dart';
import '../../Widget/widget.dart';
import '../../Widget/widgetRepeat.dart';

class Player extends StatefulWidget {
  final Function onTap;

  Player({
    required this.onTap,
  });

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  MusicService musicService = MusicService();
  bool isPlaying = false;
  double currentSliderValue = 0.0;
  bool visible = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _currentSongIndex = 0;
  bool isLiked = false;
  bool download = false;
  bool isSharePopupShown = false;
  bool isRepeat = false;





  void _onShareButtonPressed(BuildContext context) {
    String title = musicService.title;
    String subtitle = musicService.subtitle;
    String url = musicService.url;
    String imagePath = musicService.getImageUrl();

    Share.share(
      '$title\n$subtitle\n $url',
      subject: musicService.title,

      sharePositionOrigin: Rect.fromCircle(
        center: Offset(0, 0),
        radius: 100,
      ),
      // shareRect: Rect.fromCircle(
      //   center: Offset(0, 0),
      //   radius: 100,
      // ),
      // imageUrl: 'file:///$imagePath',
    );
  }
  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
    });
  }
  @override
  void initState() {
    super.initState();

    // _playSong(_currentSongIndex);

    musicService.getPositionStream().listen((position) {
      setState(() {
        _position = position ?? Duration.zero;
        if (_position >= _duration) {
          // _playNextSong(); // Function to play the next song
        }
      });
    });

    musicService.getDurationStream().listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    musicService.getPositionStream().listen((Duration? position) {
      if (position != null) {
        setState(() {
          currentSliderValue = position.inMilliseconds.toDouble();
        });
      }
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inMinutes}:${twoDigitSeconds}';
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _onSliderChange(double value) {
    musicService.seekTo(Duration(milliseconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardSize = MediaQuery.of(context).size.height * 0.4;
    return Material(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B1220).withOpacity(0.0),
                    Color(0xFF0B1220).withOpacity(0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                                height: MediaQuery.of(context).padding.top),
                            // Header
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => widget.onTap(),
                                    iconSize: 32,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "PLAYING NOW",
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!
                                              .apply(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     Icons.more_horiz,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  height: cardSize,
                                  width: cardSize,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    // Adjust the value as needed
                                    child: Image.network(
                                      musicService.getImageUrl(),
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        // Return a placeholder/default image when the network image fails to load
                                        return Image.asset(
                                          'assets/no_image_icons.png',
                                        ); // Replace 'default_image.png' with your default image asset path
                                      },
                                    ),
                                  )

                                  // child:
                                  //     Image.network(MusicService().getImageUrl(),
                                  // ),
                                  ),
                            ),
                            // Music info
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(right: 8.0),
                                                  //   child: IconButton(
                                                  //     icon: Icon(Icons.download_for_offline_sharp,size: 35,color: Colors.white,),
                                                  //     onPressed: () {
                                                  //       // End button functionality
                                                  //       print('End button pressed');
                                                  //     },
                                                  //   ),
                                                  // ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(right: 8.0),
                                                  //   child: IconButton(
                                                  //     icon: Icon(Icons.more_vert,size: 35,color: Colors.white,),
                                                  //     onPressed: () {
                                                  //       // End button functionality
                                                  //       print('End button pressed');
                                                  //     },
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: IconButton(
                                                      icon: isLiked
                                                          ? Icon(
                                                              Icons.check,
                                                              size: 30,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .download_for_offline,
                                                              size: 30,
                                                            ),
                                                      color: isLiked
                                                          ? Colors.green
                                                          : Colors.grey,
                                                      onPressed: () {
                                                        setState(() {
                                                          isLiked = !isLiked;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: IconButton(
                                                      icon: download
                                                          ? Icon(
                                                              Icons.favorite,
                                                              size: 30,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              size: 30,
                                                            ),
                                                      color: download
                                                          ? Colors.red
                                                          : Colors.grey,
                                                      onPressed: () {
                                                        // if (song.isLiked) {
                                                        //   // Do something when the song is liked
                                                        //   print("Song is liked!");
                                                        // } else {
                                                        //   // Do something when the song is not liked
                                                        //   print("Song is not liked.");
                                                        // }
                                                        setState(() {
                                                          download = !download;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0.0),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        size: 35,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          backgroundColor: Colors.white,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              150,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            // Adjust the value as needed
                                                                            child:
                                                                                Image.network(
                                                                              MusicService().getImageUrl(),
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                // Return a placeholder/default image when the network image fails to load
                                                                                return Image.asset(
                                                                                  'assets/no_image_icons.png',
                                                                                ); // Replace 'default_image.png' with your default image asset path
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                8),
                                                                        Text(
                                                                          MusicService()
                                                                              .title,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: textTheme
                                                                              .headline5!
                                                                              .apply(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                          MusicService()
                                                                              .subtitle,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: textTheme
                                                                              .headline6!
                                                                              .apply(color: Colors.grey.withOpacity(0.5)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16),
                                                                   Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {

                                                                              },
                                                                              child: Icon(Icons.favorite_border),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            const Padding(
                                                                              padding: EdgeInsets.only(left: 0.0),
                                                                              child: Text(
                                                                                'Like',
                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {

                                                                              },
                                                                              child: Icon(Icons.file_download),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text('Download',                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {

                                                                              },
                                                                              child: Icon(Icons.thumb_down),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text('Unlike',                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {

                                                                              },
                                                                              child: Icon(Icons.info),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text('Details',                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () async {

                                                                                _onShareButtonPressed(context);
                                                                                // if (!isSharePopupShown) {
                                                                                //   isSharePopupShown = true;
                                                                                //
                                                                                //   await Share.share(
                                                                                //     '$title\n$subtitle\n$url',
                                                                                //
                                                                                // subject: musicService.title,
                                                                                //
                                                                                //   ).whenComplete(() {
                                                                                //     Timer(const Duration(milliseconds: 600), () {
                                                                                //       isSharePopupShown = false;
                                                                                //     });
                                                                                //   });
                                                                                // }
                                                                              },
                                                                              child: Icon(Icons.share),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text('Share',                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          MusicService().title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.headline5!.apply(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          MusicService().subtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.headline6!.apply(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<Duration?>(
                          stream: musicService.getDurationStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              double maxDuration =
                                  snapshot.data!.inMilliseconds.toDouble();
                              return Slider(
                                value: currentSliderValue,
                                min: 0.0,
                                max: maxDuration,
                                onChanged: _onSliderChange,
                                activeColor: Colors.redAccent,
                                inactiveColor: Colors.grey,
                              );
                            } else {
                              return const Slider(
                                value: 0.0,
                                min: 0.0,
                                max: 1.0,
                                onChanged: null,
                                activeColor: Colors.redAccent,
                                inactiveColor: Colors.grey,
                              );
                            }
                          },
                        ), //SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                formatDuration(_position),
                                style: textTheme.bodyText2!.apply(
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                              Text(
                                formatDuration(_duration),
                                style: textTheme.bodyMedium!.apply(
                                    color: Colors.white.withOpacity(0.7)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // IconButton(
                              //   highlightColor: Colors.transparent,
                              //   splashColor: Colors.transparent,
                              //   onPressed: () {
                              //     Switch(
                              //       value: isRepeat,
                              //       onChanged: (value) {
                              //         toggleRepeat();
                              //       },
                              //     );
                              //   },
                              //   icon:
                              //   Icon(isRepeat  ? Icons.repeat_one : Icons.repeat),
                              //
                              // ),

                              RepeatWidget(),
                              IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  // _PreviousNextSong();
                                  musicService.skipPrevious();
                                  // musicService.playPrevious();
                                },
                                icon: Icon(Icons.skip_previous,
                                    color: Colors.white),
                              ),
                              // SizedBox(
                              //   width: 50,
                              //   height: 50,
                              //   child: FloatingActionButton(
                              //     backgroundColor: Colors.white,
                              //     onPressed: () {
                              //       musicService.pauseSong();
                              //     },
                              //     child: IconButton(
                              //       icon: Icon(
                              //         isPlaying
                              //             ? Icons.play_arrow
                              //             : Icons.pause,
                              //         size: 32.0,
                              //       ),
                              //       onPressed: () {
                              //         togglePlayPause();
                              //
                              //         if (isPlaying) {
                              //           musicService.pauseSong();
                              //         } else {
                              //           musicService.resumeSong();
                              //         }
                              //       },
                              //     ),
                              //   ),
                              // ),

                              PlayPauseWidget(),
                              IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  // _playNextSong();

                                  musicService.skipNext();
                                  // musicService.playNext();
                                },
                                icon:
                                    Icon(Icons.skip_next, color: Colors.white),
                              ),
                              ShuffleWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
