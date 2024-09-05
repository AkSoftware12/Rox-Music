
import 'dart:io';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:music_player_saavn/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Demo/ak.dart';
import '../MiniPlayer Demo/utils.dart';
import '../Service/MusicService.dart';
import '../constants/color_constants.dart';
import 'Home Bottom/miniplayer.dart';
import 'Home Bottom/player.dart';
import 'Home Bottom/src/weslide.dart';
import 'Home Bottom/src/weslide_controller.dart';
import 'My Library/my_library.dart';
import 'My PlayList/main_list.dart';
import 'My PlayList/my_playlist.dart';
import 'Offline Music/offline_music_tab.dart';
import 'Search/search.dart';

ValueNotifier<AudioObject?> currentlyPlaying = ValueNotifier(null);
// First get the FlutterView.
FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// // Dimensions in physical pixels (px)
// Size size = view.physicalSize;
// double width = size.width;
// double height = size.height;

// Dimensions in logical pixels (dp)
Size size = view.physicalSize / view.devicePixelRatio;
double width = size.width;
double playerMaxHeight = size.height;
const double playerMinHeight = 70;
// const double playerMaxHeight = 800;

const miniplayerPercentageDeclaration = 0.2;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.onTap,
  });

  final Function? onTap;

  @override
  BottomNavBarDemoState createState() => BottomNavBarDemoState();
}

class BottomNavBarDemoState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  MusicService musicService = MusicService();

  int _currentIndex = 0;
  bool _isMiniPlayerVisible = false;
  bool isPlaying = false;
  bool _isPanelVisible = false;
  bool miniPlayerButton = false;

  @override
  void initState() {
    super.initState();
    // miniPlayer();
    // BackButtonInterceptor.add(myInterceptor);
  }

  bool isMusicPlaying = false;

// Update the variable when music starts playing
  void startPlayingMusic() {
    setState(() {
      isMusicPlaying = true;
    });
  }

// Update the variable when music stops playing
  void stopPlayingMusic() {
    setState(() {
      isMusicPlaying = false;
    });
  }

  void toggleMiniPlayerVisibility(bool isVisible) {
    setState(() {});
  }

  // Future<void> miniPlayer() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   miniPlayerButton = prefs.getString(FirestoreConstants.miniPlayerShow);
  // }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: ColorConstants.themeColor,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Cancel',
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Yes',
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }



  @override
  Widget build(BuildContext context) {
    final WeSlideController _controller = WeSlideController();
    final double _panelMinSize = miniPlayerButton != null ? 122.sp : 60.sp;
    // final double _panelMinSize =   110.sp;
    final double _panelMaxSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: WeSlide(
        controller: _controller,
        panelMinSize: _panelMinSize,
        panelMaxSize: _panelMaxSize,
        overlayOpacity: 0.9,
        overlay: true,
        isDismissible: true,
        body: _buildPage(_currentIndex),
        panelHeader: miniPlayerButton != null
            ? MiniPlayer(
          // isPlaying: isPlaying,
          //
          // onTap: _controller.show,
        )
            : Container(),

        // panel: miniPlayerButton != null
        //     ? Player(
        //     onReturn: _refresh
        //   // isPlaying: isPlaying,
        //   // onTap: _controller.hide,
        // )
        //     : Container(),

        // panel: PlayerScreen(onTap: _controller.hide),
        footer: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF222B40),
            // backgroundColor: Colors.black12,
            // backgroundColor: Color(0xEE2B2E2F),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: Colors.orange,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'My Library',
                backgroundColor: Colors.orange,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_play_sharp),
                label: 'My Playlist',
                backgroundColor: Colors.orange,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined),
                label: 'Offline',
                backgroundColor: Colors.orange,
              ),
            ],

            selectedLabelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: TextSizes.textsmall,
                fontWeight: FontWeight.normal,
              ),
            ),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.grey,
                fontSize: TextSizes.textsmall,
                fontWeight: FontWeight.normal,
              ),
            ),

            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        blur: true,
      ),


      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //
      //
      // floatingActionButton: Padding(
      //     padding: EdgeInsets.only(bottom: 15.sp),
      //     child: Stack(
      //       children: [
      //
      //         if( MusicService().getImageUrl().isNotEmpty)
      //         GestureDetector(
      //           onTap: (){
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) {
      //                   return Player(isPlaying: isPlaying,
      //                     onTap: _controller.hide,
      //                   );
      //                 },
      //               ),
      //             );
      //           },
      //           // child: SizedBox(
      //           //     height: 80.sp,
      //           //     width: 80.sp,
      //           //     child: MusicService.getPlayerSliderCri(context)),
      //         ),
      //
      //         if( MusicService().getImageUrl().isEmpty)
      //           GestureDetector(
      //             onTap: (){
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) {
      //                     return Player(isPlaying: isPlaying,
      //                       onTap: _controller.hide,
      //                     );
      //                   },
      //                 ),
      //               );
      //             },
      //             child: SizedBox(
      //                 height: 80.sp,
      //                 width: 80.sp,
      //                 child: MusicService.getPlayerSliderCri(context)),
      //           ),
      //       ],
      //     )
      //
      //
      // ),
    );
  }

  Widget _buildPage(
      int index,
      ) {
    switch (index) {
      case 0:
        return AkScreen();
      case 1:
        return SearchScreen();
      case 2:
        return LibraryScreen();
      case 3:
      // return MainList();
        return MyPlayListScreen();
      case 4:
      // return OfflineMusicScreen();
        return OfflineMusicTabScreen();
      default:
        return AkScreen();
    }
  }
}
