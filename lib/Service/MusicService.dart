import 'dart:async';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_saavn/Model/trending.dart';
import 'package:music_player_saavn/baseurlp/baseurl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ApiModel/playModel.dart';
import '../ApiModel/recntlySongs.dart';
import '../ApiModel/treading_model.dart';
import '../CircularSeekBar/circularSeekBar.dart';
import '../Exp/notifiers/play_button_notifier.dart';
import '../Utils/common.dart';
import '../constants/firestore_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
enum RepeatMode {
  none,
  all,
  one,
}


class MusicService  extends BaseAudioHandler with BackgroundAudioTask {
  static AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<bool> _loadingController = StreamController<bool>.broadcast();
  bool _isLoading = false;
  bool isShuffling = false;
  static bool repeatSong = false;
  static bool isEnabled = false;
  static RepeatMode repeatMode = RepeatMode.none;

  RepeatMode get repeatModes => repeatMode;

  AudioPlayer get player => _audioPlayer;
  static final ConcatenatingAudioSource apiplaylist3 = ConcatenatingAudioSource(children: []);
  static final ConcatenatingAudioSource apiplaylist = ConcatenatingAudioSource(children: []);

  AudioSource get currentSong => apiplaylist3[_currentIndex];

  bool isLastIndex = _currentIndex == apiplaylist3.length - 1;

  // static playCurrentSong() async {
  //   Music currentSong = apiplaylist[_currentIndex] as Music;
  //   playModel(currentSong);
  // }

  Stream<bool> getLoadingStream() {
    return _loadingController.stream;
  }

  Stream<bool>? getBufferingStream() {
    return null;
  }

  static void _audioPlayerTaskEntrypoint() {
    AudioServiceBackground.run(() => MusicService());
  }

  static List<Music> apiData = [];
  List<AudioSource> newPlaylist = [];

  static List<RecntlySong> apiData2 = [];
  static int _currentIndex = 0;

  static String _imageUrl = '';
  static String _imagealbum = '';
  static String _title = '';
  static String _song_lyrics = '';
  static String _album = '';
  static String _id = '';
  static String _subtitle = '';
  static String _url = '';
  static String _singer_id = '';
  static String _album_id = '';
  static String _type = '';
  static String _userId = '';
  static String _year = '';
  static String _artist = '';
  static String _release_date = '';
  static bool? _like;


  Future<void> backgroudSongsPlay() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  String get title => _title;

  String get song_lyrics => _song_lyrics;

  String get album => _album;

  String get id => _id;

  String get subtitle => _subtitle;

  String get url => _url;

  String get singer_id => _singer_id;

  String get album_id => _album_id;

  String get imageUrl => _imageUrl;

  String get imagealbum => _imagealbum;

  String get type => _type;

  String get userId => _userId;

  String get year => _year;

  String get artist => _artist;

  String get release_date => _release_date;

  bool? get like => _like;

  MusicService() {




  }

  // Get the playback state stream
  Stream<bool> getPlaybackStateStream() {
    return _audioPlayer.playingStream;
  }

  Future<void> common(String userId, String type,) async {
    try {
      _type = type;
      _userId = userId;
    } catch (e) {
      print('Error playing song: $e');
    }
  }


  Future<void> playSong(String id, String url, String imageUrl, String title, String subtitle,) async {
    try {
      _isLoading = true;
      _loadingController.add(_isLoading);
      _title = title;
      _id = id;
      _url = url;
      // _song_lyrics = song_lyrics!;
      _subtitle = subtitle;
      _imageUrl = imageUrl;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }


  static Future<void> playModel(Music music,) async {
    // Your existing playModel function
    _title = music.title;
    _song_lyrics = music.song_lyrics;
    _album = music.album;
    _subtitle = music.subtitle;
    _url = music.url;
    _id = music.id;
    _like = music.like_flag;
    _release_date = music.release_date;
    _year = music.year;
    _artist = music.artist;
    _singer_id = music.singer_id;
    _album_id = music.album_id;
    _imageUrl = music.file_data;
    _imagealbum = music.imagealbum;
    // _audioPlayer.setUrl(music.url);
    // addModel(music);
    // _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(music.url)));
    await _audioPlayer.setAudioSource(apiplaylist);
    _audioPlayer.play();
    _currentIndex = apiData.indexOf(music);

    // playSongAtIndex(apiData.indexOf(music));
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FirestoreConstants.miniPlayerShow, true);


    // removeLastPlayedSong(music);
    //  await saveLastPlayedSong(music);

  }




