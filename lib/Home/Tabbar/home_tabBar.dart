import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Model/artist.dart';
import '../../Model/last.dart';
import '../../Model/new_releasse.dart';
import '../../Model/recentaly.dart';
import '../../Model/recentaly.dart';
import '../../Model/recentaly.dart';
import '../../Model/top_charts.dart';
import '../../Model/trending.dart';
import '../../Service/MusicService.dart';
import '../HomeDeatils/home_deatils_song_list.dart';

// ignore: must_be_immutable
class AllMusic extends StatefulWidget {
  AllMusic({
    super.key,this.onTap,
  });

  final Function? onTap;

  List<RecentlySongs> recently = [
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title:'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
        'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title:'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
        'https://c.saavncdn.com/529/Shiv-Shankara-Hindi-2019-20190228184236-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/120/1fa9e474ab4df104cb3deecabd2ec342_96.mp4',
        title:'Man Mera Mandir,Shiv Meri Puja',
        subtitle: 'Sameer Sen, Dilip Sen, Anuradha Paudwal',
        image:
        'https://c.saavncdn.com/120/Shiv-Aaradhna-1991-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/122/b8bc2c1a0de0010582dfdb33a1f06436_96.mp4',
        title:'Shiv Amritvaani',
        subtitle: 'Surender Kohli, Anuradha Paudwal',
        image:
        'https://c.saavncdn.com/122/Shiv-Amritvani-1999-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/256/f912a4f10ab5505d5f80d7c87cdc23ab_96.mp4',
        title:'Shree Hanuman Chalisa',
        subtitle: 'Hariharan - Shree Hanuman Chalisa (Hanuman Ashtak)',
        image:
        'https://c.saavncdn.com/256/Shree-Hanuman-Chalisa-Hanuman-Ashtak-Hindi-1992-20230904173628-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/835/4af7820e1519cc777b4bcb6549e23af2_96.mp4',
        title: 'Bajrang Baan',
        subtitle: 'Suresh Wadkar - Hanuman Chalisa',
        image:
        'https://c.saavncdn.com/835/Hanuman-Chalisa-Hindi-2016-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/222/fd095a4516b3a78ee065ea4e391ad39f_96.mp4',
        title: 'Hanuman Aarti',
        subtitle: 'Anup Jalota - Shree Ram Bhakt Hanuman Chalisa With Transcreation',
        image:
        'https://c.saavncdn.com/222/Shree-Ram-Bhakt-Hanuman-Chalisa-With-Transcreation-Telugu-2016-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/905/bb762b053b0704eb6a75be040e208c69_96.mp4',
        title: 'Tujhe Yaad Na Meri Ayee-2',
        subtitle: 'Tujhe Yaad Na Meri Ayee-2',
        image:
        'https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/318/1feec2b62321a4cbb9b5a29e179768b9_96.mp4',
        title: 'Pehli Pehli Baar Mohabbat Ki Hai',
        subtitle: 'Pehli Pehli Baar Mohabbat Ki Hai',
        image:
        'https://c.saavncdn.com/318/Sirf-Tum-Hindi-1999-20221205181935-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/255/802bd5104b367a501584c9955910168b_96.mp4',
        title: 'Hamein Tumse Hua Pyar',
        subtitle: 'Hamein Tumse Hua Pyar',
        image:
        'https://c.saavncdn.com/255/Ab-Tumhare-Hawale-Watan-Sathiyo-Hindi-2004-20221118021108-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/228/d28a57ac4d8bbc4bdc0dba65795c7add_96.mp4',
        title: 'Main Nikla Gaddi Leke',
        subtitle: 'Main Nikla Gaddi Leke',
        image:
        'https://c.saavncdn.com/228/Gadar-Ek-Prem-Katha-Hindi-2001-20230811123918-500x500.jpg'),
    RecentlySongs(
        url:
        "https://aac.saavncdn.com/088/64ec11ed2a357085a5c598b91e18723c_96.mp4",
        title: "Jaan - E - Jigar Jaaneman",
        subtitle: "Jaan - E - Jigar Jaaneman",
        image:
        "https://c.saavncdn.com/088/Aashiqui-Hindi-1989-20221118014024-500x500.jpg"),
    RecentlySongs(
      url:
      "https://aac.saavncdn.com/026/3687b7ddfa714fcd3d7e1a4af95ead4e_96.mp4",
      title: "Chaleya (From \"Jawan\")",
      subtitle: "Chaleya (From \"Jawan\")",
      image:
      "https://c.saavncdn.com/026/Chaleya-From-Jawan-Hindi-2023-20230814014337-500x500.jpg",
    ),
  ];



  @override
  State<AllMusic> createState() => _HomeScreenState(recently: recently);
}

