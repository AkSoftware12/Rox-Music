import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:music_player_saavn/baseurlp/baseurl.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiModel/SearchAllmodel/search_all_model.dart';
import '../../ApiModel/searchSongsModel.dart';
import '../../Model/recentaly.dart';
import '../../Model/search.dart';
import '../../SearchSongs/search_songs.dart';
import '../../Service/MusicService.dart';
import '../../SongInfo/song_info.dart';
import '../HomeDeatils/home_deatils_song_list.dart';
import '../HomeDeatils/weekly_forecast_list.dart';
import '../home.dart';
import 'add_song_list.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyPlayListScreen extends StatefulWidget {
  const MyPlayListScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<MyPlayListScreen> {
  TextEditingController _searchController = TextEditingController();

  MusicService musicService = MusicService();
  bool isLiked = false;
  bool download = false;

  List<RecentlySongs> recently = [
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
        'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg',
        id: ''),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title: 'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
        'https://c.saavncdn.com/529/Shiv-Shankara-Hindi-2019-20190228184236-500x500.jpg',
        id: ''),

  ];
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
  List<RecentlySongs> filteredItems = [];
  List<SearchData> filteredItems1 = [];
  List<dynamic> playlists = [];
  List<dynamic> filteredList = [];
  List<SearchSongModel> searchSongs = [];
  List<AlbumSearch> searchAlbum = [];

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

  @override
  void initState() {
    super.initState();
    hitPlaylists();
    searchApi();
  }


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
              image: songJson['image_data'],
              createdAt: '',
              updatedAt: '',
              imageData: songJson['image_data'],
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



  Future<void> hitPlaylists() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(userPlaylist),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('playlists')) {
        setState(() {
          playlists = responseData['playlists'];
          // filteredList = playlists;
          print(playlists);
        });
      } else {
        throw Exception('Invalid API response: Missing "playlist" key');
      }
    } else {
      throw Exception('Failed to load playlists: ${response.statusCode}');
    }
  }

  void filterList(String query) {
    List<dynamic> filtered = [];
    if (query.isNotEmpty) {
      playlists.forEach((item) {
        if (item.toString().toLowerCase().contains(query.toLowerCase())) {
          filtered.add(item);
        }
      });
    } else {
      filtered = playlists;
    }
    setState(() {
      filteredList = filtered;
    });
  }
  Future<void> _handleRefresh() async {
    try {
      // Fetch new data and update the state
      await hitPlaylists();
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
      backgroundColor: Colors.black,


      body:  _isLoading
          ? Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ))
          :

      RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 40,
              // backgroundColor: const Color(0xFF222B40),
              backgroundColor: Colors.black,
              onStretchTrigger: () async {
                // await Server.requestNewData();
              },
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding:
                  const EdgeInsets.only(top: 25.0, left: 15, right: 15),
                  child: GestureDetector(
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
                    ),                  child: Container(
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
                  SizedBox(
                    height: 100,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                              itemCount: 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10),
                                            child: Text(
                                              'Playlist',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: TextSizes
                                                        .textlargescd,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),

                                        ]),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 1.sp),
                                      child: Text(
                                        '${playlists.length} ${' Playlists'}',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: TextSizes
                                                  .textsmallPlayer,
                                              fontWeight:
                                              FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10),
                                            child: Text(
                                              'Create Playlist',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: TextSizes
                                                        .textlarge,
                                                    fontWeight:
                                                    FontWeight.normal),
                                              ),
                                            ),
                                          ),

                                        ]),

                                  ],
                                );
                              }),
                        ),
                      ),
                    ]),
                  ),

                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 50.0),
              sliver: playlists.isEmpty
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
                    print('Playlists length: ${playlists
                        .length}, Current index: $index');

                    if (index >= playlists.length) {
                      // Index out of range, return an empty container or handle it accordingly
                      return Container();
                    }

                    final cartItem = playlists[index];


                    return GestureDetector(
                      onTap: () {
                        if (playlists[index]['songs'].length == 0) {
                          Fluttertoast.showToast(
                              msg: "Please add song",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SongsDeatilsList(
                                  url: cartItem['id'].toString(),
                                  image: cartItem['image_data'].toString(),
                                  title: cartItem['playlist_name'].toString(),
                                  type: 'playlist_id',
                                );
                              },
                            ),
                          );
                        }


                        // hitUserSongs(trendingSong[index]['id'].toString());

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
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    width: 50.0,
                                    height: 50.0,
                                    imageUrl: playlists[index]['image_data']
                                        .toString(),
                                    fit: BoxFit.cover,
                                    // Adjust this according to your requirement
                                    placeholder: (context, url) =>
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.orangeAccent,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          'assets/no_image.jpg',
                                          // Path to your default image asset
                                          width: 50.0,
                                          height: 50.0,
                                          // Adjust width as per your requirement
                                          fit: BoxFit
                                              .cover, // Adjust this according to your requirement
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
                                      playlists[index]['playlist_name']
                                          .toString(),
                                      style: TextStyle(color: Colors.white,
                                          fontSize: TextSizes.textmedium),
                                    ),
                                    SizedBox(height: 5.sp),
                                    Text('${playlists[index]['songs'].length
                                        .toString()} ${'songs'}',
                                      style: TextStyle(color: Colors.grey,
                                          fontSize: TextSizes.textsmall),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets
                                  .only(
                                  right:
                                  8.0),
                              child:
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20.sp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: playlists.length,
                ),
              ),
            )


          ],
        ),
      ),
      // floatingActionButton: SizedBox(
      //   width: 100.sp,
      //   height: 30.sp,
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.orange,
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) {
      //             return AddSonglistScreen();
      //           },
      //         ),
      //       );
      //     },
      //     child: Text('Add List' ,
      //       style: GoogleFonts.poppins(
      //         textStyle:  TextStyle(
      //             color: Colors.white,
      //
      //             fontSize: TextSizes.textmedium,
      //             fontWeight:
      //             FontWeight.normal),
      //       ),),
      //
      //     // Icon(Icons.add,size: 30,color: Colors.black,),
      //     // shape: CircleBorder(),
      //   ),
      // ),

    );
  }
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child,
      ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child,
      ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.android;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
