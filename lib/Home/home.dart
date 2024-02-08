
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_saavn/OfflineSongs/presentation/pages/home/home_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../Demo/ak.dart';
import '../Demo/profile_demo.dart';
import '../Model/recentaly.dart';
import '../OfflineSongs/presentation/pages/artist_page.dart';
import '../OfflineSongs/presentation/pages/splash_page.dart';
import '../Service/MusicService.dart';
import 'Home Bottom/miniplayer.dart';
import 'Home Bottom/player.dart';
import 'Home Bottom/src/weslide.dart';
import 'Home Bottom/src/weslide_controller.dart';
import 'Home Screen/home_screen.dart';
import 'My Library/my_library.dart';
import 'My PlayList/my_playlist.dart';
import 'Offline Music/offline_music.dart';
import 'Offline Music/offline_music_tab.dart';
import 'Search/search.dart';




class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,  this.onTap,});
  final Function? onTap;

  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  MusicService musicService=MusicService();
  int _currentIndex = 0;
  bool _isMiniPlayerVisible = false;
  bool isPlaying = false;


  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    final WeSlideController _controller = WeSlideController();
    final double _panelMinSize = 137.0;
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
        panelHeader: MiniPlayer (isPlaying: isPlaying,
           onTap: _controller.show,
      ),
        panel: Player(isPlaying: isPlaying,
           onTap: _controller.hide,
        ),
        // panel: PlayerScreen(onTap: _controller.hide),
        footer: BottomNavigationBar(
          // backgroundColor: const Color(0xFF222B40),
          backgroundColor:  Colors.black,
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

          selectedLabelStyle: TextStyle(color: Colors.white),
          selectedItemColor: Colors.white,
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        blur: true,
      ),



    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
       return AkScreen();
        // return HomeScreen(onTap: widget.onTap,);
      case 1:
        return SearchScreen();
      case 2:
        return LibraryScreen();
      case 3:
        return MyPlayListScreen();
      case 4:
        // return OfflineMusicScreen();
        return OfflineMusicTabScreen();
      default:
        return Center(
          child: Text('Invalid Page'),
        );
    }
  }
}

