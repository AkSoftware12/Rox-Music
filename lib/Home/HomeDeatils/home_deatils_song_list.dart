import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_saavn/ApiModel/playModel.dart';
import 'package:music_player_saavn/Home/Home%20Bottom/deidfb.dart';
import 'package:music_player_saavn/Utils/string.dart';
import 'package:music_player_saavn/Widget/widgetShuffle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Route/homebottom.dart';
import '../../Service/MusicService.dart';
import 'package:http/http.dart' as http;
import '../../SongInfo/song_info.dart';
import '../../Utils/textSize.dart';
import '../../Widget/likeUnlike.dart';
import '../../baseurlp/baseurl.dart';
import '../../constants/color_constants.dart';
import '../Home Bottom/miniplayer.dart';
import '../Home Bottom/player.dart';
import '../My PlayList/add_song_list.dart';
import '../home.dart';

class SongsDeatilsList extends StatefulWidget {
  final String url;
  final String image;
  final String title;
  final String type;

  const SongsDeatilsList(
      {super.key,
      required this.url,
      required this.image,
      required this.title,
      required this.type});

  @override
  State<SongsDeatilsList> createState() => SongsDeatilsListState();
}

class SongsDeatilsListState extends State<SongsDeatilsList> {
  bool download = false;
  List<Music> apiData = [];
  List<MediaItem> apiDataDmo = [];
  MusicService musicService = MusicService();

  bool isLoading = false;
  bool isPlaying = false;
  bool isDataEmpty = true;
  bool isLiked = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  late List<bool> isDownloadingList;
  late List<double> downloadProgressList;

