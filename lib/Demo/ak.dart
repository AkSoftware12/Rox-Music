import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_saavn/Home/Home%20Bottom/player.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiModel/playModel.dart';
import '../ApiModel/playlist.dart';
import '../CatergoryViewAll/catergory_viewAll.dart';
import '../Download/download.dart';
import '../Home/Home View All/All_tab_view_all.dart';
import '../Home/HomeDeatils/home_deatils_song_list.dart';
import '../Home/HomeDeatils/song_deatils.dart';
import '../Home/home.dart';
import '../Service/MusicService.dart';
import '../Themes/colors.dart';
import '../TodayText/home_deatils_song_list_today.dart';
import '../baseurlp/baseurl.dart';
import '../constants/color_constants.dart';

class AkScreen extends StatefulWidget {
  const AkScreen({
    super.key,
  });

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<AkScreen> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController(initialPage: 0);

  int _selectedIndex = 0;
  bool isLiked = false;
  bool download = false;
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
  }
// musi

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF222B40),
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.all(0.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _onItemTapped(0);
                  },
                  child: Card(
                    color: _selectedIndex == 0
                        ? Colors.orangeAccent
                        : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Music',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : Colors.orangeAccent,
                                fontSize: TextSizes.textlarge,
                                fontWeight: FontWeight.normal,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _onItemTapped(1);
                  },
                  child: Card(
                    color: _selectedIndex == 1
                        ? Colors.orangeAccent
                        : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Podcasts',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: _selectedIndex == 1
                                    ? Colors.white
                                    : Colors.orangeAccent,
                                fontSize: TextSizes.textlarge,
                                fontWeight: FontWeight.normal,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Add this line to remove the back button
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          AllMusicScreen(),
          OnlyMusicScreen(),
        ],
      ),
    );
  }
}
class AllMusicScreen extends StatefulWidget {
  AllMusicScreen({
    super.key,

  });

  @override
  _AllMusicScreenState createState() => _AllMusicScreenState();
}

