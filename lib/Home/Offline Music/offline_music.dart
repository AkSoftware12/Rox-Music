import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/OfflineSongs/presentation/pages/favorites_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../OfflineSongs/presentation/components/home_card.dart';
import '../../OfflineSongs/presentation/pages/home/views/albums_view.dart';
import '../../OfflineSongs/presentation/pages/home/views/artists_view.dart';
import '../../OfflineSongs/presentation/pages/home/views/genres_view.dart';
import '../../OfflineSongs/presentation/pages/home/views/songs_view.dart';
import '../../OfflineSongs/presentation/utils/app_router.dart';
import '../../OfflineSongs/presentation/utils/theme/themes.dart';
import '../../Service/MusicService.dart';

class OfflineMusicScreen extends StatefulWidget {
  const OfflineMusicScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<OfflineMusicScreen>  with SingleTickerProviderStateMixin{
  TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  MusicService musicService=MusicService();

  TabController? _tabController;


  // Save the base64-encoded image to shared preferences

  // Indicate if application has permission to the library.
  bool _hasPermission = false;
  List<SongModel> items = [];
  List<SongModel> filteredItems = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);



    filteredItems = List.from(items);
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(items);
      });
    } else {
      setState(() {
        filteredItems = items.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredItems = List.from(items);
    });
  }
  final tabs = [
    'Songs',
    'Artists',
    'Albums',
    'Genres',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black,
      body: Ink(
        decoration: BoxDecoration(
          // gradient: Themes.getTheme().linearGradient,
        ),
        child: _hasPermission
            ? Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                height: 30,
                // Card elevation

                child: Center(
                  child: ListTile(
                    title: Text(
                      '',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return ProfileScreen();
                      //     },
                      //   ),
                      // );
                    },
                  ),
                ), // Margin around the card
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  HomeCard(
                    title: 'Favorites',
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFF5D2285),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FavoritesPage();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  HomeCard(
                    title: 'Playlists',
                    icon: Icons.playlist_play,
                    color: const Color(0xFF136327),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.playlistsRoute,
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  HomeCard(
                    title: 'Recents',
                    icon: Icons.history,
                    color: const Color(0xFFD4850D),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.recentsRoute,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e)).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:  [
                // Center(
                //     child: !_hasPermission
                //         ? noAccessToLibraryWidget()
                //         : FutureBuilder<List<SongModel>>(
                //       // Default values:
                //       future: _audioQuery.querySongs(
                //         sortType: null,
                //         orderType: OrderType.ASC_OR_SMALLER,
                //         uriType: UriType.EXTERNAL,
                //         ignoreCase: true,
                //       ),
                //       builder: (context, item) {
                //         // Display error, if any.
                //         if (item.hasError) {
                //           return Text(item.error.toString());
                //         }
                //
                //         // Waiting content.
                //         if (item.data == null) {
                //           return const CircularProgressIndicator();
                //         }
                //
                //         // 'Library' is empty.
                //         if (item.data!.isEmpty)
                //           return const Text("Nothing found!");
                //
                //         // You can use [item.data!] direct or you can create a:
                //         List<SongModel> songs = item.data!;
                //         return ListView.builder(
                //           itemCount: item.data!.length,
                //           itemBuilder: (context, index) {
                //             return Column(
                //               children: [
                //                 ListTile(
                //                   title: Text(
                //                     item.data![index].title,
                //                     style: GoogleFonts.poppins(
                //                       textStyle: TextStyle(
                //                         color: Colors.white,
                //                         fontSize: 15,
                //                         fontWeight: FontWeight.normal,
                //                       ),
                //                     ),
                //                   ),
                //                   subtitle: Text(
                //                     item.data![index].artist ?? "No Artist",
                //                     style: GoogleFonts.poppins(
                //                       textStyle: TextStyle(
                //                         color: Colors.grey,
                //                         fontSize: 13,
                //                         fontWeight: FontWeight.normal,
                //                       ),
                //                     ),
                //                   ),
                //                   trailing: const Icon(
                //                     Icons.arrow_forward_ios_outlined,
                //                     color: Colors.white,
                //                     size: 20,
                //                   ),
                //                   leading: QueryArtworkWidget(
                //                     controller: _audioQuery,
                //                     id: item.data![index].id,
                //                     type: ArtworkType.AUDIO,
                //                   ),
                //                   onTap: () async {
                //
                //                     musicService.playSong(
                //                       item.data![index].uri.toString(),
                //                       item.data![index].id.toString(),
                //                       item.data![index].title,
                //                       item.data![index].artist.toString(),
                //                     );
                //                   },
                //                 ),
                //                 // Add a Divider after each ListTile, except for the last one
                //                 if (index < item.data!.length - 1) Divider(color: Colors.white10),
                //               ],
                //             );
                //           },
                //         );
                //
                //       },
                //     ),
                //   ),

                  SongsView(),
                  ArtistsView(),
                ],
              ),
            ),
          ],
        )
            : const Center(
          child: Text('No permission to access library'),
        ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