  Future<void> playSongAtIndex3(int index) async {
    apiplaylist3.clear();
    apiplaylist3.addAll(newPlaylist);
    await _audioPlayer.setAudioSource(
        apiplaylist3, initialIndex: index, preload: true);
    _audioPlayer.play();
  }

  Future<void> fetchAndPlaySongsByIdAndType(String type, String id,) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final Uri uri = Uri.parse('${media}${type}=${id}');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      List<dynamic> songs;

      if (decodedResponse is Map<String, dynamic>) {
        songs = decodedResponse['data']['songs'];
      } else if (decodedResponse is List) {
        songs = decodedResponse;
      } else {
        throw Exception('Unexpected response format');
      }


      for (var song in songs) {
        final songData = Music(
          title: song['title'],
          artist: song['singer'][0]['name'].toString(),
          album: song['album']['name'],
          imagealbum: song['album']['image_data'],
          url: song['file_data'],
          song_lyrics: song['song_lyrics'].toString(),
          image: song['image_data'],
          id: song['id'].toString(),
          subtitle: song['subtitle'],
          singer_id: song['singer_id'].toString(),
          year: song['year'].toString(),
          album_id: song['album_id'].toString(),
          mood_id: song['mood_id'].toString(),
          language_id: song['language_id'].toString(),
          genre_id: song['genre_id'].toString(),
          music_director_id: song['music_director_id'].toString(),
          file_data: song['file_data'],
          image_data: song['image_data'],
          status: song['status'],
          release_date: song['release_date'],
          like_flag: song['like_flag'] as bool,
        );

        newPlaylist.add(AudioSource.uri(
          Uri.parse(songData.file_data),
          tag: musicToMediaItem(songData),
        )
        );
      }

    } else {
      throw Exception('Failed to load songs: ${response.statusCode}');
    }
  }
  static MediaItem musicToMediaItem(Music song) {
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
  static MediaItem musicToMediaItemoffline(SongModel song) {
    return MediaItem(
      id: song.id.toString(),
      album: song.album,
      title: song.title,
      artist: song.artist,
      genre: song.genre,
      duration: null,
      // You can set the duration if available
      artUri: Uri.parse(song.uri.toString()),
      extras: {
        'subtitle': song.album,
        'singer_id': song.artist,
        'file_data': song.uri,
        'image_data': song.uri,
        'url': song.uri,
      },
    );
  }

  // RecentlySongs

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
            newPlaylist.add(AudioSource.uri(
              Uri.parse(song.file_data),
              tag: musicToMediaItem(song),
            )
            );
          }

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


  Future<void> hitAllSong() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(songs),
      headers: {
        'Authorization': 'Bearer $token', // Adding the token to the headers
      },
    );



    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        final List<dynamic> songsJson = responseData['songs'];

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
          apiplaylist.add(AudioSource.uri(
            Uri.parse(song.file_data),
            tag: musicToMediaItem(song),
          ),

          );

          newPlaylist.add(AudioSource.uri(
            Uri.parse(song.file_data),
            tag: musicToMediaItem(song),
          ),

          );
        }

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







  // static playNextSong() async {
  //   if (_currentIndex < apiData.length - 1) {
  //     _currentIndex++;
  //     playModel(apiData[_currentIndex]);
  //   } else {
  //     if (repeatSong) {
  //       _currentIndex = 0;
  //       playModel(apiData[_currentIndex]);
  //     } else {}
  //   }
  // }


  Future<void> pauseSong() async {
    try {
      await _audioPlayer.pause();
      _isLoading = false;
      _loadingController.add(_isLoading);
    } catch (e) {
      print('Error pausing song: $e');
    }
  }


  Future<void> resumeSong() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error resuming song: $e');
    }
  }


  // static playPreviousSong() async {
  //   playPrevious();
  // }


  String getImageUrl() {
    return _imageUrl;
  }

  void updateTitle(String newTitle) {
    _title = newTitle;
  }

  void updateSubtitle(String newSubtitle) {
    _subtitle = newSubtitle;
  }

  Stream<Duration?> getDurationStream() {
    return _audioPlayer.durationStream;
  }

  Stream<Duration?> getPositionStream() {
    return _audioPlayer.positionStream;
  }

  void dispose() {
    _loadingController.close();
  }

  // Future<void> playNext() async {
  //   if (isShuffling) {
  //     _currentIndex = _getRandomIndex();
  //   } else {
  //     if (repeatSong) {
  //       _currentIndex = 0;
  //       playModel(apiData[_currentIndex]);
  //     } else {
  //       print("No more songs to play");
  //     }
  //   }
  //
  //   playModel(apiData[_currentIndex]);
  // }
  //
  // static playPrevious() async {
  //   if (_currentIndex > 0) {
  //     _currentIndex--;
  //   } else {
  //     if (repeatMode == RepeatMode.all) {
  //       _currentIndex = apiData.length - 1;
  //     } else {
  //       _audioPlayer.stop();
  //       return;
  //     }
  //   }
  //
  //   playModel(apiData[_currentIndex]);
  // }

  void stopSong() {
    _audioPlayer.stop();
  }


  // int _getRandomIndex() {
  //   final random = Random();
  //   return random.nextInt(apiData.length);
  // }

  void toggleShuffleMode() {
    isShuffling = !isShuffling;
  }





  // All ui button widget


  static Widget getVolumeButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.volume_up, color: Colors.white,),
      onPressed: () {
        showSliderDialog(
          colors: Colors.black,
          context: context,
          title: "Adjust volume",
          divisions: 10,
          min: 0.0,
          max: 1.0,
          value: _audioPlayer.volume,
          stream: _audioPlayer.volumeStream,
          onChanged: _audioPlayer.setVolume,
        );
      },
    );
  }

  static Widget getPlayerSpeed(BuildContext context) {
    return StreamBuilder<double>(
      stream: _audioPlayer.speedStream,
      builder: (context, snapshot) =>
          IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                colors: Colors.black,
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: _audioPlayer.speed,
                stream: _audioPlayer.speedStream,
                onChanged: _audioPlayer.setSpeed,
              );
            },
          ),
    );
  }

  static Widget getPalyPauseButton(BuildContext context) {
    return Container(
      height: 60.sp,
      child: Stack(
        children: [
          Center(
            child: StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    width: 35.sp,
                    height: 35.sp,
                    child: const CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_circle, color: Colors.white,),
                    iconSize: 55.sp,
                    onPressed: _audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause_circle, color: Colors.white,),
                    iconSize: 55.sp,
                    onPressed: _audioPlayer.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay, color: Colors.white,),
                    iconSize: 55.sp,
                    onPressed: () => _audioPlayer.seek(Duration.zero),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget getPalyPauseButton2(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    // margin: const EdgeInsets.all(5.0),
                    width: 30.sp,
                    height: 30.sp,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: const CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  );
                } else if (playing != true) {
                  return GestureDetector(
                    onTap:_audioPlayer.play,
                    child: Container(
                      width: 30.sp,
                      height: 30.sp,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.sp), // Make the container circular
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(8.sp),
                        child: Center(child: Image.asset('assets/play_mini.png')),
                      ),
                    ),
                  );

                  //   IconButton(
                  //   icon: const Icon(Icons.play_circle, color: Colors.white,),
                  //   iconSize: 35.sp,
                  //   onPressed: _audioPlayer.play,
                  // );
                } else if (processingState != ProcessingState.completed) {
                  return  GestureDetector(
                    onTap:_audioPlayer.pause,
                    child: Container(
                      width: 30.sp,
                      height: 30.sp,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.sp), // Make the container circular
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(8.sp),
                        child: Center(child: Image.asset('assets/pause_mini.png')),
                      ),
                    ),
                  );


                  //   IconButton(
                  //   icon: const Icon(Icons.pause_circle, color: Colors.white,),
                  //   iconSize: 35.sp,
                  //   onPressed: _audioPlayer.pause,
                  // );
                } else {
                  return


                    IconButton(
                    icon: const Icon(Icons.replay, color: Colors.white,),
                    iconSize: 25.sp,
                    onPressed: () => _audioPlayer.seek(Duration.zero),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getplayerButtonNext(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) =>
          IconButton(
            icon: const Icon(Icons.skip_next, size: 32, color: Colors.white,),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
    );


    // IconButton(
    //   iconSize: 32,
    //   onPressed: () {
    //     playNextSong();
    //
    //     // _playNextSong();
    //     // musicService.playNextSong();
    //     // musicService.playNextSong1(musicService.apiData,musicService.currentSong);
    //
    //     // musicService.skipNext();
    //     // musicService.playNext();
    //   },
    //   icon:
    //   Icon(Icons.skip_next, color: Colors.white),
    // );
  }

  Widget getplayerButtonPreviousNext(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) =>
          IconButton(
            icon: const Icon(
              Icons.skip_previous, size: 32, color: Colors.white,),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
    );


    //
    // IconButton(
    //   iconSize: 32,
    //   onPressed: () {
    //     // playPreviousSong()();
    //     // musicService.skipPrevious();
    //     playPreviousSong();
    //   },
    //   icon: Icon(Icons.skip_previous,
    //       color: Colors.white),
    // );


  }

  static Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
              (position, bufferedPosition, duration) =>
              PositionData(
                  position, bufferedPosition, duration ?? Duration.zero));

  static Widget getplayerSlider(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return SeekBar(
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: _audioPlayer.seek,
        );
      },
    );
  }

  static Widget getPlayerSliderLine(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        final duration = positionData?.duration ?? Duration.zero;
        final position = positionData?.position ?? Duration.zero;
        final bufferedPosition = positionData?.bufferedPosition ??
            Duration.zero;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 1.sp,
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    value: bufferedPosition.inMilliseconds /
                        (duration.inMilliseconds > 0
                            ? duration.inMilliseconds
                            : 1),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    // Buffered position color
                    backgroundColor: Colors.grey.withOpacity(
                        0.3), // Background color for the buffered indicator
                  ),
                  LinearProgressIndicator(
                    value: position.inMilliseconds /
                        (duration.inMilliseconds > 0
                            ? duration.inMilliseconds
                            : 1),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    // Current position color
                    backgroundColor: Colors
                        .transparent, // Make sure this background is transparent
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget getPlayerSliderCri(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return CircularSeekBar(
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: (Duration value) {},
          // onChangeEnd: _audioPlayer.seek,

        );
      },
    );
  }

  static Widget getplayerRepeatSong(BuildContext context) {
    return StreamBuilder<LoopMode>(
      stream: _audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final icons = [
          Icon(Icons.repeat_one, color: Colors.orangeAccent),
          // Icon for LoopMode.one
          Icon(Icons.repeat, color: Theme
              .of(context)
              .dividerColor),
          // Icon for LoopMode.off
        ];
        const cycleModes = [
          LoopMode.one,
          LoopMode.off,
        ];
        final index = cycleModes.indexOf(snapshot.data ??
            LoopMode.off); // Using snapshot.data to get the current loop mode
        return IconButton(
          icon: icons[index],
          onPressed: () {
            final nextIndex = (cycleModes.indexOf(
                snapshot.data ?? LoopMode.off) + 1) % cycleModes.length;
            _audioPlayer.setLoopMode(cycleModes[nextIndex]);
          },
        );
      },
    );
  }

  static Widget getplayerShufflingSong(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _audioPlayer.shuffleModeEnabledStream,
      builder: (context, snapshot) {
        return _shuffleButton(
          context,
          snapshot.data ?? false,
              (bool isEnabled) async {
            if (isEnabled) {
              await _audioPlayer.shuffle();
            }
            await _audioPlayer.setShuffleModeEnabled(isEnabled);
          },
        );
      },
    );
  }

  static Widget _shuffleButton(BuildContext context, bool isEnabled, Function(bool) onPressed) {
    return IconButton(
      icon: Icon(
        Icons.shuffle,
        color: isEnabled ? Colors.orangeAccent : null,
      ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await _audioPlayer.shuffle();
        }
        await _audioPlayer.setShuffleModeEnabled(enable);
        onPressed(
            enable); // Notify parent widget about the change in shuffle mode
      },
    );
  }




}