class _AllMusicScreenState extends State<AllMusicScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Category 1',
      'items': ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5']
    },
    {
      'name': 'Category 2',
      'items': [
        'Item 6',
        'Item 7',
        'Item 8',
        'Item 9',
        'Item 10',
        'trt',
        't',
      ]
    },
  ];

  MusicService musicService = MusicService();
  Timer? timer;

  PageController _pageController = PageController(initialPage: 0);

  bool isDrawerOpen = false;

  List<bool> _selections = [true, false];

  int _selectedIndex = 0;

  bool isLiked = false;

  bool download = false;

  int selectIndex = 0;

  String searchQuery = '';

  String photoUrl = '';

  String albumType = 'album_id';
  String playlistType = 'playlist_id';
  String artistType = 'artist_id';

  List<Music> recentlySong = [];
  List<dynamic> artists = [];
  List<dynamic> topCharts = [];
  List<dynamic> albums = [];
  List<dynamic> newReleas = [];

  List<dynamic> trendingAlbum = [];
  List<dynamic> bollywoodAlbum = [];
  List<dynamic> playlists = [];
  List<dynamic> director = [];
  List<dynamic> banner = [];
  List<dynamic> category = [];

  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a 5-second delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }


  Future<void> _handleRefresh() async {
    try {
      // Fetch new data and update the state
      await hitAllcategory();
      await hitRecently();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Page Refreshed!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    hitAllcategory();
    hitPlaylists();
    hitArtists();
    hitAlbums();
    hitBollywoodalbum();
    hitDirectors();
    hitRecently();
    hitNewRelease();
    hitTrending();
    hitTopCharts();
    _startLoading();
    hitBanner();
    musicService.hitRecently();

    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>    hitRecently());
  }
  Future<void> hitBanner() async {
    final response = await http.get(Uri.parse(albumbanner));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('banner')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          banner = responseData['banner'];
          // restBanner=responseData['data']['banner_img'];
          print(banner);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitUserSongs(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(userSongs),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'song_id': id,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitPlaylists() async {
    final response = await http.get(Uri.parse(playlist));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('playlist')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          playlists = responseData['playlist'];
          // restBanner=responseData['data']['banner_img'];
          print(playlists);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitArtists() async {
    final response = await http.get(Uri.parse(artist));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          artists = responseData['data'];
          // restBanner=responseData['data']['banner_img'];
          print(artists);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitAlbums() async {
    final response = await http.get(Uri.parse(album));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          albums = responseData['data'];
          // restBanner=responseData['data']['banner_img'];
          print(artists);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitTrending() async {
    final response = await http.get(Uri.parse(trendingAlbums));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('trendingAlbums')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          trendingAlbum = responseData['trendingAlbums'];
          // restBanner=responseData['data']['banner_img'];
          print(trendingAlbum);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitBollywoodalbum() async {
    final response = await http.get(Uri.parse(bollywoodalbum));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('bollywoodAlbums')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          bollywoodAlbum = responseData['bollywoodAlbums'];
          // restBanner=responseData['data']['banner_img'];
          print(bollywoodAlbum);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitNewRelease() async {
    final response = await http.get(Uri.parse(newReleaseAlbum));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('newRelease')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          newReleas = responseData['newRelease'];
          // restBanner=responseData['data']['banner_img'];
          print(newReleas);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitAllcategory() async {
    final response = await http.get(Uri.parse(playlistcategory));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('category')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          category = responseData['category'];
          // restBanner=responseData['data']['banner_img'];
          print(category);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitTopCharts() async {
    final response = await http.get(Uri.parse(topChart));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('playlist')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          topCharts = responseData['playlist'];
          // restBanner=responseData['data']['banner_img'];
          print(topCharts);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitDirectors() async {
    final response = await http.get(Uri.parse(directors));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('directors')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          director = responseData['directors'];
          // restBanner=responseData['data']['banner_img'];
          print(director);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }



  Future<void> hitRecently() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(user_songs),
      headers: {
        'Authorization': 'Bearer $token', // Adding the token to the headers
      },
    );



    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('UserSongs')) {
          final List<dynamic> songsJson = responseData['UserSongs'];

          setState(() {
            // Clear the list before adding new data
            recentlySong.clear();
            MusicService.apiData.clear();

            // Parse each song from JSON and add it to the list
            for (var songJson in songsJson) {
              final song = Music(
                title: songJson['title'],
                artist: songJson['singer'][0]['name'].toString(),
                album: songJson['album']['name'],
                imagealbum: songJson['album']['image_data'],
                url: songJson['file_data'],
                song_lyrics: songJson['song_lyrics'].toString(),
                image: songJson['image_data'],
                id: songJson['id'].toString(),
                subtitle: songJson['subtitle'],
                singer_id: songJson['singer_id'].toString(),
                year: songJson['year'].toString(),
                album_id: songJson['album_id'].toString(),
                mood_id: songJson['mood_id'].toString(),
                language_id: songJson['language_id'].toString(),
                genre_id: songJson['genre_id'].toString(),
                music_director_id: songJson['music_director_id'].toString(),
                file_data: songJson['file_data'],
                image_data: songJson['image_data'],
                status: songJson['status'],
                release_date: songJson['release_date'],
                like_flag: songJson['like_flag'],
              );
              // MusicService.recntlyModel.clear();
              //
              // MusicService.recntlyModel.addAll(recentlySong.map((song) => AudioSource.uri(
              //         Uri.parse(song.file_data),
              //         tag: musicToMediaItem(song),
              //       )).toList());

              // MusicService.apiData.add(song);
              recentlySong.add(song);
            }
          });
        } else {
          throw Exception('Invalid API response: Missing "data" key');
        }
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }



      // if (responseData.containsKey('UserSongs')) {
      //   setState(() {
      //     recentlySong = responseData['UserSongs'];
      //     print(recentlySong);
      //   });
      // } else {
      //   throw Exception('Invalid API response: Missing "directors" key');
      // }
    // }
  }


  @override
  Widget build(BuildContext context) {
    return
      _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          :
      RefreshIndicator(
        onRefresh: _handleRefresh,
      child: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                        options: CarouselOptions(
                          height: 100.sp,
                          autoPlay: true,
                          initialPage: 0,
                          viewportFraction: 1,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: (banner.length > 0)
                            ? banner.map((e) {
                                return Builder(
                                  builder: (context) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(0.0),
                                          clipBehavior: Clip.hardEdge,
                                          child: Container(
                                            height: 100.sp,
                                            width: double.infinity,

        //                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: white_color,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child:   ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(0.0),
                                              child: CachedNetworkImage(
                                                imageUrl:  e['image_data'],
                                                fit: BoxFit.fill, // Adjust this according to your requirement
                                                placeholder: (context, url) => Center(
                                                  child: CircularProgressIndicator(
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Image.asset(
                                                  'assets/no_image.jpg', // Path to your default image asset
                                                  // Adjust width as per your requirement
                                                  fit: BoxFit.cover, // Adjust this according to your requirement
                                                ),
                                              ),

                                            ),


                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList()
                            : banner.map((e) {
                                return Builder(builder: (context) {
                                  return Container(
                                    height: 100.sp,
                                    width: MediaQuery.of(context).size.width * 0.90,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  );
                                });
                              }).toList()),

                    Visibility(
                      visible: recentlySong.isNotEmpty,
                      child: Column(
                        children: [
                          //  recently view all
                          SizedBox(
                            height: 50.sp,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: SizedBox(
                                  height: 50.sp,
                                  child: ListView.builder(
                                      itemCount: 1,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            'Recently Songs',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textlarge,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return RecentlySongsClass(
                                                      name: 'Recently',
                                                    );
                                                  },
                                                ),
                                              );

                                            },
                                            child: Text(
                                              'View All',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textlarge,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ]),
                          ),
                          // recntly list
                          SizedBox(
                            height: TextSizes.SizeBoxMain,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: TextSizes.SizeBoxSub,
                                  child: ListView.builder(
                                    itemCount: recentlySong.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                            onTap: () async {


                                              musicService.playSongAtIndex3(index);


                                              final SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                              final String? token = prefs.getString('token');
                                              prefs.remove('singleSong');

                                              final response = await http.post(
                                                Uri.parse(userSongs),
                                                headers: {
                                                  'Content-Type': 'application/json',
                                                  'Authorization': 'Bearer $token',
                                                },
                                                body: jsonEncode({
                                                  'song_id': recentlySong[index].id.toString(),
                                                }),
                                              );

                                              if (response.statusCode == 200) {
                                                return json.decode(response.body);
                                              } else {
                                                throw Exception(
                                                    'Failed to load recently songs');
                                              }




                                              // musicService.playSong(
                                              //     recentlySong[index]['song']['id']
                                              //         .toString(),
                                              //     recentlySong[index]['song']
                                              //             ['file_data']
                                              //         .toString(),
                                              //     recentlySong[index]['song']
                                              //         ['image_data'],
                                              //     recentlySong[index]['song']
                                              //         ['title'],
                                              //     recentlySong[index]['song']
                                              //         ['subtitle']);

                                              // hitUserSongs(recentlySong[index]
                                              //         ['song']['id']
                                              //     .toString());

                                              // final SharedPreferences prefs = await SharedPreferences.getInstance();
                                              // prefs.setString('singleSong','singleSong');
                                              //
                                              //     (audioObject) => currentlyPlaying.value = audioObject;


                                              //
                                              // (context as Element)
                                              //     .findAncestorStateOfType<
                                              //         BottomNavBarDemoState>()
                                              //     ?.toggleMiniPlayerVisibility(
                                              //         true);
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            TextSizes.imageheight,
                                                        width: TextSizes.imagewidth,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(15.0),
                                                          ),
                                                          child:    ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(10.0),
                                                            child: CachedNetworkImage(
                                                              imageUrl:  recentlySong[index].image.toString(),
                                                              fit: BoxFit.fill, // Adjust this according to your requirement
                                                              placeholder: (context, url) => Center(
                                                                child: CircularProgressIndicator(
                                                                  color: Colors.orangeAccent,
                                                                ),
                                                              ),
                                                              errorWidget: (context, url, error) => Image.asset(
                                                                'assets/no_image.jpg', // Path to your default image asset
                                                                 // Adjust width as per your requirement
                                                                fit: BoxFit.cover, // Adjust this according to your requirement
                                                              ),
                                                            ),

                                                          ),






                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100.sp,
                                                  child: Center(
                                                    child: Text(
                                                      recentlySong[index].title
                                                          .toString(),
                                                      style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: TextSizes
                                                                .textsmallPlayer,
                                                            fontWeight:
                                                                FontWeight.normal,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100.sp,
                                                      child: Center(
                                                        child: Text(
                                                              // '${recentlySong[index].album.toString()} ${'/'}'
                                                              ' ${recentlySong[index].artist.toString()}',
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: TextSizes
                                                                  .textsmall,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis),
                                                      ),
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
                        ],
                      ),
                    ),

                    // Visibility(
                    //   visible: trendingAlbum.isNotEmpty,
                    //   child: Column(
                    //     children: [
                    //       // trending view all
                    //       SizedBox(
                    //         height: 50.sp,
                    //         child: Column(children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(top: 0.0),
                    //             child: SizedBox(
                    //               height: 50.sp,
                    //               child: ListView.builder(
                    //                   itemCount: 1,
                    //                   physics: NeverScrollableScrollPhysics(),
                    //                   // scrollDirection: Axis.horizontal,
                    //                   itemBuilder: (context, index) {
                    //                     return ListTile(
                    //                       title: Text(
                    //                         'Trending Now',
                    //                         style: GoogleFonts.poppins(
                    //                           textStyle: TextStyle(
                    //                               color: Colors.white,
                    //                               fontSize: TextSizes.textlarge,
                    //                               fontWeight: FontWeight.bold),
                    //                         ),
                    //                       ),
                    //                       trailing: GestureDetector(
                    //                         onTap: () {
                    //                           Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                               builder: (context) {
                    //                                 return RecentlySongsClass(
                    //                                   name: 'TrendingAlbum',
                    //                                 );
                    //                               },
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: Text(
                    //                           'View All',
                    //                           style: GoogleFonts.poppins(
                    //                             textStyle: TextStyle(
                    //                               color: Colors.white,
                    //                               fontSize: TextSizes.textlarge,
                    //                               fontWeight: FontWeight.bold,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     );
                    //                   }),
                    //             ),
                    //           ),
                    //         ]),
                    //       ),
                    //       // trending list
                    //       SizedBox(
                    //         height: TextSizes.SizeBoxMain,
                    //         child: Column(children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(top: 8.0),
                    //             child: SizedBox(
                    //               height: TextSizes.SizeBoxSub,
                    //               child: ListView.builder(
                    //                   itemCount: trendingAlbum.length,
                    //                   scrollDirection: Axis.horizontal,
                    //                   itemBuilder: (context, index) {
                    //                     final cartItem = trendingAlbum[index];
                    //
                    //                     return OpenContainer(
                    //                       transitionType: ContainerTransitionType.fadeThrough,
                    //                       closedColor: Theme.of(context).cardColor,
                    //                       closedElevation: 0.0,
                    //                       openElevation: 4.0,
                    //                       transitionDuration: Duration(milliseconds: 500),
                    //                       openBuilder: (BuildContext context, VoidCallback _) =>
                    //
                    //
                    //                           SongsDeatilsList(
                    //                         url:
                    //                         cartItem['id'].toString(),
                    //                         image: cartItem['image_data']
                    //                             .toString(),
                    //                         title: cartItem['name']
                    //                             .toString(),
                    //                         type: albumType,
                    //                       ),
                    //                       closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    //                         return Container(
                    //                           color: Colors.black,
                    //                           child: Column(
                    //                             children: [
                    //                               Padding(
                    //                                 padding:
                    //                                 const EdgeInsets.all(0.0),
                    //                                 child: Column(
                    //                                   children: [
                    //                                     SizedBox(
                    //                                       height:
                    //                                       TextSizes.imageheight,
                    //                                       width: TextSizes.imagewidth,
                    //                                       child: Card(
                    //                                         color: Colors.black,
                    //                                         shape:
                    //                                         RoundedRectangleBorder(
                    //                                           borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(15.0),
                    //                                         ),
                    //                                         child:  ClipRRect(
                    //                                           borderRadius:
                    //                                           BorderRadius.circular(10.0),
                    //                                           child: CachedNetworkImage(
                    //                                             imageUrl:  trendingAlbum[index]
                    //                                             ['image_data']
                    //                                                 .toString(),
                    //                                             fit: BoxFit.fill, // Adjust this according to your requirement
                    //                                             placeholder: (context, url) => Center(
                    //                                               child: CircularProgressIndicator(
                    //                                                 color: Colors.orangeAccent,
                    //                                               ),
                    //                                             ),
                    //                                             errorWidget: (context, url, error) => Image.asset(
                    //                                               'assets/no_image.jpg', // Path to your default image asset
                    //                                               // Adjust width as per your requirement
                    //                                               fit: BoxFit.cover, // Adjust this according to your requirement
                    //                                             ),
                    //                                           ),
                    //
                    //                                         ),
                    //
                    //
                    //
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 100.sp,
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     trendingAlbum[index]['name']
                    //                                         .toString(),
                    //                                     style: GoogleFonts.poppins(
                    //                                       textStyle: TextStyle(
                    //                                           color: Colors.white,
                    //                                           fontSize: TextSizes
                    //                                               .textsmallPlayer,
                    //                                           fontWeight:
                    //                                           FontWeight.normal,
                    //                                           overflow: TextOverflow
                    //                                               .ellipsis),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         );
                    //                       },
                    //                     );
                    //
                    //
                    //                       // GestureDetector(
                    //                       //   onTap: () {
                    //                       //     Navigator.push(
                    //                       //       context,
                    //                       //       MaterialPageRoute(
                    //                       //         builder: (context) {
                    //                       //           return SongsDeatilsList(
                    //                       //             url:
                    //                       //                 cartItem['id'].toString(),
                    //                       //             image: cartItem['image_data']
                    //                       //                 .toString(),
                    //                       //             title: cartItem['name']
                    //                       //                 .toString(),
                    //                       //             type: albumType,
                    //                       //           );
                    //                       //         },
                    //                       //       ),
                    //                       //     );
                    //                       //   },
                    //                       //   child: Column(
                    //                       //     children: [
                    //                       //       Padding(
                    //                       //         padding:
                    //                       //             const EdgeInsets.all(0.0),
                    //                       //         child: Column(
                    //                       //           children: [
                    //                       //             SizedBox(
                    //                       //               height:
                    //                       //                   TextSizes.imageheight,
                    //                       //               width: TextSizes.imagewidth,
                    //                       //               child: Card(
                    //                       //                 color: Colors.white,
                    //                       //                 shape:
                    //                       //                     RoundedRectangleBorder(
                    //                       //                   borderRadius:
                    //                       //                       BorderRadius
                    //                       //                           .circular(15.0),
                    //                       //                 ),
                    //                       //                 child:  ClipRRect(
                    //                       //                   borderRadius:
                    //                       //                   BorderRadius.circular(10.0),
                    //                       //                   child: CachedNetworkImage(
                    //                       //                     imageUrl:  trendingAlbum[index]
                    //                       //                     ['image_data']
                    //                       //                         .toString(),
                    //                       //                     fit: BoxFit.fill, // Adjust this according to your requirement
                    //                       //                     placeholder: (context, url) => Center(
                    //                       //                       child: CircularProgressIndicator(
                    //                       //                         color: Colors.orangeAccent,
                    //                       //                       ),
                    //                       //                     ),
                    //                       //                     errorWidget: (context, url, error) => Image.asset(
                    //                       //                       'assets/no_image.jpg', // Path to your default image asset
                    //                       //                       // Adjust width as per your requirement
                    //                       //                       fit: BoxFit.cover, // Adjust this according to your requirement
                    //                       //                     ),
                    //                       //                   ),
                    //                       //
                    //                       //                 ),
                    //                       //
                    //                       //
                    //                       //
                    //                       //               ),
                    //                       //             ),
                    //                       //           ],
                    //                       //         ),
                    //                       //       ),
                    //                       //       SizedBox(
                    //                       //         width: 100.sp,
                    //                       //         child: Center(
                    //                       //           child: Text(
                    //                       //             trendingAlbum[index]['name']
                    //                       //                 .toString(),
                    //                       //             style: GoogleFonts.poppins(
                    //                       //               textStyle: TextStyle(
                    //                       //                   color: Colors.white,
                    //                       //                   fontSize: TextSizes
                    //                       //                       .textsmallPlayer,
                    //                       //                   fontWeight:
                    //                       //                       FontWeight.normal,
                    //                       //                   overflow: TextOverflow
                    //                       //                       .ellipsis),
                    //                       //             ),
                    //                       //           ),
                    //                       //         ),
                    //                       //       ),
                    //                       //     ],
                    //                       //   )
                    //                       // );
                    //                   }),
                    //             ),
                    //           ),
                    //         ]),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    //  bollywood view all
                    SizedBox(
                      height: 50.sp,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: SizedBox(
                            height: 50.sp,
                            child: ListView.builder(
                                itemCount: 1,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'BollyWood Masala',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Bollywood',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ]),
                    ),
                    // bollywood list
                    SizedBox(
                      height: TextSizes.SizeBoxMain,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: TextSizes.SizeBoxSub,
                            child: ListView.builder(
                                itemCount: bollywoodAlbum.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final cartItem = bollywoodAlbum[index];

                                  return GestureDetector(
                                      onTap: () {

                                        // Navigator.pushNamed(context, '/detailsWishlist');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SongsDeatilsList(
                                                url: cartItem['id'].toString(),
                                                image: cartItem['image_data'],
                                                title: cartItem['name'],
                                                type: albumType,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: TextSizes.imageheight,
                                                  width: TextSizes.imagewidth,
                                                  child: Card(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child:  ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: bollywoodAlbum[index]
                                                        ['image_data']
                                                            .toString(),
                                                        fit: BoxFit.fill, // Adjust this according to your requirement
                                                        placeholder: (context, url) => Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.orangeAccent,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          'assets/no_image.jpg', // Path to your default image asset
                                                          // Adjust width as per your requirement
                                                          fit: BoxFit.cover, // Adjust this according to your requirement
                                                        ),
                                                      ),

                                                    ),




                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            bollywoodAlbum[index]['name']
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textsmallPlayer,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Text(
                                          //       'Sachet Tandon',
                                          //       style:
                                          //       GoogleFonts.poppins(
                                          //         textStyle:
                                          //         const TextStyle(
                                          //             color:
                                          //             Colors.grey,
                                          //             fontSize: 11,
                                          //             fontWeight:
                                          //             FontWeight
                                          //                 .normal),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ));
                                }),
                          ),
                        ),
                      ]),
                    ),

                    //  albums view all
                    SizedBox(
                      height: 50.sp,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: SizedBox(
                            height: 50.sp,
                            child: ListView.builder(
                                itemCount: 1,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'All Albums',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Albums',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ]),
                    ),
                    // albums list
                    SizedBox(
                      height: TextSizes.SizeBoxMain,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: TextSizes.SizeBoxSub,
                            child: ListView.builder(
                                itemCount: albums.length,
                                scrollDirection: Axis.horizontal,
                                reverse: false,
                                itemBuilder: (context, index) {
                                  final cartItem = albums[index];

                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SongsDeatilsList(
                                                url: cartItem['id'].toString(),
                                                image: cartItem['image_data'],
                                                title: cartItem['name'],
                                                type: albumType,
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
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: TextSizes.imageheight,
                                                  width: TextSizes.imagewidth,
                                                  child: Card(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child:  ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:albums[index]
                                                        ['image_data']
                                                            .toString(),
                                                        fit: BoxFit.fill, // Adjust this according to your requirement
                                                        placeholder: (context, url) => Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.orangeAccent,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          'assets/no_image.jpg', // Path to your default image asset
                                                          // Adjust width as per your requirement
                                                          fit: BoxFit.cover, // Adjust this according to your requirement
                                                        ),
                                                      ),

                                                    ),

                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            albums[index]['name'].toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textsmallPlayer,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                albums[index]['name'].toString(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: TextSizes.textsmall,
                                                      fontWeight:
                                                          FontWeight.normal),
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

                    // Artist Stations list
                    SizedBox(
                      height: 240.sp,
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
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: TextSizes.textlarge,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 185.sp,
                            child: ListView.builder(
                                itemCount: artists.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final cartItem = artists[index];

                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SongsDeatilsList(
                                                url: cartItem['id'].toString(),
                                                image: cartItem['image_data'],
                                                title: cartItem['name'],
                                                type: artistType,
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
                                                  child: SizedBox(
                                                    height: 120.sp,
                                                    width: 120.sp,
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            left: 0.0,
                                                            top: 0,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                              Center(
                                                child: Card(
                                                    elevation: 4.0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100), // Adjust the value as needed
                                                    ),
                                                    margin: EdgeInsets.all(13.sp),
                                                    child: SizedBox(
                                                      height: 110.sp,
                                                      width: 110.sp,
                                                      child: Column(
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 0.0,
                                                              top: 0,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 0.0),

                                                              child: ClipOval(
                                                                child: Container(
                                                                    width: 110.sp,
                                                                    // Adjust the width and height as needed
                                                                    height: 110.sp,
                                                                    color:
                                                                        Colors.blue,
                                                                    // Background color of the circular container
                                                                    // child: Image.network(
                                                                    //   apiData[index]['image_data'].toString(),fit: BoxFit.cover,
                                                                    // )
                                                                    child:  CachedNetworkImage(
                                                                      imageUrl: artists[index]
                                                                      [
                                                                      'image_data']
                                                                          .toString(),
                                                                      fit: BoxFit.fill, // Adjust this according to your requirement
                                                                      placeholder: (context, url) => Center(
                                                                        child: CircularProgressIndicator(
                                                                          color: Colors.orangeAccent,
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context, url, error) => Image.asset(
                                                                        'assets/no_image.jpg', // Path to your default image asset
                                                                        // Adjust width as per your requirement
                                                                        fit: BoxFit.cover, // Adjust this according to your requirement
                                                                      ),
                                                                    ),

                                                                ),
                                                              ),

                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            artists[index]['name'].toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textsmallPlayer,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Artist Radio',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: TextSizes.textsmall,
                                                      fontWeight:
                                                          FontWeight.normal),
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
                      height: 50.sp,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: SizedBox(
                            height: 50.sp,
                            child: ListView.builder(
                                itemCount: 1,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'Top Charts',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'TopChart',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ]),
                    ),
                    // top charts list
                    SizedBox(
                      height: TextSizes.SizeBoxMain,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: TextSizes.SizeBoxSub,
                            child: ListView.builder(
                                itemCount: topCharts.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final cartItem = topCharts[index];

                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SongsDeatilsList(
                                                url: cartItem['id'].toString(),
                                                image: cartItem['image_data']
                                                    .toString(),
                                                title: cartItem['playlist_name']
                                                    .toString(),
                                                type: playlistType,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: TextSizes.imageheight,
                                                  width: TextSizes.imagewidth,
                                                  child: Card(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child:   ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:topCharts[index]
                                                        ['image_data']
                                                            .toString(),
                                                        fit: BoxFit.fill, // Adjust this according to your requirement
                                                        placeholder: (context, url) => Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.orangeAccent,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          'assets/no_image.jpg', // Path to your default image asset
                                                          // Adjust width as per your requirement
                                                          fit: BoxFit.cover, // Adjust this according to your requirement
                                                        ),
                                                      ),

                                                    ),


                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            topCharts[index]['playlist_name']
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textsmallPlayer,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                topCharts[index]['description']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: TextSizes.textsmall,
                                                      fontWeight:
                                                          FontWeight.normal),
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

                    // playlistData view all
                    SizedBox(
                      height: 50.sp,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: SizedBox(
                            height: 50.sp,
                            child: ListView.builder(
                                itemCount: 1,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'Playlist',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Playlists',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Best Of 90s',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 195.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return RecentlySongsClass(
                                                      name: 'Playlists',
                                                    );
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
                                      ]);
                                }),
                          ),
                        ),
                      ]),
                    ),
                    // playlistDatalist
                    SizedBox(
                      height: TextSizes.SizeBoxMain,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: TextSizes.SizeBoxSub,
                            child: ListView.builder(
                                itemCount: playlists.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final cartItem = playlists[index];

                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SongsDeatilsList(
                                                url: cartItem['id'].toString(),
                                                image: cartItem['image_data']
                                                    .toString(),
                                                title: cartItem['playlist_name']
                                                    .toString(),
                                                type: playlistType,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: TextSizes.imageheight,
                                                  width: TextSizes.imagewidth,
                                                  child: Card(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:playlists[index]
                                                        ['image_data']
                                                            .toString(),
                                                        fit: BoxFit.fill, // Adjust this according to your requirement
                                                        placeholder: (context, url) => Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.orangeAccent,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          'assets/no_image.jpg', // Path to your default image asset
                                                          // Adjust width as per your requirement
                                                          fit: BoxFit.cover, // Adjust this according to your requirement
                                                        ),
                                                      ),

                                                    ),


                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100.sp,
                                            child: Center(
                                              child: Text(
                                                playlists[index]['playlist_name']
                                                    .toString(),
                                                // playlists[index]['name'].toString(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          TextSizes.textsmallPlayer,
                                                      fontWeight: FontWeight.normal,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 100.sp,
                                                child: Center(
                                                  child: Text(
                                                    playlists[index]['description']
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize:
                                                              TextSizes.textsmall,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
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

                    // new releasse view all
                    SizedBox(
                      height: 50.sp,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: SizedBox(
                            height: 50.sp,
                            child: ListView.builder(
                                itemCount: 1,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'New Releasse',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'NewReleasse',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View All',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textlarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ]),
                    ),
                    // new releasse list
                    SizedBox(
                      height: TextSizes.SizeBoxMain,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: TextSizes.SizeBoxSub,
                            child: ListView.builder(
                                itemCount: newReleas.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final cartItem = newReleas[index];

                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SongsDeatilsList(
                                                url: cartItem['id'].toString(),
                                                image: cartItem['image_data']
                                                    .toString(),
                                                title: cartItem['name'].toString(),
                                                type: albumType,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: TextSizes.imageheight,
                                                  width: TextSizes.imagewidth,
                                                  child: Card(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child:  ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:newReleas[index]
                                                        ['image_data']
                                                            .toString(),
                                                        fit: BoxFit.fill, // Adjust this according to your requirement
                                                        placeholder: (context, url) => Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.orangeAccent,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          'assets/no_image.jpg', // Path to your default image asset
                                                          // Adjust width as per your requirement
                                                          fit: BoxFit.cover, // Adjust this according to your requirement
                                                        ),
                                                      ),

                                                    ),

                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100.sp,
                                            child: Center(
                                              child: Text(
                                                newReleas[index]['name'].toString(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          TextSizes.textsmallPlayer,
                                                      fontWeight: FontWeight.normal,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Text(
                                          //       newReleas[
                                          //       index]['subtitle'].toString(),
                                          //       style:
                                          //       GoogleFonts.poppins(
                                          //         textStyle:
                                          //         const TextStyle(
                                          //             color:
                                          //             Colors.grey,
                                          //             fontSize: 11,
                                          //             fontWeight:
                                          //             FontWeight
                                          //                 .normal),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ));
                                }),
                          ),
                        ),
                      ]),
                    ),



                 //   Nested list View Start

                    SingleChildScrollView(
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: 45.sp),
                        child: Column(
                          children: category.map((category) {
                            return SizedBox(
                              child: Padding(
                                padding:  EdgeInsets.only(bottom: 0.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    SizedBox(
                                      height: 40.sp,
                                      child: ListView.builder(
                                          itemCount: 1,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                category['name'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: TextSizes.textmedium,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              trailing: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return CatergoryViewAllClass(
                                                          name: category['name'],
                                                          id: category['id'].toString(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: TextSizes.textmedium,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),

                                    SizedBox(
                                      height: TextSizes.SizeBoxMain,
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            height: TextSizes.SizeBoxSub,
                                            child: ListView.builder(
                                                itemCount:  category['playlist'].length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, itemIndex) {
                                                  final playlist =
                                                  category['playlist'][itemIndex];
                                                  return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return SongsDeatilsList(
                                                                url: category['playlist'][itemIndex]['id'].toString(),
                                                                image: category['playlist'][itemIndex]['image_data']
                                                                    .toString(),
                                                                title: category['playlist'][itemIndex]['playlist_name'].toString(),
                                                                type: 'playlist_id',
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(0.0),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: TextSizes.imageheight,
                                                                  width: TextSizes.imagewidth,
                                                                  child: Card(
                                                                    color: Colors.white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          15.0),
                                                                    ),
                                                                    child:  ClipRRect(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl:playlist
                                                                        ['image_data']
                                                                            .toString(),
                                                                        fit: BoxFit.fill, // Adjust this according to your requirement
                                                                        placeholder: (context, url) => Center(
                                                                          child: CircularProgressIndicator(
                                                                            color: Colors.orangeAccent,
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context, url, error) => Image.asset(
                                                                          'assets/no_image.jpg', // Path to your default image asset
                                                                          // Adjust width as per your requirement
                                                                          fit: BoxFit.cover, // Adjust this according to your requirement
                                                                        ),
                                                                      ),

                                                                    ),

                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100.sp,
                                                            child: Center(
                                                              child: Text(
                                                                playlist['playlist_name'].toString(),
                                                                style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize:
                                                                      TextSizes.textsmallPlayer,
                                                                      fontWeight: FontWeight.normal,
                                                                      overflow:
                                                                      TextOverflow.ellipsis),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // Row(
                                                          //   children: [
                                                          //     Text(
                                                          //       newReleas[
                                                          //       index]['subtitle'].toString(),
                                                          //       style:
                                                          //       GoogleFonts.poppins(
                                                          //         textStyle:
                                                          //         const TextStyle(
                                                          //             color:
                                                          //             Colors.grey,
                                                          //             fontSize: 11,
                                                          //             fontWeight:
                                                          //             FontWeight
                                                          //                 .normal),
                                                          //       ),
                                                          //     ),
                                                          //   ],
                                                          // ),
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
                            );
                          }).toList(),
                        ),
                      ),
                    ),

            //       Nested list View close
                  ],
                ),
              ),
    );

  }
  void _audioPlayerTaskEntrypoint() {
    AudioServiceBackground.run(() => MusicService());
  }
}

class OnlyMusicScreen extends StatefulWidget {
  OnlyMusicScreen({super.key});

  @override
  State<OnlyMusicScreen> createState() => _OnlyMusicScreenState();
}

class _OnlyMusicScreenState extends State<OnlyMusicScreen> {
  MusicService musicService = MusicService();

  PageController _pageController = PageController(initialPage: 0);

  TabController? _tabController;

  bool isDrawerOpen = false;

  List<bool> _selections = [true, false];

  int _selectedIndex = 0;

  bool isLiked = false;

  bool download = false;

  int selectIndex = 0;

  String searchQuery = '';

  List<dynamic> hindiSong = [];
  List<dynamic> punjabiSong = [];
  List<dynamic> haryanviSong = [];
  List<dynamic> bollywoodSong = [];
  List<dynamic> trendingSong = [];
  List<dynamic> newReleas = [];
  List<dynamic> banner = [];
  List<dynamic> category = [];

  bool _isLoading = false;
  final List<String> _images = [
    'https://anyimage.io/storage/uploads/3141a9803708905d61a8954cb6bf7c35',
    'https://anyimage.io/storage/uploads/174d0a05743022fac034353ef5701fb0',
  ];
  Future<void> hitAllcategory() async {
    final response = await http.get(Uri.parse(playlistcategory));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('category')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          category = responseData['category'];
          // restBanner=responseData['data']['banner_img'];
          print(category);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitBanner() async {
    final response = await http.get(Uri.parse(songbanner));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('banner')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          banner = responseData['banner'];
          // restBanner=responseData['data']['banner_img'];
          print(banner);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a 5-second delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // hitPunjabiSongs();
    // hitHaryanviSongs();
    // hitHindiSongs();
    // hitBollywoodSongs();
    // hitTrendingSongs();
    // _startLoading();
    // hitNewRelease();
    // hitBanner();
    // hitAllcategory();
  }

  Future<void> hitUserSongs(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(userSongs),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'song_id': id,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitNewRelease() async {
    final response = await http.get(Uri.parse(newRelease));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          newReleas = responseData['songs'];
          // restBanner=responseData['data']['banner_img'];
          print(newReleas);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitPunjabiSongs() async {
    final response = await http.get(Uri.parse(punjabiSongs));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          punjabiSong = responseData['songs'];
          // restBanner=responseData['data']['banner_img'];
          print(punjabiSong);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitHaryanviSongs() async {
    final response = await http.get(Uri.parse(haryanviSongs));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          haryanviSong = responseData['songs'];
          // restBanner=responseData['data']['banner_img'];
          print(haryanviSong);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitHindiSongs() async {
    final response = await http.get(Uri.parse(hindiSongs));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          hindiSong = responseData['songs'];
          // restBanner=responseData['data']['banner_img'];
          print(hindiSong);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitBollywoodSongs() async {
    final response = await http.get(Uri.parse(bollywoodSongs));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          bollywoodSong = responseData['songs'];
          // restBanner=responseData['data']['banner_img'];
          print(bollywoodSong);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> hitTrendingSongs() async {
    final response = await http.get(Uri.parse(trendingSongsApi));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('trendingSongs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          trendingSong = responseData['trendingSongs'];
          // restBanner=responseData['data']['banner_img'];
          print(trendingSong);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        :  Center(
      child: Text('Up Comming',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Colors.green,
              fontSize: TextSizes.textlarge,
              fontWeight: FontWeight.bold),
        ),
      ),
    );


//     SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: [
//                   CarouselSlider(
//                       options: CarouselOptions(
//                         height: 100.sp,
//                         autoPlay: true,
//                         initialPage: 0,
//                         viewportFraction: 1,
//                         enableInfiniteScroll: true,
//                         reverse: false,
//                         autoPlayInterval: Duration(seconds: 3),
//                         autoPlayAnimationDuration: Duration(milliseconds: 800),
//                         autoPlayCurve: Curves.fastOutSlowIn,
//                         scrollDirection: Axis.horizontal,
//                       ),
//                       items: (banner.length > 0)
//                           ? banner.map((e) {
//                               return Builder(
//                                 builder: (context) {
//                                   return InkWell(
//                                     onTap: () {},
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 0, vertical: 0),
//                                       child: Material(
//                                         borderRadius:
//                                             BorderRadius.circular(0.0),
//                                         clipBehavior: Clip.hardEdge,
//                                         child: Container(
//                                           height: 100.sp,
//                                           width: double.infinity,
//
// //                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
//                                           decoration: BoxDecoration(
//                                             color: white_color,
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                           ),
//                                           child: Image.network(
//                                             e['image_data'],
//                                             fit: BoxFit.fill,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             }).toList()
//                           : banner.map((e) {
//                               return Builder(builder: (context) {
//                                 return Container(
//                                   height: 100.sp,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.90,
//                                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                   ),
//                                 );
//                               });
//                             }).toList()),
//
//                   // Nested list View Start
//
//                   SingleChildScrollView(
//                     child: Column(
//                       children: category.map((category) {
//                         return SizedBox(
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 18.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//
//                                 SizedBox(
//                                   height: 40.sp,
//                                   child: ListView.builder(
//                                       itemCount: 1,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         return ListTile(
//                                           title: Text(
//                                             category['name'],
//                                             style: GoogleFonts.poppins(
//                                               textStyle: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: TextSizes.textlarge,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           trailing: GestureDetector(
//                                             onTap: () {
//
//                                             },
//                                             child: Text(
//                                               'View All',
//                                               style: GoogleFonts.poppins(
//                                                 textStyle: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: TextSizes.textlarge,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }),
//                                 ),
//
//                                 SizedBox(
//                                   height: 200,
//                                   // Adjust the height of the horizontal ListView
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: category['playlist'].length,
//                                     itemBuilder:
//                                         (BuildContext context, int itemIndex) {
//                                       final playlist =
//                                           category['playlist'][itemIndex];
//
//                                       return GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) {
//                                                 return SongsDeatilsList(
//                                                   url: category['playlist'][itemIndex]['id'].toString(),
//                                                   image: category['playlist'][itemIndex]['image_data']
//                                                       .toString(),
//                                                   title: category['playlist'][itemIndex]['playlist_name'].toString(),
//                                                   type: 'playlist_id',
//                                                 );
//                                               },
//                                             ),
//                                           );
//
//                                         },
//                                         child: Column(
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: SizedBox(
//                                                 height: 150,
//                                                 // Adjust the size of the image
//                                                 width: 150,
//                                                 // Adjust the size of the image
//                                                 child: Card(
//                                                   color: Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15.0),
//                                                   ),
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10.0),
//                                                     child: Image.network(
//                                                       playlist['image_data'],
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 150,
//                                               // Adjust the width of the text
//                                               child: Center(
//                                                 child: Text(
//                                                   playlist['playlist_name'],
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize:
//                                                         16, // Adjust the font size as needed
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//
//                   // Nested list View close
//                 ],
//               ),
//             ),
//           );
  }

}
