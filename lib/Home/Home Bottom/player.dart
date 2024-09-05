import 'dart:async';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_saavn/SongInfo/song_info.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiModel/playModel.dart';
import '../../HexColorCode/HexColor.dart';
import '../../LikeUnlikeSong/like_unlike.dart';
import '../../Service/MusicService.dart';
import '../../Service/MusicServiceBackgroud.dart';
import '../../baseurlp/baseurl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../HomeDeatils/home_deatils_song_list.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Player extends StatefulWidget {
  final VoidCallback onReturn;

  Player({
    super.key, required this.onReturn,
  });

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  MusicService musicService = MusicService();
  final MusicServiceBackgroud _musicService = MusicServiceBackgroud();
  bool isListView = true;

  String Songid = '';

  final List<Music> playlist = [];
  SongsDeatilsListState anotherClassInstance = SongsDeatilsListState();
  TextEditingController titleController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // List<Music> playlist = []; // Populate this with your list of songs
  int currentIndex = 0;
  Timer? timer;
  bool _isRepeating = false;
  int? selectedRadioIndex;

  // bool isPlaying = false;
  double currentSliderValue = 0.0;
  bool visible = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _currentSongIndex = 0;
  bool isLiked = false;
  bool download = false;
  bool isSharePopupShown = false;
  bool isRepeat = false;
  List<Music> playlists = [];
  List<Music> songArtist = [];
  List<dynamic> songChat = [];
  List<dynamic> allplaylists = [];
  List<int> selectedIds = [];

  bool isDownloading = false;
  double downloadProgress = 0.0;
  late CancelToken cancelToken; // Add this line
  String? singleSong = '';

  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
    });
  }
  bool isLiked2 = false;

  void toggleLike() {
    setState(() {
      isLiked2 = !isLiked2;
    });
  }

  void _refresh() {
    setState(() {
    });
  }

  Future<void> songModelApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      // Adjust content type as per your API requirements
    };

    final response = await http.get(
      Uri.parse('$media${musicService.type}=${musicService.userId}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        final List<dynamic> songsJson = responseData['data']['songs'];

        setState(() {
          // Clear the list before adding new data
          playlists.clear();
          // MusicService.apiData.clear();

          // Parse each song from JSON and add it to the list
          for (var songJson in songsJson) {
            final song = Music(
              title: songJson['title'],
              artist: songJson['singer_name'],
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

            playlists.add(song);
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(userPlaylist),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('playlists')) {
        setState(() {
          allplaylists = responseData['playlists'];
          // filteredList=playlists;
          print(allplaylists);
        });
      } else {
        throw Exception('Invalid API response: Missing "playlist" key');
      }
    } else {
      throw Exception('Failed to load playlists: ${response.statusCode}');
    }
  }

  Future<void> hitAddPlaylists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String playlistName = titleController.text;

    final response = await http.post(
      Uri.parse(userAddplaylist),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': playlistName,
        // 'photo': musicService.imageUrl.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {
        final int id = responseData['playlist']['id'];

        hitAddOneSong(id);
      });

      Fluttertoast.showToast(
        msg:
            " Playlist ${"${playlistName}."} ${'created and 1 song added to it'}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitAddSong(String songId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(addsong),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'song_id': songId,
        'playlist_id': allplaylists[selectedRadioIndex!]['id'],
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg:
            "1 song added to playlist ${"${allplaylists[selectedRadioIndex!]['playlist_name']}."}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitAddOneSong(int playlistId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(addsong),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'song_id': musicService.id,
        'playlist_id': playlistId,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "1 song added to playlist ${"${''}."}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> songArtistApi() async {
    final response = await http
        .get(Uri.parse('$media${'artist_id'}=${musicService.singer_id}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        final List<dynamic> songsJson = responseData['data']['songs'];

        setState(() {
          // Clear the list before adding new data
          songArtist.clear();
          MusicService.apiData.clear();

          // Parse each song from JSON and add it to the list
          for (var songJson in songsJson) {
            final song = Music(
              title: songJson['title'],
              artist: songJson['title'],
              album: songJson['album'],
              imagealbum: songJson['album']['image_data'],
              url: songJson['file_data'],
              song_lyrics: songJson['song_lyrics'],
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

              // Parse other properties as needed
            );

            MusicService.apiData.add(song);
            songArtist.add(song);
          }
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }

  Future<void> downloadFile(String url, String filename) async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
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
                downloadProgress = received / total;
              });
            }
          },
        );

        setState(() {
          downloadProgress = 1.0; // Ensure 100% completion
          isDownloading = false;
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
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    miniPlayer();
    cancelToken = CancelToken(); // Initialize cancelToken
    // songModelApi();
    hitPlaylists();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => hitPlaylists());
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => songModelApi());

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  @override
  void dispose() {
    timer?.cancel();
    _musicService.dispose();

    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inMinutes}:${twoDigitSeconds}';
  }

  Future<void> miniPlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      singleSong = prefs.getString('singleSong');
    });
  }

  final double _initFabHeight = 80.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 60.0;

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .45;
    final textTheme = Theme.of(context).textTheme;
    final cardSize = MediaQuery.of(context).size.height * 0.2;
    // final cardSize2 = MediaQuery.of(context).size.width * 0.4;

    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          // physics: ScrollPhysics(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0B1220).withOpacity(0.0),
                      Color(0xFF0B1220).withOpacity(0.9)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  height: MediaQuery.of(context).padding.top),
                              // Header
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      // onPressed: () => widget.onTap(),
                                      iconSize: 25.sp,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "PLAYING NOW",
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.bodyText1!
                                                .apply(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),

                                    StreamBuilder<SequenceState?>(
                                      stream: musicService
                                          .player.sequenceStateStream,
                                      builder: (context, snapshot) {
                                        final state = snapshot.data;
                                        if (state?.sequence.isEmpty ?? true) {
                                          return const SizedBox();
                                        }
                                        final metadata = state!
                                            .currentSource!.tag as MediaItem;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0.0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.share,
                                              size: 22.sp,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // String title =
                                              //     musicService.title;
                                              // String subtitle =
                                              //     musicService.title;
                                              // String url =
                                              //     musicService.url;

                                              Share.share(
                                                '${metadata.title.toString()}\n${metadata.album.toString()}\n ${metadata.extras!['file_data'].toString()}',
                                                subject: musicService.title,

                                                sharePositionOrigin:
                                                    Rect.fromCircle(
                                                  center: Offset(0, 0),
                                                  radius: 100,
                                                ),
                                                // shareRect: Rect.fromCircle(
                                                //   center: Offset(0, 0),
                                                //   radius: 100,
                                                // ),
                                                // imageUrl: 'file:///$imagePath',
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    StreamBuilder<SequenceState?>(
                                      stream: musicService
                                          .player.sequenceStateStream,
                                      builder: (context, snapshot) {
                                        final state = snapshot.data;
                                        if (state?.sequence.isEmpty ?? true) {
                                          return const SizedBox();
                                        }
                                        final metadata = state!
                                            .currentSource!.tag as MediaItem;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.info,
                                              size: 24.sp,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongInfoScreen(
                                                      songId: metadata.id
                                                          .toString(),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),

                                    // IconButton(
                                    //   icon: Icon(isListView ? Icons.playlist_play : Icons.image),
                                    //   onPressed: () {
                                    //     setState(() {
                                    //       isListView = !isListView;
                                    //     });
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: StreamBuilder<SequenceState?>(
                                  stream:
                                      musicService.player.sequenceStateStream,
                                  builder: (context, snapshot) {
                                    final state = snapshot.data;
                                    if (state?.sequence.isEmpty ?? true) {
                                      return const SizedBox();
                                    }
                                    final metadata =
                                        state!.currentSource!.tag as MediaItem;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              height: 150.sp,
                                              // width: cardSize,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                // Adjust the value as needed
                                                child: CachedNetworkImage(
                                                  height: 150.sp,
                                                  // width: cardSize,
                                                  imageUrl: metadata.artUri
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  // Adjust this according to your requirement
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color:
                                                          Colors.orangeAccent,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/r_m_image.png',
                                                    // Path to your default image asset
                                                    height: 150.sp,
                                                    // width: cardSize,// Adjust width as per your requirement
                                                    fit: BoxFit
                                                        .cover, // Adjust this according to your requirement
                                                  ),
                                                ),
                                              )

                                              // child:
                                              //     Image.network(MusicService().getImageUrl(),
                                              // ),
                                              ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              Container(
                                height: 50.sp,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [

                                                    StreamBuilder<SequenceState?>(
                                                      stream: musicService
                                                          .player
                                                          .sequenceStateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        final state =
                                                            snapshot.data;
                                                        if (state?.sequence
                                                            .isEmpty ??
                                                            true) {
                                                          return const SizedBox();
                                                        }
                                                        final metadata = state!
                                                            .currentSource!
                                                            .tag as MediaItem;
                                                        return Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 8.0),
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              size: 25.sp,
                                                              color:
                                                              Colors.white,
                                                            ),
                                                            onPressed: () {

                                                              showModalBottomSheet(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return StatefulBuilder(builder:
                                                                      (BuildContext context,
                                                                      StateSetter
                                                                      setState /*You can rename this!*/) {
                                                                    return AddPlaylist(
                                                                      songId:metadata.id.toString(),
                                                                    );
                                                                  });
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    StreamBuilder<SequenceState?>(
                                                      stream: musicService
                                                          .player
                                                          .sequenceStateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        final state =
                                                            snapshot.data;
                                                        if (state?.sequence
                                                            .isEmpty ??
                                                            true) {
                                                          return const SizedBox();
                                                        }
                                                        final metadata = state!
                                                            .currentSource!
                                                            .tag as MediaItem;
                                                        return Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 8.0),
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.lyrics_outlined,
                                                              size: 25.sp,
                                                              color:
                                                              Colors.white,
                                                            ),
                                                            onPressed: () {

                                                              if(metadata.extras!['song_lyrics']!=null){
                                                                showModalBottomSheet(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return StatefulBuilder(builder:
                                                                        (BuildContext context,
                                                                        StateSetter
                                                                        setState /*You can rename this!*/) {
                                                                      return LyricsSongs(lyrics:metadata.extras!['song_lyrics'].toString(), );
                                                                    });
                                                                  },
                                                                );
                                                              }else{

                                                              }

                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),

                                                    StreamBuilder<SequenceState?>(
                                                      stream: musicService
                                                          .player
                                                          .sequenceStateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        final state =
                                                            snapshot.data;
                                                        if (state?.sequence
                                                                .isEmpty ??
                                                            true) {
                                                          return const SizedBox();
                                                        }
                                                        final metadata = state!
                                                            .currentSource!
                                                            .tag as MediaItem;
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: GestureDetector(
                                                            onTap: (){
                                                              showModalBottomSheet(
                                                                context:
                                                                context,
                                                                builder:
                                                                    (BuildContext
                                                                context) {
                                                                  return StatefulBuilder(builder: (BuildContext
                                                                  context,
                                                                      StateSetter
                                                                      setState /*You can rename this!*/) {
                                                                    return CommentBottomSheet(
                                                                      id: metadata
                                                                          .id
                                                                          .toString(),
                                                                    );
                                                                  });
                                                                },
                                                              );
                                                            },
                                                            child: SizedBox(
                                                              height: 20.sp,
                                                                width: 20.sp,
                                                                child: Image.asset('assets/chat.png')),
                                                          ),



                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      // onPressed: () => widget.onTap(),
                                                      iconSize: 25.sp,
                                                      icon: Icon(
                                                        Icons.playlist_play,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return StatefulBuilder(builder:
                                                                (BuildContext context,
                                                                StateSetter
                                                                setState /*You can rename this!*/) {
                                                              return PlaylistSongs();
                                                            });
                                                          },
                                                        );
                                                      },
                                                    ),

                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [

                                                    StreamBuilder<SequenceState?>(
                                                      stream: musicService
                                                          .player
                                                          .sequenceStateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        final state =
                                                            snapshot.data;
                                                        if (state?.sequence
                                                            .isEmpty ??
                                                            true) {
                                                          return const SizedBox();
                                                        }
                                                        final metadata = state!
                                                            .currentSource!
                                                            .tag as MediaItem;
                                                        return   Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                          child: isDownloading
                                                              ? Stack(
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            children: [
                                                              CircularProgressIndicator(
                                                                value:
                                                                downloadProgress,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              if (isDownloading)
                                                                Text(
                                                                  '${(downloadProgress * 100).toStringAsFixed(0)}%',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: TextSizes
                                                                            .textsmall,
                                                                        fontWeight: FontWeight
                                                                            .normal,
                                                                        overflow:
                                                                        TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                            ],
                                                          )
                                                              : IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .download_for_offline,
                                                              color: Colors
                                                                  .white,
                                                              size: 25.sp,
                                                            ),
                                                            onPressed: () {
                                                              downloadFile(
                                                                  '${metadata.extras!['file_data']}',
                                                                  metadata
                                                                      .title
                                                                      .toString());
                                                            },
                                                          ),
                                                        );

                                                          },
                                                    ),





                                                    StreamBuilder<SequenceState?>(
                                                      stream: musicService.player.sequenceStateStream,
                                                      builder: (context, snapshot) {
                                                        final state = snapshot.data;
                                                        if (state?.sequence.isEmpty ?? true) {
                                                          return const SizedBox();
                                                        }
                                                        final metadata = state!.currentSource!.tag as MediaItem;
                                                        // bool isLiked = metadata.extras!['like_flag'] ?? false;

                                                        return  IconButton(
                                                          icon:metadata.extras!['like_flag']
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
                                                                metadata.id.toString()
                                                              }),
                                                            );

                                                            if (response.statusCode ==
                                                                200) {
                                                              widget.onReturn();
                                                              setState(() {
                                                                isLiked = !isLiked;
                                                              });
                                                            } else {
                                                              // Handle error
                                                              print(
                                                                  'Failed to like post: ${response.reasonPhrase}');
                                                            }
                                                          },
                                                        );

                                                      },
                                                    ),



                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15.sp,
                                          ),
                                          StreamBuilder<SequenceState?>(
                                            stream: musicService
                                                .player.sequenceStateStream,
                                            builder: (context, snapshot) {
                                              final state = snapshot.data;
                                              if (state?.sequence.isEmpty ??
                                                  true) {
                                                return const SizedBox();
                                              }
                                              final metadata = state!
                                                  .currentSource!
                                                  .tag as MediaItem;
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //     builder: (context) {
                                                          //       return SongInfoScreen(
                                                          //         songId: MusicService()
                                                          //             .id
                                                          //             .toString(),
                                                          //       );
                                                          //     },
                                                          //   ),
                                                          // );
                                                        },
                                                        child: Text(
                                                          metadata.title!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.sp),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        // Text(
                                                        //   MusicService().title,
                                                        //   maxLines: 1,
                                                        //   softWrap: true,
                                                        //   overflow: TextOverflow.ellipsis,
                                                        //   style: textTheme.headline5!.apply(
                                                        //     color: Colors.white,
                                                        //   ),
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.sp,
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return SongsDeatilsList(
                                                                  url: metadata
                                                                      .extras![
                                                                          'album_id']
                                                                      .toString(),
                                                                  image: metadata
                                                                      .artUri
                                                                      .toString(),
                                                                  title: metadata
                                                                      .album
                                                                      .toString(),
                                                                  type:
                                                                      'album_id',
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          '${metadata.album.toString()} ',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: TextSizes
                                                                  .textmedium),
                                                        ),
                                                      ),
                                                      Text(
                                                        ' / ',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .apply(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return SongsDeatilsList(
                                                                  url: metadata
                                                                      .extras![
                                                                          'singer_id']
                                                                      .toString(),
                                                                  image: metadata
                                                                      .artUri
                                                                      .toString(),
                                                                  title: metadata
                                                                      .artist
                                                                      .toString(),
                                                                  type:
                                                                      'artist_id',
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          '${metadata.artist.toString()} ',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: TextSizes
                                                                  .textmedium),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 15.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          MusicService.getplayerSlider(context),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MusicService.getplayerRepeatSong(context),
                                MusicService.getVolumeButton(context),
                                musicService
                                    .getplayerButtonPreviousNext(context),

                                Container(
                                  height: 60.sp,
                                  child:
                                      MusicService.getPalyPauseButton(context),
                                ),
                                // PlayButton(player: _musicService.player),

                                musicService.getplayerButtonNext(context),
                                MusicService.getPlayerSpeed(context),
                                MusicService.getplayerShufflingSong(context),
                                Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50.sp,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return StreamBuilder<SequenceState?>(
      stream: musicService.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  height: 150.sp,
                  // width: cardSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    // Adjust the value as needed
                    child: CachedNetworkImage(
                      height: 150.sp,
                      // width: cardSize,
                      imageUrl: metadata.artUri.toString(),
                      fit: BoxFit.cover,
                      // Adjust this according to your requirement
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/r_m_image.png',
                        // Path to your default image asset
                        height: 150.sp,
                        // width: cardSize,// Adjust width as per your requirement
                        fit: BoxFit
                            .cover, // Adjust this according to your requirement
                      ),
                    ),
                  )

                  // child:
                  //     Image.network(MusicService().getImageUrl(),
                  // ),
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget buildGridView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
      ),

      // child: StreamBuilder<SequenceState?>(
      //   stream: musicService.player.sequenceStateStream,
      //   builder: (context, snapshot) {
      //     final state = snapshot.data;
      //     final sequence = state?.sequence ?? [];
      //     return ListView.builder(
      //       itemCount: sequence.length,
      //       itemBuilder: (context, i) {
      //         return Dismissible(
      //           key: ValueKey(sequence[i]),
      //           background: Container(
      //             color: Colors.redAccent,
      //             alignment: Alignment.centerRight,
      //             child: const Padding(
      //               padding: EdgeInsets.only(right: 8.0),
      //               child: Icon(Icons.delete, color: Colors.white),
      //             ),
      //           ),
      //           onDismissed: (dismissDirection) {
      //             // _musicService.playlist.removeAt(i);
      //           },
      //           child: Material(
      //             color: i == state!.currentIndex
      //                 ? Colors.grey.shade300
      //                 : Colors.black,
      //             child: Card(
      //               elevation: 5,
      //               child: ListTile(
      //                 title: Text(
      //                   sequence[i].tag.title as String,
      //                   style: TextStyle(color: Colors.white),
      //                 ),
      //                 onTap: () {
      //                   _musicService.player.seek(Duration.zero, index: i);
      //                 },
      //               ),
      //             )
      //
      //
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}