  Future<void> songApi() async {
    setState(() {
      isLoading = true; // Set loading indicator to true
      isDataEmpty = false; // Set to false if data is found
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      // Adjust content type as per your API requirements
    };

    final response = await http.get(
      Uri.parse('$media${widget.type}=${widget.url}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        final List<dynamic> songsJson = responseData['data']['songs'];

        setState(() {
          apiData.clear();
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

            MusicService.apiData.add(song);
            apiData.add(song);
          }

          // Update the lengths of isDownloadingList and downloadProgressList
          isDownloadingList = List<bool>.filled(apiData.length, false);
          downloadProgressList = List<double>.filled(apiData.length, 0.0);

          // // Update apiplaylist and apiplaylist2

          // if (MusicService.apiplaylist.children.isNotEmpty) {
          //   MusicService.apiplaylist2.clear();
          //   MusicService.apiplaylist2.addAll(apiData.map((song) => AudioSource.uri(
          //     Uri.parse(song.file_data),
          //     tag: musicToMediaItem(song),
          //   )).toList());
          //   // MusicService.apiplaylist.clear();
          // } else {
          //   MusicService.apiplaylist.clear();
          //   MusicService.apiplaylist.addAll(apiData.map((song) => AudioSource.uri(
          //     Uri.parse(song.file_data),
          //     tag: musicToMediaItem(song),
          //   )).toList());
          //   // MusicService.apiplaylist2.clear();
          // }
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load songs: ${response.statusCode}');
    }

    setState(() {
      isLoading = false; // Set loading indicator to false
      isDataEmpty = true;
    });
  }

  TextEditingController titleController = TextEditingController();


  Future<void> _init() async {
    try {

    } catch (e, stackTrace) {
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }


  bool downloading = false;

  Future<void> downloadFile(String url, String filename, int index) async {
    setState(() {
      isDownloadingList[index] = true;
      downloadProgressList[index] = 0.0;
    });

    try {
      Dio dio = Dio();

      // Request permission to write to external storage
      PermissionStatus status =
          await Permission.manageExternalStorage.request();

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

  Future<void> downloadAllFiles() async {
    for (int i = 0; i < apiData.length; i++) {
      if (!isDownloadingList[i]) {
        await downloadFile(apiData[i].url, apiData[i].title, i);
      }
    }
  }

// Function to convert Music to MediaItem
  MediaItem musicToMediaItem(Music song) {
    return MediaItem(
      id: song.id,
      album: song.album,
      title: song.title,
      artist: song.artist,
      genre: song.genre_id,
      duration: null,
      // You can set the duration if available
      artUri: Uri.parse(song.image_data),
      extras: {
        'subtitle': song.subtitle,
        'singer_id': song.singer_id,
        'year': song.year,
        'album_id': song.album_id,
        'mood_id': song.mood_id,
        'language_id': song.language_id,
        'music_director_id': song.music_director_id,
        'file_data': song.file_data,
        'image_data': song.image_data,
        'status': song.status,
        'release_date': song.release_date,
        'like_flag': song.like_flag,
        'song_lyrics': song.song_lyrics,
        'url': song.url,
        'image': song.image,
      },
    );
  }

  @override
  void initState() {
    musicService.fetchAndPlaySongsByIdAndType(widget.type,widget.url);
    musicService.common(widget.url, widget.type);

     musicService.backgroudSongsPlay();

    songApi();
    super.initState();
    isDownloadingList = [];
    downloadProgressList = [];
    setState(() {});

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));

  }

  void _refresh() {
    setState(() {
      songApi();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      stretch: true,
                      expandedHeight: 280,
                      backgroundColor: Colors.black,
                      onStretchTrigger: () async {
                        log('Load new data!');
                        // await Server.requestNewData();
                      },
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Colors.orangeAccent,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          widget.title.toString(),
                        ),
                        centerTitle: false,
                        background: DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: <Color>[
                                Colors.black,
                                // Colors.teal[800]!,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          // child: Image.network(
                          //   widget.image,
                          //   fit: BoxFit.cover,
                          // ),

                          child: Image.network(
                            widget.image,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              // Return a default image widget here
                              return Container(
                                color: Colors.grey,
                                // Placeholder color
                                // You can customize the default image as needed
                                child: Icon(
                                  Icons.playlist_play,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
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
                          Container(
                            height: 170,
                            color: Colors.black,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.title.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppConstants.appName,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Image.asset(
                                                'assets/r_m_image.png')),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'liks',
                                      //   style: TextStyle(fontSize: 15),
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.download,
                                                color: Colors.white,
                                                size: 30.sp,
                                              ),
                                              onPressed: () {
                                                setState(() async {
                                                  await downloadAllFiles();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MusicService.getplayerShufflingSong(context),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.play_circle,
                                                      size: 40.sp,
                                                      color:
                                                          Colors.orangeAccent,
                                                    ),
                                                    onPressed: () async {
                                                      musicService.playSongAtIndex3(0);

                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.sp),
                        child: Text(
                          '${apiData.length} ${' Songs'}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: TextSizes.textsmallPlayer,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(8.0),
                      sliver: apiData.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ))
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final cartItem = apiData[index];
                                return GestureDetector(
                                  onTap: () async {
                                    musicService.playSongAtIndex3(index);

                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    final String? token =
                                        prefs.getString('token');
                                    prefs.remove('singleSong');

                                    final response1 = await http.post(
                                      Uri.parse(userSongs),
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization': 'Bearer $token',
                                      },
                                      body: jsonEncode({
                                        'song_id': apiData[index].id.toString(),
                                      }),
                                    );

                                    if (response1.statusCode == 200) {
                                      return json.decode(response1.body);
                                    } else {
                                      throw Exception(
                                          'Failed to load recently songs');
                                    }
                                  },
                                  child: Card(
                                    color: Colors.black,
                                    elevation: 4,
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
                                                apiData[index].image.toString(),
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
                                                Text(
                                                  apiData[index]
                                                      .title
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: TextSizes
                                                          .textsmallPlayer),
                                                ),
                                                SizedBox(height: 5.sp),
                                                Row(
                                                  children: [
                                                    Text(
                                                      apiData[index]
                                                          .album
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: TextSizes
                                                              .textsmall),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      ' / ',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: TextSizes
                                                              .textsmall),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      apiData[index]
                                                          .artist
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 8.sp),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isLiked = !isLiked;
                                                });
                                              },
                                              child: IconButton(
                                                icon: apiData[index].like_flag!
                                                    ? Icon(Icons.favorite,
                                                        color: Colors.red)
                                                    : Icon(
                                                        Icons.favorite_border),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLiked = !isLiked;
                                                    // songApi();
                                                  });
                                                  final SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  final String? token =
                                                      prefs.getString(
                                                    'token',
                                                  );
                                                  final response =
                                                      await http.post(
                                                    Uri.parse(likeSongs),
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $token',
                                                      'Content-Type':
                                                          'application/json',
                                                    },
                                                    body: jsonEncode({
                                                      'song_id':
                                                          apiData[index].id
                                                    }),
                                                  );

                                                  if (response.statusCode ==
                                                      200) {
                                                    setState(() {
                                                      isLiked = !isLiked;
                                                    });
                                                  } else {
                                                    // Handle error
                                                    print(
                                                        'Failed to like post: ${response.reasonPhrase}');
                                                  }
                                                },
                                              ),
                                            ),

                                            SizedBox(
                                              width: 40.sp,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0.0),
                                                child: isDownloadingList[index]
                                                    ? Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          CircularProgressIndicator(
                                                            value:
                                                                downloadProgressList[
                                                                    index],
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          Text(
                                                            '${(downloadProgressList[index] * 100).toStringAsFixed(0)}%',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .orange,
                                                                  fontSize:
                                                                      TextSizes
                                                                          .textsmall,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : IconButton(
                                                        icon: Icon(
                                                          Icons.download,
                                                          color: Colors.white,
                                                          size: 20.sp,
                                                        ),
                                                        onPressed: () {
                                                          if (!isDownloadingList[
                                                              index]) {
                                                            downloadFile(
                                                                apiData[index]
                                                                    .url,
                                                                apiData[index]
                                                                    .title,
                                                                index);
                                                          }
                                                        },
                                                      ),

                                                // You can handle the else case here as per your requirement
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: PopupMenuButton<int>(
                                                iconColor: Colors.white,

                                                itemBuilder: (context) => [
                                                  // PopupMenuItem 1
                                                  PopupMenuItem(
                                                    value: 1,
                                                    // row with 2 children
                                                    child: Row(
                                                      children: [
                                                        apiData[index].like_flag
                                                            ? Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red)
                                                            : Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Like",
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
                                                  // PopupMenuItem 2
                                                  PopupMenuItem(
                                                    value: 2,
                                                    // row with two children
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.download,
                                                          color: Colors.white,
                                                          size: 18.sp,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Download",
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
                                                  PopupMenuItem(
                                                    value: 3,
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
                                                  PopupMenuItem(
                                                    value: 4,
                                                    // row with two children
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.share,
                                                          color: Colors.white,
                                                          size: 18.sp,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Share",
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
                                                  PopupMenuItem(
                                                    value: 5,
                                                    // row with two children
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white,
                                                          size: 18.sp,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Play Now",
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
                                                    setState(() {
                                                      isLiked = !isLiked;
                                                      songApi();
                                                    });
                                                    final SharedPreferences
                                                        prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    final String? token =
                                                        prefs.getString(
                                                      'token',
                                                    );
                                                    final response =
                                                        await http.post(
                                                      Uri.parse(likeSongs),
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $token',
                                                        'Content-Type':
                                                            'application/json',
                                                      },
                                                      body: jsonEncode({
                                                        'song_id':
                                                            apiData[index].id
                                                      }),
                                                    );

                                                    if (response.statusCode ==
                                                        200) {
                                                      setState(() {
                                                        isLiked = !isLiked;
                                                      });
                                                    } else {
                                                      // Handle error
                                                      print(
                                                          'Failed to like post: ${response.reasonPhrase}');
                                                    }
                                                  } else if (value == 2) {
                                                    if (!isDownloadingList[
                                                        index]) {
                                                      downloadFile(
                                                          apiData[index].url,
                                                          apiData[index].title,
                                                          index);
                                                    }
                                                  } else if (value == 3) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return SongInfoScreen(
                                                            songId:
                                                                apiData[index]
                                                                    .id,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  } else if (value == 4) {
                                                    Share.share(
                                                      '${MusicService.apiData[index].title}\n${apiData[index].subtitle}\n ${apiData[index].file_data}',
                                                      subject:
                                                          musicService.title,
                                                      sharePositionOrigin:
                                                          Rect.fromCircle(
                                                        center: Offset(0, 0),
                                                        radius: 100,
                                                      ),
                                                    );
                                                  } else if (value == 5) {
                                                    musicService.playSongAtIndex3(index);

                                                    // (context as Element)
                                                    //     .findAncestorStateOfType<
                                                    //         BottomNavBarDemoState>()
                                                    //     ?.toggleMiniPlayerVisibility(
                                                    //         true);

                                                    final SharedPreferences
                                                        prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    final String? token = prefs
                                                        .getString('token');
                                                    prefs.remove('singleSong');

                                                    final response =
                                                        await http.post(
                                                      Uri.parse(userSongs),
                                                      headers: {
                                                        'Content-Type':
                                                            'application/json',
                                                        'Authorization':
                                                            'Bearer $token',
                                                      },
                                                      body: jsonEncode({
                                                        'song_id':
                                                            apiData[index]
                                                                .id
                                                                .toString(),
                                                      }),
                                                    );

                                                    if (response.statusCode ==
                                                        200) {
                                                      return json.decode(
                                                          response.body);
                                                    } else {
                                                      throw Exception(
                                                          'Failed to load recently songs');
                                                    }
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
                                );
                              },
                              childCount: apiData.length,
                            )),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                      height: 55.sp,
                    )),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 45.sp,
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedColor: Theme.of(context).cardColor,
                      closedElevation: 0.0,
                      openElevation: 4.0,
                      transitionDuration: Duration(milliseconds: 1000),
                      openBuilder: (BuildContext context, VoidCallback _) =>
                          Player(onReturn: _refresh),
                      closedBuilder:
                          (BuildContext _, VoidCallback openContainer) {
                        return MiniPlayer();
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
