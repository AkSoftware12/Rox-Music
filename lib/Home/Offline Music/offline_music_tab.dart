import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../Demo/Core/app_globals.dart';
import '../../OfflineSongs/presentation/pages/home/views/albums_view.dart';
import '../../OfflineSongs/presentation/pages/home/views/artists_view.dart';
import '../../OfflineSongs/presentation/pages/home/views/genres_view.dart';
import '../../OfflineSongs/presentation/pages/home/views/songs_view.dart';


class OfflineMusicTabScreen extends StatefulWidget {
  const OfflineMusicTabScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<OfflineMusicTabScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int selectIndex = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        // backgroundColor: const Color(0xFF222B40),
        backgroundColor:  Colors.black,

        // Existing Scaffold code...
        body: Center(
          child: !_hasPermission
              ? noAccessToLibraryWidget()
              :CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: false,
                expandedHeight: 40,
                // backgroundColor: const Color(0xFF222B40),
                backgroundColor: Colors.black,
                onStretchTrigger: () async {

                },
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 80,
                      // Card elevation
                      child: Center(
                        child: ListTile(
                          title: Text(
                            'OffLine Songs',
                            style: GoogleFonts.poppins(
                              textStyle:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),

                        ),
                      ), // Margin around the card
                    ),
                  ),
                  titlePadding: EdgeInsets.only(top: 1),
                  centerTitle: true,
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                    StretchMode.blurBackground,
                  ],
                ),
              ),

              SliverToBoxAdapter(

                child: Container(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      //This is for background color
                      color: Colors.white.withOpacity(0.0),
                      //This is for bottom border that is needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        onTap: (index) {
                          setState(() {
                            selectIndex = index;
                          });
                        },
                        labelPadding:
                        const EdgeInsets.symmetric(horizontal: 0),
                        indicator: BoxDecoration(),
                        controller: _tabController,
                        tabs: [
                          selectIndex != 0
                              ? const Text(
                            'Songs ',
                            style: TextStyle(
                                color: gWhite, fontSize: 18),
                          )
                              : Container(
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              // color: const Color(0xffe9e9e9)),
                              color: Colors.orange,
                            ),
                            child: const Center(
                              child: Text(
                                'Songs',
                                style: TextStyle(
                                    color: gBlack,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          selectIndex != 1
                              ? const Text(
                            'Artists',
                            style: TextStyle(
                                color: gWhite, fontSize: 18),
                          )
                              : Container(
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              // color: const Color(0xffe9e9e9)),
                              color: Colors.orange,
                            ),
                            child: const Center(
                              child: Text(
                                'Artists',
                                style: TextStyle(
                                    color: gBlack,
                                    fontSize: 18),
                              ),
                            ),
                          ),

                          selectIndex != 2
                              ? const Text(
                            'Albums',
                            style: TextStyle(
                                color: gWhite, fontSize: 18),
                          )
                              : Container(
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              // color: const Color(0xffe9e9e9)),
                              color: Colors.orange,
                            ),
                            child: const Center(
                              child: Text(
                                'Albums',
                                style: TextStyle(
                                    color: gBlack,
                                    fontSize: 18),
                              ),
                            ),
                          ),

                          selectIndex != 3
                              ? const Text(
                            'Genres',
                            style: TextStyle(
                                color: gWhite, fontSize: 18),
                          )
                              : Container(
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              // color: const Color(0xffe9e9e9)),
                              color: Colors.orange,
                            ),
                            child: const Center(
                              child: Text(
                                'Genres',
                                style: TextStyle(
                                    color: gBlack,
                                    fontSize: 18),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SongsView(),
                    ArtistsView(),
                    AlbumsView(),
                    GenresView(),

                  ],
                ),
              ),
            ],
          ),
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

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.android;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
