import 'dart:async';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Seetings/settings.dart';
import '../../Demo/Core/app_globals.dart';
import '../../Model/artist.dart';
import '../../Model/last.dart';
import '../../Model/new_releasse.dart';
import '../../Model/recentaly.dart';
import '../../Model/top_charts.dart';
import '../../Model/trending.dart';
import '../../Service/MusicService.dart';
import '../../baseurlp/baseurl.dart';
import '../Home View All/All_tab_view_all.dart';

import '../HomeDeatils/home_deatils_song_list.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
    this.onTap,
  });

  final Function? onTap;

  List<RecentlySongs> recently = [
    RecentlySongs(
        url: 'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
        'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg', id: ''),

  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState(recently: recently);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState({
    required this.recently,
  });

  final List<RecentlySongs> recently;
  MusicService musicService = MusicService();
  bool isLiked = false;
  bool download = false;
  int selectIndex = 0;
  String searchQuery = '';

  List<dynamic> apiData = [];



  List<LastSongs> lastSongs = [
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
  ];

  List<ArtistSongs> artistSongs = [
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/Kumar_sanu.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv2.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv3.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv1.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv4.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa1.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa2.jpg"),
  ];

  List<TrendingSongs> trendingSongs = [
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/pngegg.png"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv1.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv2.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv3.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv4.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa1.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa2.jpg"),
  ];

  List<TopChartSongs> topchartSongs = [
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/hanuman_images.png"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv4.jpg"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa1.jpg"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv2.jpg"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv3.jpg"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv4.jpg"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa1.jpg"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa2.jpg")
  ];

  List<NewReleasseSongs> newReleasseSongs = [
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/cover.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv3.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv4.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa1.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv1.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv2.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa2.jpg")
  ];
  late StreamSubscription _positionSubscription;
  bool isDrawerOpen = false;


  Future<void> artistsData() async {
    // Replace 'your_token_here' with your actual token


    final Uri uri = Uri.parse(artist);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('data')) {
        setState(()  {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['data'];

          print(apiData);
          print(apiData);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }




  @override
  void initState() {
    super.initState();
    artistsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF222B40),

      body: Padding(
        padding: const EdgeInsets.only(top: 38.0),
        child: Container(
          child: DefaultTabController(
            length: 2, // Number of tabs
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 50,
                        child:   GestureDetector(
                          onTap: () {
                              setState(() {
                                isDrawerOpen = true;
                              });

                          },
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 180,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //This is for background color
                                color: Colors.white.withOpacity(0.0),
                                //This is for bottom border that is needed
                               ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 6),
                              child: TabBar(
                                onTap: (index) {
                                  setState(() {
                                    selectIndex = index;
                                  });
                                },
                                labelPadding:
                                const EdgeInsets.symmetric(horizontal: 05),
                                indicator:  BoxDecoration(),
                                tabs: [
                                  selectIndex != 0
                                      ? const Text(
                                    '$upComing ',
                                    style: TextStyle(
                                        color: gWhite, fontSize: 15),
                                  )
                                      : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: const Color(0xffe9e9e9)),
                                      color: gWhite,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '$upComing',
                                        style: TextStyle(
                                            color: gBlack, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  selectIndex != 1
                                      ? const Text(
                                    '$inProgress',
                                    style: TextStyle(
                                        color: gWhite, fontSize: 15),
                                  )
                                      : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: const Color(0xffe9e9e9)),
                                      color: gWhite,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '$inProgress',
                                        style: TextStyle(
                                            color: gBlack, fontSize: 15),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                        ),
                      ],

                    ),
                    SizedBox(
                      width: 120,
                      child: Container(
                        constraints: BoxConstraints.expand(height: 90),
                        // Height of the tab bar
                      ),
                    ),

                    SizedBox(
                      width: 50,
                      child: Container(
                        constraints: BoxConstraints.expand(height: 90),
                        // Height of the tab bar
                        child: IconButton(
                          icon: Icon(Icons.settings,color: Colors.white,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SettingScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Content for Tab 1
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                          Text(
                                            'Recently Songs',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(right: 18.0),
                                            child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return RecentlySongsClass(name: '',);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ),


                                        ]),
                                      ]),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 150.sp,
                                        child: ListView.builder(
                                          itemCount: 5,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                                  onTap: () async {
                                                    // _playSong(recently[index].toString());

                                                    // _playSong(recently[index] as int);
                                                    // musicService.songPlay(recently);

                                                    // musicService.playSong(
                                                    //     recently[index].id,
                                                    //     recently[index].url,
                                                    //     recently[index].image,
                                                    //     recently[index].title,
                                                    //     recently[index].subtitle);
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
                                                              height: 130,
                                                              width: 150,
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
                                                                    recently[
                                                                            index]
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
                                                          recently[index].title,
                                                          style:
                                                              GoogleFonts.poppins(
                                                            textStyle: TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(
                                                                recently[index]
                                                                    .subtitle,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: 13),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'BollyWood Masala',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return BollywoodMasala();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem = lastSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return SongsDeatilsList();
                                                    //     },
                                                    //   ),
                                                    // );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child: Image
                                                                      .network(
                                                                    lastSongs[
                                                                            index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 290,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(children: [
                                          Text(
                                            'Recommennded Artist Stations',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ]),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 220,
                                        child: ListView.builder(
                                            itemCount: apiData.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem = apiData[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Card(
                                                              color: Colors.grey,
                                                              elevation: 4.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100.0), // Adjust the value as needed
                                                              ),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  const SizedBox(
                                                                height: 160,
                                                                width: 160,
                                                                child: Column(
                                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        left: 5.0,
                                                                        top: 10,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                          Center(
                                                            child: Card(
                                                                elevation: 4.0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100.0), // Adjust the value as needed
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(20),
                                                                child: SizedBox(
                                                                  height: 140,
                                                                  width: 140,
                                                                  child: Column(
                                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                          left:
                                                                              0.0,
                                                                          top: 0,
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top:
                                                                                  0.0),

                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Container(
                                                                              width:
                                                                                  140.0,
                                                                              // Adjust the width and height as needed
                                                                              height:
                                                                                  140.0,
                                                                              color:
                                                                                  Colors.blue,
                                                                              // Background color of the circular container
                                                                              child:
                                                                                  Image.asset(artistSongs[index].image),
                                                                            ),
                                                                          ),
                                                                          // child: SizedBox(
                                                                          //   height: 130,
                                                                          //   width: 130,
                                                                          //   child: Image.asset("assets/Kumar_sanu.jpg"),
                                                                          //
                                                                          //   // child: Image.network(
                                                                          //   //   mapResponse1['base_url'] +
                                                                          //   //       listResponse1[index]['photo'],
                                                                          //   //
                                                                          //   // )
                                                                          // ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        apiData[index]['name'].toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Artist Radio',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'Trending Now',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return TrendingNowViewAll();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem =
                                                  trendingSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child:
                                                                      Image.asset(
                                                                    trendingSongs[
                                                                            index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'Top Charts',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return TopChartViewAll();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: topchartSongs.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem =
                                                  topchartSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child:
                                                                      Image.asset(
                                                                    topchartSongs[
                                                                            index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'New Releasse',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return NewReleasseViewAll();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),


                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem =
                                                  newReleasseSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child:
                                                                      Image.asset(
                                                                    newReleasseSongs[
                                                                            index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Content for Tab 2 music tab
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'Punjabi Songs',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return RecentlySongsClass(name: '',);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                          itemCount: 5,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                                  onTap: () async {
                                                    // _playSong(recently[index].toString());

                                                    // _playSong(recently[index] as int);
                                                    // musicService.songPlay(recently);

                                                    // musicService.playSong(
                                                    //     recently[index].id,
                                                    //     recently[index].url,
                                                    //     recently[index].image,
                                                    //     recently[index].title,
                                                    //     recently[index].subtitle);
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
                                                              height: 150,
                                                              width: 150,
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
                                                                    recently[
                                                                    index]
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
                                                          recently[index].title,
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
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(
                                                                recently[index]
                                                                    .subtitle,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: 13),
                                                                maxLines: 1,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'BollyWood Songs',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return BollywoodMasala();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem = lastSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return SongsDeatilsList();
                                                    //     },
                                                    //   ),
                                                    // );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child: Image
                                                                      .network(
                                                                    lastSongs[
                                                                    index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                        GoogleFonts.poppins(
                                                          textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'Sad Songs',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return TrendingNowViewAll();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem =
                                              trendingSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child:
                                                                  Image.asset(
                                                                    trendingSongs[
                                                                    index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                        GoogleFonts.poppins(
                                                          textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'Bhakti Songs',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return TopChartViewAll();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: topchartSongs.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem =
                                              topchartSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child:
                                                                  Image.asset(
                                                                    topchartSongs[
                                                                    index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                        GoogleFonts.poppins(
                                                          textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: Column(children: [

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 20,
                                      ),
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                'New Release Songs',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 18.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return NewReleasseViewAll();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Text(
                                                    'View All',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            ]),
                                      ]),
                                    ),


                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final cartItem =
                                              newReleasseSongs[index];

                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongsDeatilsList(
                                                            url: cartItem.url,
                                                            image: cartItem.image,
                                                            title: cartItem.title, type: '',
                                                          );
                                                        },
                                                      ),
                                                    );
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
                                                              height: 150,
                                                              width: 150,
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
                                                                  child:
                                                                  Image.asset(
                                                                    newReleasseSongs[
                                                                    index]
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
                                                      Text(
                                                        'Mei Ho Ja',
                                                        style:
                                                        GoogleFonts.poppins(
                                                          textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Sachet Tandon',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Content for Tab 3
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