class _HomeScreenState extends State<AllMusic> {
  _HomeScreenState( {required this.recently,
  });
  final List<RecentlySongs> recently;
  MusicService musicService=MusicService();
  bool isLiked = false;
  bool download = false;


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


  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Music Player Saavn',
      home: Scaffold(
        backgroundColor:const Color(0xFF222B40),
        body: CustomScrollView(
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
                          Row(children: [
                            Text(
                              'Your Playlists',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.cyanAccent,
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
                          height: 210,
                          child: ListView.builder(
                            itemCount: recently.length,
                            scrollDirection: Axis.horizontal,


                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () async {

                                  // _playSong(recently[index].toString());


                                  // _playSong(recently[index] as int);
                                  // musicService.songPlay(recently);


                                  musicService.playSong(recently[index].url,recently[index].image,recently[index].title,recently[index].subtitle);

                                },


                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            width: 150,
                                            child: Card(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(15.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                // Adjust the radius as needed
                                                // child: Image.network(
                                                //   songs[index].metas.image!.path,
                                                //   fit: BoxFit.fill,
                                                // ),

                                                child: Image.network(
                                                  recently[index].image,
                                                  fit: BoxFit.fill,
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
                                      child: Text(  recently[index].title, style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal,
                                            overflow: TextOverflow.ellipsis),

                                      ),),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(recently[index].subtitle,
                                              style: TextStyle(  color: Colors.white,
                                                  fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
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
                          Row(children: [
                            Text(
                              'Last Session',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.cyanAccent,
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
                          height: 210,
                          child: ListView.builder(
                              itemCount: lastSongs.length,
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
                                              title: cartItem.title,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: Card(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    // Adjust the radius as needed
                                                    child: Image.network(
                                                      lastSongs[index].image,
                                                      fit: BoxFit.fill,
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
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Sachet Tandon',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.normal),
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
                                    color: Colors.cyanAccent,
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
                              itemCount: artistSongs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final cartItem = artistSongs[index];

                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SongsDeatilsList(
                                              url: cartItem.url,
                                              image: cartItem.image,
                                              title: cartItem.title,
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
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      100.0), // Adjust the value as needed
                                                ),
                                                margin: const EdgeInsets.all(10),
                                                child: const SizedBox(
                                                  height: 160,
                                                  width: 160,
                                                  child: Column(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
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
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        100.0), // Adjust the value as needed
                                                  ),
                                                  margin: const EdgeInsets.all(20),
                                                  child: SizedBox(
                                                    height: 140,
                                                    width: 140,
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                            left: 0.0,
                                                            top: 0,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                top: 0.0),

                                                            child: ClipOval(
                                                              child: Container(
                                                                width: 140.0,
                                                                // Adjust the width and height as needed
                                                                height: 140.0,
                                                                color: Colors.blue,
                                                                // Background color of the circular container
                                                                child: Image.asset(
                                                                    artistSongs[index]
                                                                        .image),
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
                                          'Kumar Sanu',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Artist Radio',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.normal),
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
                          Row(children: [
                            Text(
                              'Trending Now',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.cyanAccent,
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
                          height: 210,
                          child: ListView.builder(
                              itemCount: trendingSongs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final cartItem = trendingSongs[index];

                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SongsDeatilsList(
                                              url: cartItem.url,
                                              image: cartItem.image,
                                              title: cartItem.title,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: Card(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    // Adjust the radius as needed
                                                    child: Image.asset(
                                                      trendingSongs[index].image,
                                                      fit: BoxFit.fill,
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
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Sachet Tandon',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.normal),
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
                          Row(children: [
                            Text(
                              'Top Charts',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.cyanAccent,
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
                          height: 210,
                          child: ListView.builder(
                              itemCount: topchartSongs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final cartItem = topchartSongs[index];

                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SongsDeatilsList(
                                              url: cartItem.url,
                                              image: cartItem.image,
                                              title: cartItem.title,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: Card(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    // Adjust the radius as needed
                                                    child: Image.asset(
                                                      topchartSongs[index].image,
                                                      fit: BoxFit.fill,
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
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Sachet Tandon',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.normal),
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
                          Row(children: [
                            Text(
                              'New Releasse',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.cyanAccent,
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
                          height: 210,
                          child: ListView.builder(
                              itemCount: newReleasseSongs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final cartItem = newReleasseSongs[index];

                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SongsDeatilsList(
                                              url: cartItem.url,
                                              image: cartItem.image,
                                              title: cartItem.title,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 150,
                                                width: 150,
                                                child: Card(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0),
                                                    // Adjust the radius as needed
                                                    child: Image.asset(
                                                      newReleasseSongs[index].image,
                                                      fit: BoxFit.fill,
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
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Sachet Tandon',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.normal),
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