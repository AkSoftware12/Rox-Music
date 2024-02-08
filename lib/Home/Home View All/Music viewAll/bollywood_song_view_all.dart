import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Home/HomeDeatils/weekly_forecast_list.dart';
import '../../../Model/Music/bollywood_songs.dart';
import '../../../Model/Music/punjabi.dart';
import '../../../Model/new_releasse.dart';
import '../../../Service/MusicService.dart';


class BollywoodSongsViewAll extends StatefulWidget {

  const BollywoodSongsViewAll({super.key, });

  @override
  State<BollywoodSongsViewAll> createState() => _SongsDeatilsListState();
}

class _SongsDeatilsListState extends State<BollywoodSongsViewAll> {
  TextEditingController _searchController = TextEditingController();
  MusicService musicService = MusicService();
  bool backButtonLocked = false;

  List<BollywoodSongs> bollywoodSongs = [
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image: 'https://wallpapercave.com/wp/wp5510430.jpg'),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://media.timeout.com/images/102136087/image.jpg"),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
        'https://img.mensxp.com/media/content/2020/Jun/Bollywood-Songs-Shot-In-Royal-Palaces1200_5ef079279d525.jpeg'),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image:
        'https://i.scdn.co/image/ab67616d0000b27399dcaf80953b083cc7139a5f'),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
        "https://www.saregama.com/blog/wp-content/uploads/2021/04/Evolution-of-Bollywood-Song-Lyrics-1200x675.jpg"),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
        'https://images.news18.com/ibnlive/uploads/2022/03/gulabi-song-1.jpg'),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://i.ytimg.com/vi/IYDm2KWDHo4/maxresdefault.jpg"),
    BollywoodSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
        "https://i0.wp.com/www.awaradiaries.com/wp-content/uploads/2018/07/Filimg-Locations-of-Top-Bollywood-Songs.jpg?fit=1200%2C800&ssl=1"),
  ];

  List<BollywoodSongs> filteredItems = [];


  @override
  void initState() {
    super.initState();
    filteredItems = List.from(bollywoodSongs);


  }
  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(bollywoodSongs);
      });
    } else {
      setState(() {
        filteredItems = bollywoodSongs.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredItems = List.from(bollywoodSongs);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      home: Scaffold(
        backgroundColor: Colors.black,

        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('BollyWood Songs'),
          leading: IconButton(
            icon: Icon(Icons.arrow_circle_left_outlined,color: Colors.white,size: 40,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: CustomScrollView(
          slivers: [

            SliverAppBar(
              pinned: true,
              stretch: false,
              expandedHeight: 50,
              // backgroundColor: const Color(0xFF222B40),
              backgroundColor:  Colors.black,
              onStretchTrigger: () async {
                // await Server.requestNewData();
              },
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding:
                  const EdgeInsets.only(top: 0.0, left: 15, right: 15),
                  child: Card(
                    color: Colors.white,
                    elevation: 4, // Controls the shadow depth
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12.0), // Controls corner radius
                    ),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _searchController,
                        onChanged: (value) {
                          filterItems(value);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _clearSearch();
                            },
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: 'Search',
                        ),
                      ),
                    ),

                    // Margin around the card
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


            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,

                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {

                        final cartItem = filteredItems[index];

                        // Define your ratios here as needed
                    List<double> ratios = [1.0, 0.5, 1.5, 0.8]; // Example ratios
                    return GestureDetector(
                        onTap: () async {
                          // _playSong(recently[index].toString());

                          // _playSong(recently[index] as int);
                          // musicService.songPlay(recently);

                          musicService.playSong(
                              cartItem.url,
                              cartItem.image,
                              cartItem.title,
                              cartItem.title);
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.all(
                                  8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 140,
                                    width: 200,
                                    child: Card(
                                      color:
                                      Colors.white,
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            15.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            10.0),
                                        // Adjust the radius as needed
                                        // child: Image.network(
                                        //   songs[index].metas.image!.path,
                                        //   fit: BoxFit.fill,
                                        // ),

                                        child: Image
                                            .network(
                                          cartItem
                                              .image,
                                          fit: BoxFit
                                              .fill,
                                        ),
                                      ),

                                      // child: Column(
                                      //   children: [
                                      //
                                      //     Text('title'),
                                      //     Text('subtitle')
                                      //
                                      //   ],
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                cartItem.title,
                                style:
                                GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight
                                          .normal,
                                      overflow:
                                      TextOverflow
                                          .ellipsis),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                cartItem.title,
                                style:
                                GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight
                                          .normal,
                                      overflow:
                                      TextOverflow
                                          .ellipsis),
                                ),
                              ),
                            ),

                          ],
                        ));


                      },
                  childCount: filteredItems.length, // Replace this with your desired number of children
                ),
              ),
            ),


          ],
        ),


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