import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../Service/MusicService.dart';
import '../../Utils/textSize.dart';


class MiniPlayer extends StatefulWidget {
  MiniPlayer({
    Key? key,
  }) : super(key: key);

  @override
  MiniPlayerState createState() => MiniPlayerState();
}

class MiniPlayerState extends State<MiniPlayer> {

  MusicService musicService = MusicService();
  double currentSliderValue = 0.0;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    // _initAudioPlayerListeners();
  }

  // void _initAudioPlayerListeners() {
  //   // Listen to changes in playback position
  //   musicService.getPositionStream().listen((Duration? position) {
  //     if (position != null) {
  //       setState(() {
  //         currentSliderValue = position.inMilliseconds.toDouble();
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Container(
      height: 45.sp,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black,Colors.purple
            // HexColor('#3f418d')
           ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: StreamBuilder<SequenceState?>(
        stream: musicService.player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }
          final metadata = state!.currentSource!.tag as MediaItem;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 2.sp),

              Padding(
                padding: EdgeInsets.all(0.sp),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.sp),
                      child: Container(
                        width: 35.sp,
                        height: 30.sp,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.sp),
                          child: CachedNetworkImage(
                            width: 35.sp,
                            height: 30.sp,
                            imageUrl: metadata.artUri.toString(),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/r_m_image.png',
                              width: 35.sp,
                              height: 30.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.sp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (metadata.title.isNotEmpty)
                            Text(
                              metadata.title!,
                              style: TextStyle(
                                  color: colorTheme.onPrimary,
                                  fontSize: TextSizes.textsmallPlayer),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (metadata.title!.isEmpty)
                            Text(
                              'Now Playing',
                              style: TextStyle(
                                  color: colorTheme.onPrimary,
                                  fontSize: TextSizes.textsmallPlayer),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          SizedBox(width: 8, height: 5.sp),
                          if (metadata.artist!.isNotEmpty)
                            Row(
                              children: [
                                Expanded(
                                  child: TextScroll(
                                    '${metadata.album.toString()} ${'/ '}${metadata.artist.toString()}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: colorTheme.onPrimary.withOpacity(0.5),
                                        fontSize: TextSizes.textsmall),
                                  ),
                                ),
                              ],
                            ),
                          if (metadata.album!.isEmpty)
                            Text(
                              'No',
                              style: TextStyle(
                                  color: colorTheme.onPrimary.withOpacity(0.5),
                                  fontSize: TextSizes.textsmall),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.sp),
                      child: Center(child: MusicService.getPalyPauseButton2(context)),
                    ),
                    SizedBox(width: 10.sp),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
                child: MusicService.getPlayerSliderLine(context),
              ),
            ],
          );
        },
      ),

    );

    //   GestureDetector(
    //   // onTap: widget.onTap,
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: colorTheme.onBackground,
    //     ),
    //
    //
    //     child: AnimatedContainer(
    //       duration: Duration(milliseconds: 200),
    //       height: 55.sp,
    //       child: Stack(
    //         children: [
    //           Column(
    //             children: [
    //               Padding(
    //                 padding:  EdgeInsets.only(bottom: 0.sp),
    //                 child: GestureDetector(
    //                   // onTap: widget.onTap,
    //                   child: Column(
    //                     children: [
    //                       Column(
    //                         children: [
    //                           Row(
    //                             children: [
    //
    //                               StreamBuilder<SequenceState?>(
    //                                 stream: musicService.player.sequenceStateStream,
    //                                 builder: (context, snapshot) {
    //                                   final state = snapshot.data;
    //                                   if (state?.sequence.isEmpty ?? true) {
    //                                     return const SizedBox();
    //                                   }
    //                                   final metadata = state!.currentSource!.tag as MediaItem;
    //                                   return Row(
    //                                     children: [
    //                                       Container(
    //                                         width: 35.sp,
    //                                         height: 30.sp,
    //                                         child: ClipRRect(
    //                                           borderRadius:
    //                                           BorderRadius.circular(10.0),
    //                                           child: CachedNetworkImage(
    //                                             width: 35.sp,
    //                                             height: 30.sp,
    //                                             imageUrl: metadata.artUri.toString(),
    //                                             // imageUrl:musicService.imageUrl,
    //                                             fit: BoxFit.cover, // Adjust this according to your requirement
    //                                             placeholder: (context, url) => Center(
    //                                               child: CircularProgressIndicator(
    //                                                 color: Colors.orangeAccent,
    //                                               ),
    //                                             ),
    //                                             errorWidget: (context, url, error) => Image.asset(
    //                                               'assets/r_m_image.png', // Path to your default image asset
    //                                               width: 35.sp,
    //                                               height: 30.sp, // Adjust width as per your requirement
    //                                               fit: BoxFit.cover, // Adjust this according to your requirement
    //                                             ),
    //                                           ),
    //
    //                                         ),
    //
    //                                       ),
    //                                       SizedBox(width: 10.sp),
    //                                       Column(
    //                                         crossAxisAlignment: CrossAxisAlignment.start,
    //                                         mainAxisAlignment: MainAxisAlignment.center,
    //                                         children: [
    //                                           if(metadata.title.isNotEmpty)
    //                                             Text(
    //                                               metadata.title!,
    //                                               style: TextStyle(color: colorTheme.onPrimary, fontSize: TextSizes.textsmallPlayer),
    //                                               maxLines: 1,
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                           if(metadata.title!.isEmpty)
    //                                             Text(
    //                                               'Now Playing',
    //                                               style: TextStyle(color: colorTheme.onPrimary, fontSize: TextSizes.textsmallPlayer),
    //                                               maxLines: 1,
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                           SizedBox(width: 8, height: 5.sp),
    //                                           if(metadata.artist!.isNotEmpty)
    //
    //                                             Row(
    //                                               children: [
    //
    //                                                 TextScroll(
    //                                                   '${metadata.album.toString()} ${'/ '}${metadata.artist.toString()}',
    //                                                   textAlign: TextAlign.left,
    //                                                   style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                                   // velocity: defaultTextScrollvelocity,
    //                                                   // delayBefore: delayBeforeScroll,
    //                                                 ),
    //                                                 // Text(
    //                                                 //   MusicService().album,
    //                                                 //   style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                                 //   maxLines: 1,
    //                                                 //   overflow: TextOverflow.ellipsis,
    //                                                 // ),
    //                                                 // Text(
    //                                                 //   ' / ',
    //                                                 //   style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                                 //   maxLines: 1,
    //                                                 //   overflow: TextOverflow.ellipsis,
    //                                                 // ),
    //                                                 //
    //                                                 //
    //                                                 // Text(
    //                                                 //   MusicService().artist,
    //                                                 //   style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                                 //   maxLines: 1,
    //                                                 //   overflow: TextOverflow.ellipsis,
    //                                                 // ),
    //                                               ],
    //                                             ),
    //
    //                                           if(metadata.album!.isEmpty)
    //                                             Text(
    //                                               'No',
    //                                               style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                               maxLines: 1,
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                         ],
    //                                       ),
    //
    //                                     ],
    //                                   );
    //                                 },
    //                               ),
    //
    //
    //                               Spacer(),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(bottom: 0.0),
    //                                 child: Center(child: MusicService.getPalyPauseButton2(context)),
    //                               ),
    //                               SizedBox(width: 10.sp),
    //                             ],
    //                           ),
    //                           MusicService.getPlayerSliderLine(context),
    //                           // MusicService.getPlayerSpeed(context),
    //
    //                         ],
    //                       ),
    //
    //
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //
    //
    //
    //             ],
    //           ),
    //
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    // Column(
    //     children: [
    //       if(MusicService().title.isNotEmpty)
    //       GestureDetector(
    //       onTap: () => widget.onTap(),
    //       child: Container(
    //         color: colorTheme.onBackground,
    //         child: AnimatedContainer(
    //           duration: Duration(milliseconds: 200),
    //           height: 100.sp,
    //           child: Stack(
    //             children: [
    //               Column(
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.only(bottom: 0.0),
    //                     child: GestureDetector(
    //                       onTap: () => widget.onTap(),
    //                       child: Column(
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.only(bottom: 0.0),
    //                             child: Row(
    //                               children: [
    //                                 Container(
    //                                   width: 35.sp,
    //                                   height: 35.sp,
    //                                   child: ClipRRect(
    //                                     borderRadius:
    //                                     BorderRadius.circular(10.0),
    //                                     child: CachedNetworkImage(
    //                                       width: 35.sp,
    //                                       height: 35.sp,
    //                                       imageUrl:  MusicService().getImageUrl(),
    //                                       fit: BoxFit.cover, // Adjust this according to your requirement
    //                                       placeholder: (context, url) => Center(
    //                                         child: CircularProgressIndicator(
    //                                           color: Colors.orangeAccent,
    //                                         ),
    //                                       ),
    //                                       errorWidget: (context, url, error) => Image.asset(
    //                                         'assets/r_m_image.png', // Path to your default image asset
    //                                         width: 35.sp,
    //                                         height: 35.sp, // Adjust width as per your requirement
    //                                         fit: BoxFit.cover, // Adjust this according to your requirement
    //                                       ),
    //                                     ),
    //
    //                                   ),
    //
    //                                 ),
    //                                 SizedBox(width: 10.sp),
    //                                 Column(
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   mainAxisAlignment: MainAxisAlignment.center,
    //                                   children: [
    //                                     if(MusicService().title.isNotEmpty)
    //                                     Text(
    //                                       MusicService().title ,
    //                                       style: TextStyle(color: colorTheme.onPrimary, fontSize: TextSizes.textmedium),
    //                                       maxLines: 1,
    //                                       overflow: TextOverflow.ellipsis,
    //                                     ),
    //                                     if(MusicService().title.isEmpty)
    //                                     Text(
    //                                       'Now Playing',
    //                                       style: TextStyle(color: colorTheme.onPrimary, fontSize: TextSizes.textmedium),
    //                                       maxLines: 1,
    //                                       overflow: TextOverflow.ellipsis,
    //                                     ),
    //                                     SizedBox(width: 8, height: 8),
    //                                     if(MusicService().artist.isNotEmpty)
    //
    //                                       Row(
    //                                         children: [
    //                                           Text(
    //                                             MusicService().album,
    //                                             style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                             maxLines: 1,
    //                                             overflow: TextOverflow.ellipsis,
    //                                           ),
    //                                           Text(
    //                                             ' / ',
    //                                             style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                             maxLines: 1,
    //                                             overflow: TextOverflow.ellipsis,
    //                                           ),
    //                                           Text(
    //                                             MusicService().artist,
    //                                             style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                             maxLines: 1,
    //                                             overflow: TextOverflow.ellipsis,
    //                                           ),
    //                                         ],
    //                                       ),
    //
    //                                     if(MusicService().artist.isEmpty)
    //                                       Text(
    //                                         'No',
    //                                         style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                         maxLines: 1,
    //                                         overflow: TextOverflow.ellipsis,
    //                                       ),
    //                                   ],
    //                                 ),
    //                                 Spacer(),
    //                                 Padding(
    //                                   padding: const EdgeInsets.only(bottom: 0.0),
    //                                   child: Center(child: MusicService.getPalyPauseButton2(context)),
    //                                 ),
    //
    //
    //                                 SizedBox(width: 10.sp),
    //                               ],
    //                             ),
    //                           ),
    //
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //
    //
    //                 ],
    //               ),
    //
    //
    //             ],
    //           ),
    //         ),
    //       ),
    //           ),
    //       if(MusicService().title.isEmpty)
    //         Container(
    //           color: colorTheme.onBackground,
    //           child: AnimatedContainer(
    //             duration: Duration(milliseconds: 200),
    //             height: 100.sp,
    //             child: Stack(
    //               children: [
    //                 Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.only(bottom: 0.0),
    //                       child: GestureDetector(
    //                         onTap: () => widget.onTap(),
    //                         child: Column(
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.only(bottom: 0.0),
    //                               child: Row(
    //                                 children: [
    //                                   Container(
    //                                     width: 35.sp,
    //                                     height: 35.sp,
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                       BorderRadius.circular(10.0),
    //                                       child: CachedNetworkImage(
    //                                         width: 35.sp,
    //                                         height: 35.sp,
    //                                         imageUrl:  MusicService().getImageUrl(),
    //                                         fit: BoxFit.cover, // Adjust this according to your requirement
    //                                         placeholder: (context, url) => Center(
    //                                           child: CircularProgressIndicator(
    //                                             color: Colors.orangeAccent,
    //                                           ),
    //                                         ),
    //                                         errorWidget: (context, url, error) => Icon(
    //                                           Icons.music_note,color: Colors.white,
    //                                         ),
    //                                       ),
    //
    //                                     ),
    //
    //                                   ),
    //                                   SizedBox(width: 10.sp),
    //                                   Column(
    //                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                     mainAxisAlignment: MainAxisAlignment.center,
    //                                     children: [
    //                                       if(MusicService().title.isNotEmpty)
    //                                         Text(
    //                                           MusicService().title ,
    //                                           style: TextStyle(color: colorTheme.onPrimary, fontSize: TextSizes.textmedium),
    //                                           maxLines: 1,
    //                                           overflow: TextOverflow.ellipsis,
    //                                         ),
    //                                       if(MusicService().title.isEmpty)
    //                                         Text(
    //                                           'Now Playing',
    //                                           style: TextStyle(color: colorTheme.onPrimary, fontSize: TextSizes.textmedium),
    //                                           maxLines: 1,
    //                                           overflow: TextOverflow.ellipsis,
    //                                         ),
    //                                       SizedBox(width: 8, height: 8),
    //                                       if(MusicService().artist.isNotEmpty)
    //
    //                                         Row(
    //                                           children: [
    //                                             Text(
    //                                               MusicService().album,
    //                                               style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                               maxLines: 1,
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                             Text(
    //                                               ' / ',
    //                                               style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                               maxLines: 1,
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                             Text(
    //                                               MusicService().artist,
    //                                               style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                               maxLines: 1,
    //                                               overflow: TextOverflow.ellipsis,
    //                                             ),
    //                                           ],
    //                                         ),
    //
    //                                       if(MusicService().artist.isEmpty)
    //                                         Text(
    //                                           'No',
    //                                           style: TextStyle(color: colorTheme.onPrimary.withOpacity(0.5), fontSize: TextSizes.textsmall),
    //                                           maxLines: 1,
    //                                           overflow: TextOverflow.ellipsis,
    //                                         ),
    //                                     ],
    //                                   ),
    //
    //                                   SizedBox(width: 10.sp),
    //                                 ],
    //                               ),
    //                             ),
    //
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //
    //
    //                   ],
    //                 ),
    //
    //
    //               ],
    //             ),
    //           ),
    //         ),
    //     ],
    //   );
  }
}