class CommentBottomSheet extends StatefulWidget {
  final String id;

  CommentBottomSheet({
    required this.id,
  });

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> songChat = [];
  Timer? timer;

  String userid = '';

  Future<void> chatSongApi() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );

    final Uri uri = Uri.parse('${comment}${'song_id'}=${widget.id}');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('comments')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          songChat = responseData['comments'];
          print(songChat);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<void> commentEditGetApi(String commentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );
    final Uri uri = Uri.parse('${editComment} ${commentId}');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      setState(() {
        messageController.text = jsonData['comments']['comment'];
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  void updateCommentApi(String id, String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${updateComment}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id': id, 'comment': message}),
    );

    if (response.statusCode == 200) {
      _refreshComments();

      Navigator.of(context).pop();

      print('Message sent successfully!');
    } else {
      // Handle error
      print('Failed to send message: ${response.reasonPhrase}');
    }
  }

  void sendMessage(String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${userComment}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'song_id': widget.id, 'comment': message}),
    );

    if (response.statusCode == 201) {
      _refreshComments();
      // Navigator.of(context).pop();
      print('Message sent successfully!');
    } else {
      // Handle error
      print('Failed to send message: ${response.reasonPhrase}');
    }
  }

  Future<void> userId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid').toString();
  }

  @override
  void initState() {
    super.initState();
    chatSongApi();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>    chatSongApi());

    userId();
    messageController = TextEditingController();
  }

  Future<void> _refreshComments() async {
    await Future.delayed(Duration(seconds: 2));
    await chatSongApi();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Colors.purple,
              // Colors.black,
              HexColor('#a8edea'),
              HexColor('#fed6e3')
            ],

            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.sp),
            topRight: Radius.circular(20.sp),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.comment,
                          size: 18,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Handle comment button press
                        },
                      ),
                      Text(
                        'Comments',
                        style: TextStyle(fontSize: 13.sp, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshComments,
                child: ListView.builder(
                  itemCount: songChat.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (songChat.isEmpty) {
                      return Center(
                        child: Text(
                          'Data not found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(left: 15.sp),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.sp),
                          child: GestureDetector(
                            onLongPress: () {},
                            child: Column(
                              children: [
                                // Divider(
                                //   height: 1.sp,
                                //   color: Colors.orange,
                                // ),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        songChat[index]['user']['image_data']
                                            .toString(),
                                        fit: BoxFit.cover,
                                        width: 30,
                                        height: 30,
                                        errorBuilder:
                                            (context, object, stackTrace) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            // Half of width/height for perfect circle
                                            child: Image.network(
                                              'https://w7.pngwing.com/pngs/178/595/png-transparent-user-profile-computer-icons-login-user-avatars-thumbnail.png',
                                              fit: BoxFit.cover,
                                              width: 30,
                                              height: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.sp),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (songChat[index]['user']['name'] ==
                                              null)
                                            Text(
                                              'Unknow',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          if (songChat[index]['user']['name'] !=
                                              null)
                                            Text(
                                              songChat[index]['user']['name']
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2.sp),
                                                child: SizedBox(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child:
                                                            Text.rich(TextSpan(
                                                          text: songChat[index]
                                                                  ['comment']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.purple,
                                                              fontSize: 10.sp),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  '${'  '}${songChat[index]['time_ago'].toString()}${' ago'}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      8.sp),
                                                            ),
                                                          ],
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    if (userid ==
                                        songChat[index]['user_id'].toString())
                                      Column(
                                        children: [
                                          Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return Container(
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.pink
                                                                  .shade100,
                                                              // Colors.purple.shade200,
                                                              HexColor(
                                                                  '#a58ac1')
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.sp)),
                                                      child: Wrap(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0),
                                                            child: ListTile(
                                                              leading: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              title: Text(
                                                                'Edit',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                commentEditGetApi(
                                                                    songChat[index]
                                                                            [
                                                                            'id']
                                                                        .toString());
                                                                showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          bc) {
                                                                    return Container(
                                                                      height:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            colors: [
                                                                              Colors.pink.shade100,
                                                                              // Colors.purple.shade200,
                                                                              HexColor('#a58ac1')
                                                                            ],
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(20.sp)),
                                                                      child:
                                                                          Wrap(
                                                                        children: <Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 0.0),
                                                                            child:
                                                                                ListTile(
                                                                              leading: Icon(Icons.comment),
                                                                              title: Text(
                                                                                'Edit Comment',
                                                                                style: TextStyle(fontSize: 12.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                            child:
                                                                                Card(
                                                                              elevation: 5,
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: TextFormField(
                                                                                        controller: messageController,
                                                                                        decoration: InputDecoration(
                                                                                          hintText: 'Type your message...',
                                                                                          border: InputBorder.none,
                                                                                        ),
                                                                                        style: TextStyle(color: Colors.black),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  IconButton(
                                                                                    icon: Icon(Icons.send),
                                                                                    onPressed: () async {
                                                                                      final message = messageController.text;
                                                                                      if (message.isNotEmpty) {
                                                                                        setState(() {
                                                                                          messageController.clear();
                                                                                        });
                                                                                        updateCommentApi(songChat[index]['id'].toString(), message);
                                                                                        // Scroll to bottom after sending a message
                                                                                        _scrollController.animateTo(
                                                                                          _scrollController.position.maxScrollExtent,
                                                                                          duration: Duration(milliseconds: 300),
                                                                                          curve: Curves.easeOut,
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            title: Text(
                                                              'Remove',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onTap: () async {
                                                              final SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              final String?
                                                                  token =
                                                                  prefs.getString(
                                                                      'token');

                                                              final response =
                                                                  await http
                                                                      .get(
                                                                Uri.parse(
                                                                    '${deleteComment}${songChat[index]['id'].toString()}'),
                                                                headers: {
                                                                  'Authorization':
                                                                      'Bearer $token',
                                                                  'Content-Type':
                                                                      'application/json',
                                                                },
                                                                // body: jsonEncode({}),
                                                              );

                                                              if (response
                                                                      .statusCode ==
                                                                  201) {
                                                                _refreshComments();

                                                                print(
                                                                    'Message sent successfully!');
                                                              } else {
                                                                // Handle error
                                                                print(
                                                                    'Failed to send message: ${response.reasonPhrase}');
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the bottom sheet
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.sp),
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                                // Divider(
                                //   height: 1.sp,
                                //   color: Colors.orange,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Card(
                elevation: 5,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        final message = messageController.text;
                        if (message.isNotEmpty) {
                          setState(() {
                            messageController.clear();
                          });
                          sendMessage(message);
                          // Scroll to bottom after sending a message
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistSongs extends StatefulWidget {
  PlaylistSongs({
    super.key,
  });

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  MusicService musicService = MusicService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:Container(
        child: StreamBuilder<SequenceState?>(
          stream: musicService.player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.black,
                          // HexColor('#a8edea'),
                          // HexColor('#fed6e3'),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.sp),
                        topRight: Radius.circular(20.sp),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.sp),
                      child: ListView.builder(
                        itemCount: sequence.length,
                        itemBuilder: (context, i) {
                          if (sequence.isEmpty) {
                            return const SizedBox();
                          }

                          final isCurrentSong = state?.currentIndex == i;

                          return GestureDetector(
                            onTap: () async {
                              musicService.player.seek(Duration.zero, index: i);

                              final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              final String? token = prefs.getString('token');
                              prefs.remove('singleSong');

                              final response1 = await http.post(
                                Uri.parse(userSongs),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer $token',
                                },
                                body: jsonEncode({
                                  'song_id': sequence[i].tag.id as String,
                                }),
                              );

                              if (response1.statusCode == 200) {
                                return json.decode(response1.body);
                              } else {
                                throw Exception('Failed to load recently songs');
                              }
                            },
                            child: Card(
                              color:isCurrentSong? Colors.lightBlueAccent: Colors.black,
                              elevation: 4,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                      width: 50.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child:
                                        Image.network(
                                          sequence[i].tag.artUri?.toString() ?? '',
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 50.0,
                                              height: 50.0,
                                              color: Colors.grey,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            sequence[i].tag.title as String,
                                            style: TextStyle(
                                              color: isCurrentSong? Colors.black: Colors.white,
                                              fontSize: TextSizes.textsmallPlayer,
                                            ),
                                          ),
                                          SizedBox(height: 5.sp),
                                          Row(
                                            children: [
                                              Text(
                                                sequence[i].tag.album as String,
                                                style: TextStyle(
                                                  color: isCurrentSong? Colors.black: Colors.grey,
                                                  fontSize: TextSizes.textsmall,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                ' / ',
                                                style: TextStyle(
                                                  color: isCurrentSong? Colors.black: Colors.grey,
                                                  fontSize: TextSizes.textsmall,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                sequence[i].tag.artist as String,
                                                style: TextStyle(
                                                  color: isCurrentSong? Colors.black: Colors.grey,
                                                  fontSize: 8.sp,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      isCurrentSong? IconButton(
                                        icon: const Icon(
                                          Icons.bar_chart_rounded,color: Colors.black,
                                        ),
                                        onPressed: () {},
                                      ): Padding(
                                        padding: const EdgeInsets.only(right: 0.0),
                                        child: PopupMenuButton<int>(
                                          iconColor: isCurrentSong? Colors.black: Colors.white,
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    size: 18.sp,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Song Info",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: TextSizes.textsmallPlayer,
                                                        fontWeight: FontWeight.normal,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    size: 18.sp,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Share",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: TextSizes.textsmallPlayer,
                                                        fontWeight: FontWeight.normal,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 3,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Play Now",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: TextSizes.textsmallPlayer,
                                                        fontWeight: FontWeight.normal,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          offset: Offset(0, 100),
                                          color: Colors.black,
                                          elevation: 2,
                                          onSelected: (value) async {
                                            if (value == 1) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongInfoScreen(
                                                      songId: sequence[i].tag.id as String,
                                                    );
                                                  },
                                                ),
                                              );
                                            } else if (value == 2) {
                                              Share.share(
                                                '${sequence[i].tag.title as String}\n${sequence[i].tag.album.toString()}\n ${sequence[i].tag.extras!['file_data'].toString()}',
                                                subject: musicService.title,
                                                sharePositionOrigin: Rect.fromCircle(
                                                  center: Offset(0, 0),
                                                  radius: 100,
                                                ),
                                              );
                                            } else if (value == 3) {
                                              musicService.player.seek(Duration.zero, index: i);

                                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                                              final String? token = prefs.getString('token');
                                              prefs.remove('singleSong');

                                              final response = await http.post(
                                                Uri.parse(userSongs),
                                                headers: {
                                                  'Content-Type': 'application/json',
                                                  'Authorization': 'Bearer $token',
                                                },
                                                body: jsonEncode({
                                                  'song_id': sequence[i].tag.id as String,
                                                }),
                                              );

                                              if (response.statusCode == 200) {
                                                return json.decode(response.body);
                                              } else {
                                                throw Exception('Failed to load recently songs');
                                              }
                                            }
                                          },
                                        ),
                                      ),





                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

    );
  }
}


class LyricsSongs extends StatefulWidget {
 final String lyrics;
  LyricsSongs({
    super.key, required this.lyrics,
  });

  @override
  _LyricsSongsState createState() => _LyricsSongsState();
}

class _LyricsSongsState extends State<LyricsSongs> {
  MusicService musicService = MusicService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(20.sp),
          child: Center(
            child:widget.lyrics.isNotEmpty ? Text(widget.lyrics,style: TextStyle(color: Colors.black),): Center(
              child: Text('lyrics not found',style: TextStyle(color: Colors.black),
                        ),
            ),
        ),
      )

    ));
  }
}


class AddPlaylist extends StatefulWidget {
 final String songId;
  AddPlaylist({
    super.key, required this.songId,


  });

  @override
  _AddPlaylistState createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  MusicService musicService = MusicService();
  TextEditingController titleController = TextEditingController();
  List<dynamic> allplaylists = [];
  int? selectedRadioIndex;

  @override
  void initState() {
    super.initState();
    hitPlaylists();
  }

  Future<void> hitAddPlaylists(String songId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String playlistName = titleController.text;

    final response = await http.post(
      Uri.parse(userAddplaylist),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': playlistName,
        // 'photo': musicService.imageUrl.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // setState(() {
        final int id = responseData['playlist']['id'];

        hitAddOneSong(id,songId);
      // });

      Fluttertoast.showToast(
        msg:
        " Playlist ${"${playlistName}."} ${'created and 1 song added to it'}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitAddOneSong(int playlistId,String songId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(addsong),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'song_id': songId,
        'playlist_id': playlistId,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "1 song added to playlist ${"${''}."}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitAddSong(String songId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(addsong),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'song_id': songId,
        'playlist_id': allplaylists[selectedRadioIndex!]['id'],
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg:
        "1 song added to playlist ${"${allplaylists[selectedRadioIndex!]['playlist_name']}."}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recently songs');
    }
  }

  Future<void> hitPlaylists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(userPlaylist),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('playlists')) {
        setState(() {
          allplaylists = responseData['playlists'];
          // filteredList=playlists;
          print(allplaylists);
        });
      } else {
        throw Exception('Invalid API response: Missing "playlist" key');
      }
    } else {
      throw Exception('Failed to load playlists: ${response.statusCode}');
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:Container(
        color: Colors
            .black87,
        padding:
        EdgeInsets.all(
            16.0),
        child:
        Column(
          mainAxisSize:
          MainAxisSize
              .min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 10.sp,
                  bottom: 25.sp),
              child:
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add To Playlist',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${allplaylists.length} ${' Playlists'}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white, fontSize: TextSizes.textsmallPlayer, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5.sp)),
                        child: Padding(
                          padding: EdgeInsets.all(3.sp),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 15.sp,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(bottom: 20.sp),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        color: Colors.black87,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.sp, bottom: 25.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Create New Playlist',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5.sp)),
                                        child: Padding(
                                          padding: EdgeInsets.all(3.sp),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 15.sp,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.sp),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Add Name',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                hitAddPlaylists(widget.songId.toString());
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 40.sp,
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.sp), color: Colors.white),
                                  child: Center(
                                      child: Text(
                                        'Create',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(color: Colors.black, fontSize: TextSizes.textmedium, fontWeight: FontWeight.normal),
                                        ),
                                      ))),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child:
                Row(
                  children: [
                    Container(
                        height: 50.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.sp)),
                        child: Icon(
                          Icons.playlist_add,
                          color: Colors.black,
                          size: 25.sp,
                        )),
                    SizedBox(width: 10),
                    Text(
                      'Create a new playlist',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height:
              1.sp,
              color:
              Colors.white24,
            ),
            Expanded(
              child:
              Padding(
                padding:
                EdgeInsets.only(top: 0.sp),
                child:
                ListView.builder(
                  itemCount: allplaylists.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 50.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                allplaylists[index]['image_data'].toString(),
                                // playlist[index].image.toString(),
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Return a default image widget here
                                  return Container(
                                    width: 50.0,
                                    height: 50.0,
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
                          ),
                        ),
                        title: Text(
                          allplaylists[index]['playlist_name']!,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        subtitle: Text(
                          '${allplaylists[index]['songs'].length.toString()} ${'songs'}',
                          style: TextStyle(color: Colors.grey, fontSize: TextSizes.textsmall),
                        ),
                        trailing: Radio<int>(
                          activeColor: Colors.orange,
                          value: index,
                          groupValue: selectedRadioIndex,
                          onChanged: (int? newvalue) {
                            setState(() {
                              selectedRadioIndex = newvalue;
                              print("Selected Song ID: ${allplaylists[selectedRadioIndex!]['id']}");
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            StreamBuilder<SequenceState?>(
              stream: musicService
                  .player
                  .sequenceStateStream,
              builder:
                  (context, snapshot) {
                final state =
                    snapshot.data;
                if (state?.sequence
                    .isEmpty ??
                    true) {
                  return const SizedBox();
                }
                final metadata = state!
                    .currentSource!
                    .tag as MediaItem;
                return  GestureDetector(
                  onTap:
                      () async {
                    hitAddSong(metadata
                        .id
                        .toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 40.sp,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.sp), color: Colors.white),
                      child: Center(
                          child: Text(
                            'Add',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.black, fontSize: TextSizes.textlarge, fontWeight: FontWeight.normal),
                            ),
                          ))),
                );




              },
            ),

          ],
        ),
      ),

    );
  }
}
class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  MusicService musicService = MusicService();
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: musicService.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        bool isLiked = metadata.extras!['like_flag'] ?? false;

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 30,
            ),
            color: isLiked ? Colors.red : Colors.grey,
            onPressed: () async {
              setState(() {
                _isLiked = !isLiked;
              });

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              final String? token = prefs.getString('token');
              final response = await http.post(
                Uri.parse(likeSongs),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  'song_id': metadata.id.toString(),
                  'like_flag': _isLiked,
                }),
              );

              if (response.statusCode == 200) {
                setState(() {
                  metadata.extras!['like_flag'] = _isLiked;
                });
              } else {
                // Handle error
                print('Failed to like post: ${response.reasonPhrase}');
                setState(() {
                  _isLiked = !isLiked; // Revert the like status if the request failed
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update like status')),
                );
              }
            },
          ),
        );
      },
    );
  }
}



// class LikeButton extends StatefulWidget {
//   @override
//   _LikeButtonState createState() => _LikeButtonState();
// }
//
// class _LikeButtonState extends State<LikeButton> {
//   MusicService musicService = MusicService();
//
//   late bool _isLiked;
//
//   Future<void> toggleLike(String songId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
//
//     final response = await http.post(
//       Uri.parse(likeSongs), // Replace with your API URL
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'song_id': songId,
//         'like_flag': !_isLiked,
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       setState(() {
//         _isLiked = !_isLiked;
//       });
//     } else {
//       // Handle error
//       print('Failed to like post: ${response.reasonPhrase}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update like status')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<SequenceState?>(
//       stream: musicService.player.sequenceStateStream,
//       builder: (context, snapshot) {
//         final state = snapshot.data;
//         if (state?.sequence.isEmpty ?? true) {
//           return const SizedBox();
//         }
//         final metadata = state!.currentSource!.tag as MediaItem;
//         _isLiked = metadata.extras!['like_flag'] ?? false;
//
//         return Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: IconButton(
//             icon: Icon(
//               _isLiked ? Icons.favorite : Icons.favorite_border,
//               size: 30,
//             ),
//             color: _isLiked ? Colors.red : Colors.grey,
//             onPressed: () {
//               toggleLike(metadata.id.toString());
//             },
//           ),
//         );
//       },
//     );
//   }
// }
