import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Home/HomeDeatils/weekly_forecast_list.dart';
import '../../Model/recentaly.dart';
import '../../Model/search.dart';
import '../../Model/trending.dart';
import '../../Service/MusicService.dart';

class TrendingNowViewAll extends StatefulWidget {

  const TrendingNowViewAll({super.key, });

  @override
  State<TrendingNowViewAll> createState() => _SongsDeatilsListState();
}

class _SongsDeatilsListState extends State<TrendingNowViewAll> {
  TextEditingController _searchController = TextEditingController();
  MusicService musicService = MusicService();
  bool backButtonLocked = false;


  List<TrendingSongs> trendingSongs = [
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Only Khushiyaan',
        image:
        "https://c.saavncdn.com/editorial/OnlyKhushiyaan_20231117032829.jpg?bch=1702977020"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Mahalaxmi Mantra',
        image:
        "https://c.saavncdn.com/153/Mahalaxmi-Mantra-Hindi-2005-20230508104311-500x500.jpg"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Jawan',
        image:
        "https://c.saavncdn.com/047/Jawan-Hindi-2023-20230921190854-500x500.jpg"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Aashiqon ki Mehfil',
        image:
        "https://c.saavncdn.com/843/Aashiqon-ki-Mehfil-Hindi-2023-20231208123453-500x500.jpg"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Starfish',
        image:
        "https://c.saavncdn.com/115/Starfish-Hindi-2023-20231122161004-500x500.jpg"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Kho Gaye Hum Kahan',
        image:
        "https://c.saavncdn.com/773/Kho-Gaye-Hum-Kahan-Hindi-2023-20231208120916-500x500.jpg"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'ANIMAL',
        image:
        "https://c.saavncdn.com/092/ANIMAL-Hindi-2023-20231124191036-500x500.jpg"),
    TrendingSongs(
        url:
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Farrey',
        image:
        "https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg"),
  ];
  List<TrendingSongs> filteredItems = [];


  @override
  void initState() {
    super.initState();
    filteredItems = List.from(trendingSongs);


  }
  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(trendingSongs);
      });
    } else {
      setState(() {
        filteredItems = trendingSongs.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredItems = List.from(trendingSongs);
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
          title: Text('Trending Now'),
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
                    // Define your ratios here as needed
                    List<double> ratios = [1.0, 0.5, 1.5, 0.8];

                    final cartItem = filteredItems[index];

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