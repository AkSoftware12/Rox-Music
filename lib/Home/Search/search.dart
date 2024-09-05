import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_saavn/ApiModel/SearchAllmodel/search_all_model.dart';
import 'package:music_player_saavn/ApiModel/treading_songs.dart';
import 'package:music_player_saavn/SearchSongs/search_songs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:search_page/search_page.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiModel/playModel.dart';
import '../../ApiModel/searchSongsModel.dart';
import '../../Model/recentaly.dart';
import '../../Model/search.dart';
import '../../Service/MusicService.dart';
import '../../SongInfo/song_info.dart';
import '../../Utils/textSize.dart';
import '../Home View All/All_tab_view_all.dart';
import '../Home View All/Music viewAll/music_view_all.dart';
import '../HomeDeatils/home_deatils_song_list.dart';
import '../HomeDeatils/weekly_forecast_list.dart';
import 'package:http/http.dart' as http;

import '../../baseurlp/baseurl.dart';
import '../home.dart';




class Song implements Comparable<Song>{
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
  int compareTo(Song other) => title.compareTo(other.title);
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool download = false;
  List<Music> apiData = [];
  MusicService musicService = MusicService();
  bool isLoading = false;
  bool isPlaying = false;
  bool isDataEmpty = true;
  bool isLiked = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  List<dynamic> moodList = [];
  List<dynamic> filteredList2 = [];
  List<dynamic> trendingSong = [];
  List<dynamic> filteredList = [];
  late List<bool> isDownloadingList;
  late List<double> downloadProgressList;

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
  Future<void> downloadFile(String url, String filename, int index) async {
    setState(() {
      isDownloadingList[index] = true;
      downloadProgressList[index] = 0.0;
    });

    try {
      Dio dio = Dio();

      // Request permission to write to external storage
      PermissionStatus status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        // Get the directory to store the downloaded file
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> folders = directory!.path.split("/");
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Download";
          directory = Directory(newPath);
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        String filePath = '${directory.path}/$filename.mp3';

        // Start the download
        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                downloadProgressList[index] = received / total;
              });
            }
          },
        );

        setState(() {
          downloadProgressList[index] = 1.0; // Ensure 100% completion
          isDownloadingList[index] = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      setState(() {
        isDownloadingList[index] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }



  List<SearchData> channelData = [
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/03/22/17/28/rings-684944_640.jpg',
      backgroundColor: Colors.blue,
      text: 'Romance',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/02/03/16/52/chain-257490_1280.jpg',
      backgroundColor: Colors.red,
      text: 'EDM',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/08/24/11/04/brain-2676370_640.jpg',
      backgroundColor: Colors.orangeAccent,
      text: 'The College Playlists',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/11/13/06/10/boy-529065_640.jpg',
      backgroundColor: Colors.green,
      text: 'Dance',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/01/12/17/40/padlock-597495_640.jpg',
      backgroundColor: Colors.lime,
      text: 'Workout',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/05/26/07/43/sea-5221913_640.jpg',
      backgroundColor: Colors.pink,
      text: 'The 1990s',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2013/07/25/11/52/rajiv-gandhi-sea-link-166867_640.jpg',
      backgroundColor: Colors.purple,
      text: 'Happy',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/09/08/09/10/rings-7440500_640.jpg',
      backgroundColor: Colors.brown,
      text: 'Best Of 2023',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/07/29/14/34/ballet-1553361_640.jpg',
      backgroundColor: Colors.orange,
      text: 'Chill',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2013/01/29/00/47/search-engine-76519_640.png',
      backgroundColor: Colors.redAccent,
      text: 'Party',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/09/27/19/35/red-3707726_640.jpg',
      backgroundColor: Colors.brown,
      text: 'Best Of 2020',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/04/05/08/22/pair-707508_640.jpg',
      backgroundColor: Colors.blueGrey,
      text: 'Best Of 2021',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/04/05/08/21/heart-707504_640.jpg',
      backgroundColor: Colors.amber,
      text: 'Love',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/07/11/15/08/peacock-2493865_640.jpg',
      backgroundColor: Colors.deepOrange,
      text: 'Best Of 2019',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/05/13/11/01/car-history-free-2309305_640.jpg',
      backgroundColor: Colors.indigo,
      text: 'Hip Hop',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2012/11/13/17/45/e-mail-65928_640.jpg',
      backgroundColor: Colors.lightGreen,
      text: 'The 2010s',
    ),
  ];

  List<SearchData> filteredItems1 = [];
  List<dynamic> trendingAlbum = [];
  @override
  void initState() {
    filteredList = List.from(trendingSong);
    filteredList2 = List.from(moodList);
    hitMood();
    _startLoading();
    hitTrendingSongs();
    hitTrending();
    searchApi();
    super.initState();

  }

  Future<void> hitMood() async {
    final response = await http.get(Uri.parse(mood));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('mood')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          moodList = responseData['mood'];

          filteredList2=moodList;
          // restBanner=responseData['data']['banner_img'];
          print(moodList);

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
        final List<dynamic> songsJson = responseData['trendingSongs'];

        setState(() {
          // Parse each song from JSON and add it to the list


          trendingSong=songsJson;
          filteredList=trendingSong;


          isDownloadingList = List<bool>.filled(filteredList.length, false);
          downloadProgressList = List<double>.filled(filteredList.length, 0.0);


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



  Future<void> hitUserSongs( String id) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(userSongs),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'song_id': id,}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }

  }



  List<SearchSongModel> searchSongs = [];
  List<AlbumSearch> searchAlbum = [];

  Future<void> searchApi() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(search),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('results')) {
        final List<dynamic> songsJson = responseData['results']['songs'];
        final List<dynamic> albumsJson = responseData['results']['albums'];
        final List<dynamic> playlistsJson = responseData['results']['playlists'];
        final List<dynamic> singersJson = responseData['results']['singers'];

        setState(() {
          searchSongs.clear();
          searchAlbum.clear();
          for (var songJson in singersJson) {
            final song = AlbumSearch(
              name: songJson['name'],
              status: songJson['status'].toString(),
              image: songJson['image_data'],
              imageData: songJson['image_data'],
              id: songJson['id'].toString(),
              albumcat: 'artist_id', createdAt: '', updatedAt: '',
              artistname: '',
            );

            searchAlbum.add(song);
          }

          for (var songJson in albumsJson) {
            final song = AlbumSearch(
              name: songJson['name'],
              status: songJson['status'].toString(),
              image: songJson['image_data'],
              createdAt: '',
              updatedAt: '',
              imageData: songJson['image_data'],
              id: songJson['id'].toString(),
              albumcat: 'album_id', artistname: '',
            );

            searchAlbum.add(song);
          }


          for (var songJson in playlistsJson) {
            final song = AlbumSearch(
              name: songJson['playlist_name'],
              status: songJson['status'].toString(),
              image: songJson['image_data'].toString(),
              createdAt: '',
              updatedAt: '',
              imageData: songJson['image_data'].toString(),
              id: songJson['id'].toString(),
              albumcat: 'playlist_id', artistname: '',
            );

            searchAlbum.add(song);
          }




          for (var songJson in songsJson) {
            final song = SearchSongModel(
              title: songJson['title'],
              artist: songJson['singer_name'].toString(),
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

            searchSongs.add(song);
          }

        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load songs: ${response.statusCode}');
    }
  }




@override
  void dispose() {
    super.dispose();
  }


  Future<void> _handleRefresh() async {
    try {
      // Fetch new data and update the state
      await hitTrending();
      await  hitMood();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black,

      // backgroundColor: const Color(0xFF222B40),
      body:

      RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              stretch: true,
              expandedHeight: 40,
              // backgroundColor: const Color(0xFF222B40),
              backgroundColor:  Colors.black,
              onStretchTrigger: () async {
                // await Server.requestNewData();
              },
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding:
                  const EdgeInsets.only(top: 25.0, left: 15, right: 15),
                  child:

                  GestureDetector(
                    //
                    onTap: () => showSearch(
                      context: context,
                      delegate: SearchPage(
                        barTheme: ThemeData.dark().copyWith(
                          inputDecorationTheme: InputDecorationTheme(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                        onQueryUpdate: print,
                        items: searchAlbum,

                        searchLabel: 'Search item',
                        suggestion: const Center(
                          child: Text('Search Item ',style: TextStyle(color: Colors.white),),
                        ),
                        failure: const Center(
                          child: Text('No data found :('
                            ,style: TextStyle(color: Colors.white),

                          ),
                        ),
                        filter: (person) => [
                          person.name,
                          person.artistname,
                        ],
                        sort: (a, b) => a.compareTo(b),
                        builder: (person) =>
                            GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SongsDeatilsList(
                                    url: person.id.toString() ?? 'defaultId',
                                    image: person.imageData.toString() ?? 'defaultImage',
                                    title: person.name.toString() ?? 'defaultTitle',
                                    type: person.albumcat.toString(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.black,
                            elevation: 4,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SongsDeatilsList(
                                        url: person.id.toString(),
                                        image: person.imageData
                                            .toString(),
                                        title: person.name
                                            .toString(),
                                        type: 'album_id',
                                      );
                                    },
                                  ),
                                );
                              },

                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                      width: 50.0,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        child: Image.network(
                                          person.imageData,
                                          // playlist[index].image.toString(),
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            // Return a default image widget here
                                            return Container(
                                              width: 50.0,
                                              height: 50.0,
                                              color: Colors.grey,
                                              // Placeholder color
                                              // You can customize the default image as needed
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(person.name
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: TextSizes
                                                    .textsmallPlayer),
                                          ),
                                          SizedBox(height: 5.sp),
                                          // Row(
                                          //   children: [
                                          //     Text(
                                          //       searchSongs[index].album
                                          //           .toString(),
                                          //       style: TextStyle(
                                          //           color: Colors.grey,
                                          //           fontSize: TextSizes
                                          //               .textsmall),
                                          //       maxLines: 1,
                                          //       overflow:
                                          //       TextOverflow.ellipsis,
                                          //     ),
                                          //     Text(
                                          //       ' / ',
                                          //       style: TextStyle(
                                          //           color: Colors.grey,
                                          //           fontSize: TextSizes
                                          //               .textsmall),
                                          //       maxLines: 1,
                                          //       overflow:
                                          //       TextOverflow.ellipsis,
                                          //     ),
                                          //     Text('',
                                          //
                                          //       style: TextStyle(
                                          //           color: Colors.grey,
                                          //           fontSize: 8.sp),
                                          //       maxLines: 1,
                                          //       overflow:
                                          //       TextOverflow.ellipsis,
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0.0),
                                        child: PopupMenuButton<int>(
                                          iconColor: Colors.white,

                                          itemBuilder: (context) => [


                                            PopupMenuItem(
                                              value: 1,
                                              // row with two children
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Song Info",
                                                    style: GoogleFonts
                                                        .poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: TextSizes
                                                              .textsmallPlayer,
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),


                                          ],
                                          offset: Offset(0, 100),
                                          color: Colors.black,
                                          elevation: 2,
                                          // on selected we show the dialog box
                                          onSelected: (value) async {
                                            // if value 1 show dialog
                                            if (value == 1) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongInfoScreen(
                                                      songId: person.id,
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),

                                      // Add more Padding widgets for additional icons if needed
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ),
                    ),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0), // Controls corner radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 2, // Shadow spread radius
                            blurRadius: 4, // Shadow blur radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.search,color: Colors.black,size: 20.sp,),
                            ),
                            Text('Search',
                              style: GoogleFonts.poppins(
                                textStyle:  TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.normal),
                              ),

                            )
                          ],
                        )
                      ),
                    ),
                  )

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 50,
                      // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title: SizedBox(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'its pretty quiet in here.',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  TextSpan(text: '\n'), // Add a line break
                                  TextSpan(
                                    text: 'You havent searched for anything yet.',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 8,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        trailing: Container(
                          width: 100,
                          // Set the desired width and height for your round card
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            // Adjust the radius to change the roundness
                            color: Colors.white, // Background color of the card
                          ),
                          child: Center(
                            child: Text(
                              'Surprise Me!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          // GoRouter.of(context).go('/account/details');
                          // context.goNamed("subAccount");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return NotificationScreen();
                          //     },
                          //   ),
                          // );
                        },
                      ), // Margin around the card
                    ),
                  ),




                ],
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(5.sp),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: <Widget>[

                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Trending',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets
                                    .only(
                                    right:
                                    10.sp),
                                child:
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'TrendingAlbum',
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
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      );




                    },
                    childCount: 1,
                  )),
            ),

            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: trendingAlbum.isEmpty
                  ? SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  child: Center(
                    child: Text(
                      'No playlists found',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    // Debugging: Print out the length of playlists and the current index
                    print('Playlists length: ${trendingAlbum.length}, Current index: $index');

                    if (index >= trendingAlbum.length) {
                      // Index out of range, return an empty container or handle it accordingly
                      return Container();
                    }

                    final cartItem = trendingAlbum[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SongsDeatilsList(
                                url:
                                cartItem['id'].toString(),
                                image: cartItem['image_data']
                                    .toString(),
                                title: cartItem['name']
                                    .toString(),
                                type: 'album_id',
                              );
                            },
                          ),
                        );

                      },
                      child: Card(
                        color: Colors
                            .black,
                        elevation: 4,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets
                                  .all(
                                  5.0),
                              child:
                              SizedBox(
                                width:
                                50.0,
                                child:
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    width: 50.0,
                                    height: 50.0,
                                    imageUrl:  trendingAlbum[index]['image_data'].toString(),
                                    fit: BoxFit.cover, // Adjust this according to your requirement
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      'assets/r_m_image.png', // Path to your default image asset
                                      width: 50.0,
                                      height: 50.0, // Adjust width as per your requirement
                                      fit: BoxFit.cover, // Adjust this according to your requirement
                                    ),
                                  ),

                                ),
                              ),
                            ),
                            Expanded(
                              child:
                              Padding(
                                padding:
                                EdgeInsets.all(10.0),
                                child:
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      trendingAlbum[index]['name'].toString(),
                                      style: TextStyle(color: Colors.white, fontSize: TextSizes.textmedium),
                                    ),
                                    SizedBox(height: 5.sp),
                                    // Text(trendingAlbum[index]['subtitle'].toString(),
                                    //   style: TextStyle(color: Colors.grey, fontSize: TextSizes.textsmall),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [

                                SizedBox(
                                  width: 40.sp,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SongsDeatilsList(
                                              url:
                                              cartItem['id'].toString(),
                                              image: cartItem['image_data']
                                                  .toString(),
                                              title: cartItem['name']
                                                  .toString(),
                                              type: 'album_id',
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),





                                // Add more Padding widgets for additional icons if needed
                              ],
                            ),


                          ],
                        ),
                      ),
                    );


                  },
                  childCount: min(trendingAlbum.length, 3),
                ),
              ),
            ),



            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 18.0, left: 15.0, right: 15,),
                child: Row(
                  children: [
                    SizedBox(
                        height: 20,
                        child: Text(
                          'Channel',
                          style: TextStyle(
                            color: Colors.white,
                            // Text color
                            fontSize: 16.0,
                            // Font size
                            fontWeight: FontWeight.bold,
                            // Font weight
                            fontStyle: FontStyle.normal,
                            // Font style
                            fontFamily: 'Roboto', // Custom font family
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 50.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.7
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    // Define your ratios here as needed
                    List<double> ratios = [1.0, 0.5, 1.5, 0.8]; // Example ratios
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SongsDeatilsList(
                                  url: filteredList2[index]['id'].toString(),
                                  image: filteredList2[index]['image_data'],
                                  title: filteredList2[index]['name'],
                                  type: 'mood_id',
                                );
                              },
                            ),
                          );






                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Stack(
                            children: [
                              // Background Image
                              Container(
                                  width: 300,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: channelData[index].backgroundColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),

                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text( filteredList2[index]['name'],
                                        // channelData[index].text,
                                        style: TextStyle(
                                          color: Colors.white,
                                          // Text color
                                          fontSize: TextSizes.textmedium,
                                          // Font size
                                          fontWeight: FontWeight.bold,
                                          // Font weight
                                          fontStyle: FontStyle.normal,
                                          // Font style
                                          fontFamily: 'Roboto', // Custom font family
                                        ),),
                                    ),
                                  )


                              ),
                              // Overlapping Card
                              Positioned(
                                  top: 40,
                                  left: 25,
                                  right: 25,

                                  child: Transform.rotate(
                                    angle:-8 * (3.141592653589793 / 180),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                          width: 200,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            // borderRadius: BorderRadius.circular(10.0),
                                          ),

                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),


                                            child: CachedNetworkImage(
                                              imageUrl:
                                              filteredList2[index]['image_data'].toString(),
                                              fit: BoxFit.fill,
                                              // Adjust this according to your requirement
                                              placeholder: (context, url) =>
                                                  Center(
                                                    child:
                                                    CircularProgressIndicator(
                                                      color: Colors.orangeAccent,
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                  Image.asset(
                                                    'assets/no_image.jpg',
                                                    // Path to your default image asset
                                                    // Adjust width as per your requirement
                                                    fit: BoxFit
                                                        .cover, // Adjust this according to your requirement
                                                  ),
                                            ),

                                          )
                                      ),

                                    ),)
                              ),
                            ],

                          ),
                        )
                    );

                  },
                  childCount: filteredList2.length, // Replace this with your desired number of children
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
