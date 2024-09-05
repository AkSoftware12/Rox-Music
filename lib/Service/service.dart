import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_saavn/Model/recentaly.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiModel/playModel.dart';
import '../ApiModel/recntlySongs.dart';
import '../CircularSeekBar/circularSeekBar.dart';
import '../Exp/notifiers/play_button_notifier.dart';
import '../Exp/service_locator.dart';
import '../Utils/common.dart';
import '../constants/firestore_constants.dart';
import 'audio_handler.dart';
enum RepeatMode {
  none,
  all,
  one,
}




class MusicService2  extends BaseAudioHandler {

  static final MusicService2 _instance = MusicService2._internal();
  static AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<bool> _loadingController = StreamController<bool>.broadcast();
  final playButtonNotifier = PlayButtonNotifier();
  bool _isLoading = false;
  bool isShuffling = false;
  static String miniPlayerShow = 'miniPlayerShow';
  static bool repeatSong = false;
  bool _isRepeatEnabled = false;
  static bool isEnabled=false;


  late AudioPlayer _player;
  final _playlist = ConcatenatingAudioSource(children: []);

  static RepeatMode repeatMode = RepeatMode.none;

  RepeatMode get repeatModes => repeatMode;


  Music get currentSong => apiData[_currentIndex];

  static playCurrentSong() async {
    Music currentSong = apiData[_currentIndex];
    playModel(currentSong);
  }



  Stream<bool> getLoadingStream() {
    return _loadingController.stream;
  }

  Stream<bool>? getBufferingStream() {
    return null;

  }


  static List<Music> apiData =  [];
  static List<RecntlySong> apiData2 =  [];
  static int _currentIndex = 0;



  void setSongs(List<Music> songs) {
    apiData = songs;
  }


  static String _imageUrl = '';
  static String _imagealbum = '';
  static String _singer_image = '';
  static String _album_image= '';
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


  factory MusicService2() {
    return _instance;
  }


  MusicService2._internal() {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed ) {
        _audioPlayer.seek(Duration.zero);
        // playNext();
        stopSong();
        playNextSong();
        // playNextSong1();
      }
    });
  }

  Future<void> initialize() async {
    final lastPlayedSong = await getLastPlayedSong();
    if (lastPlayedSong != null) {
      playModel(lastPlayedSong);
    }
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



  // Get the playback state stream
  Stream<bool> getPlaybackStateStream() {
    return _audioPlayer.playingStream;
  }
  Future<void> common(String userId,String type,) async {
    try {

      _type = type;
      _userId = userId;

    } catch (e) {
      print('Error playing song: $e');
    }
  }


  Future<void> playSong(String id,String url,String imageUrl, String title, String subtitle,) async {
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
  static Future<bool> miniPlayerIsShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FirestoreConstants.miniPlayerShow) ?? false;
  }


  static Future<void> playModel(Music music) async {

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
    _imageUrl = music.image;
    _imagealbum= music.imagealbum;
    _audioPlayer.setUrl(music.url);
    _audioPlayer.play();
    _currentIndex = apiData.indexOf(music);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FirestoreConstants.miniPlayerShow, true);


    // removeLastPlayedSong(music);
    await saveLastPlayedSong(music);

  }
  static Future<void> playModelRecntlySong(RecntlySong recntlySong) async {
    // Your existing playModel function
    _title = recntlySong.title;
    _song_lyrics = recntlySong.song_lyrics;
    _album = recntlySong.album;
    _subtitle = recntlySong.subtitle;
    _url = recntlySong.url;
    _id = recntlySong.id;
    _like = recntlySong.like_flag;
    _release_date = recntlySong.release_date;
    _year = recntlySong.year;
    _artist = recntlySong.artist;
    _singer_id = recntlySong.singer_id;
    _album_id = recntlySong.album_id;
    _imageUrl = recntlySong.image;
    _imagealbum= recntlySong.imagealbum;
    _audioPlayer.setUrl(recntlySong.url);
    _audioPlayer.play();
    _currentIndex = apiData2.indexOf(recntlySong);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FirestoreConstants.miniPlayerShow, true);

    // removeLastPlayedSong(music);
    //  await saveLastPlayedSong(music);

  }




  void playAllSongs(List<Music> songs) {
    for (var song in songs) {
      playModel(song);
    }
  }


  static playNextSong() async {
    if (_currentIndex < apiData.length - 1) { // Check if there's a next song
      _currentIndex++; // Increment index to play the next song
      playModel(apiData[_currentIndex]);

      // Play the next song
    } else {
      if (repeatSong) {
        // If repeat is enabled, start playing from the beginning
        _currentIndex = 0;
        playModel(apiData[_currentIndex]);
      } else {
        // Handle case when there are no more songs to play
        print("No more songs to play");
      }
    }
  }



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

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking song: $e');
    }
  }

  Future<void> skipPrevious() async {
    try {
      var newPosition = _audioPlayer.position - Duration(seconds: 10);
      await _audioPlayer.seek(newPosition);
    } catch (e) {
      print('Error skipping previous: $e');
    }
  }

  Future<void> skipNext() async {
    try {
      var newPosition = _audioPlayer.position + Duration(seconds: 10);
      await _audioPlayer.seek(newPosition);
    } catch (e) {
      print('Error skipping next: $e');
    }
  }


  //
  // Future<void> playNextSong() async {
  //   await playNext();
  //   if (_repeatMode != RepeatMode.one) {
  //     await playCurrentSong();
  //   }
  // }

  static  playPreviousSong() async {
    playPrevious();
    // if (repeatMode != RepeatMode.one) {
    //   await playCurrentSong();
    // }
  }



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

  Future<void> playNext() async {
    if (isShuffling) {
      _currentIndex = _getRandomIndex();
    } else {
      if (repeatSong) {
        // If repeat is enabled, start playing from the beginning
        _currentIndex = 0;
        playModel(apiData[_currentIndex]);
      } else {
        // Handle case when there are no more songs to play
        print("No more songs to play");
      }
    }

    playModel(apiData[_currentIndex]);
  }

  static playPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      if (repeatMode == RepeatMode.all) {
        _currentIndex = apiData.length - 1;
      } else {
        // Stop playback if repeat mode is not all or one
        _audioPlayer.stop();
        return;
      }
    }

    playModel(apiData[_currentIndex]);
  }

  void stopSong() {
    _audioPlayer.stop();
  }

  void toggleRepeatMode() {
    switch (repeatMode) {
      case RepeatMode.none:
        repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        repeatMode = RepeatMode.none;
        break;
    }
  }

  int _getRandomIndex() {
    final random = Random();
    return random.nextInt(apiData.length);
  }

  void toggleShuffleMode() {
    isShuffling = !isShuffling;
  }



  // Function to get the player screen widget
  static Widget getVolumeButton( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return IconButton(
      icon: const Icon(Icons.volume_up,color: Colors.white,),
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

  static Widget getPlayerSpeed( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return   StreamBuilder<double>(
      stream: _audioPlayer.speedStream,
      builder: (context, snapshot) => IconButton(
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

  static Widget getPalyPauseButton( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return  Container(
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
                    // margin: const EdgeInsets.all(5.0),
                    width:  35.sp,
                    height:  35.sp,
                    child: const CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_circle,color: Colors.white,),
                    iconSize:  55.sp,
                    onPressed: _audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause_circle,color: Colors.white,),
                    iconSize:  55.sp,
                    onPressed: _audioPlayer.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay,color: Colors.white,),
                    iconSize:  55.sp,
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
  static Widget getPalyPauseButton2( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return  Container(
      height: 50.sp,
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
                    width:  30.sp,
                    height:  30.sp,
                    child: const CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_circle,color: Colors.white,),
                    iconSize:  35.sp,
                    onPressed: _audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause_circle,color: Colors.white,),
                    iconSize:  35.sp,
                    onPressed: _audioPlayer.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay,color: Colors.white,),
                    iconSize:  35.sp,
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
  static Widget getplayerButtonNext( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return   IconButton(
      iconSize: 32,
      onPressed: () {
        playNextSong();

        // _playNextSong();
        // musicService.playNextSong();
        // musicService.playNextSong1(musicService.apiData,musicService.currentSong);

        // musicService.skipNext();
        // musicService.playNext();
      },
      icon:
      Icon(Icons.skip_next, color: Colors.white),
    );



  }
  static Widget getplayerButtonPreviousNext( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return  IconButton(
      iconSize: 32,
      onPressed: () {
        // playPreviousSong()();
        // musicService.skipPrevious();
        playPreviousSong();
      },
      icon: Icon(Icons.skip_previous,
          color: Colors.white),
    );


  }


  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

   Widget getplayerSlider( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
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

   Widget getPlayerSliderCri(BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return CircularSeekBar(
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: _audioPlayer.seek,

        );
      },
    );
  }



  static Widget getplayerRepeatSong( BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
    return   StreamBuilder<LoopMode>(
      stream: _audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final icons = [
          Icon(Icons.repeat_one,color:Colors.orangeAccent),  // Icon for LoopMode.one
          Icon(Icons.repeat, color: Theme.of(context).dividerColor), // Icon for LoopMode.off
        ];
        const cycleModes = [
          LoopMode.one,
          LoopMode.off,
        ];
        final index = cycleModes.indexOf(snapshot.data ?? LoopMode.off); // Using snapshot.data to get the current loop mode
        return IconButton(
          icon: icons[index],
          onPressed: () {
            // Cycling through loop modes
            final nextIndex = (cycleModes.indexOf(snapshot.data ?? LoopMode.off) + 1) % cycleModes.length;
            _audioPlayer.setLoopMode(cycleModes[nextIndex]);
          },
        );
      },
    );


  }
  static Widget getplayerShufflingSong(BuildContext context) {
    // Here you can customize your player screen UI based on the current state of your audio player
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
        onPressed(enable); // Notify parent widget about the change in shuffle mode
      },
    );
  }

  static Future<void> saveLastPlayedSong(Music music) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('title', music.title);
    prefs.setString('subtitle', music.subtitle);
    prefs.setString('url', music.url);
    prefs.setString('id', music.id);
    prefs.setString('imageUrl', music.image);
    prefs.setBool('like', music.like_flag ?? false);
  }

  static Future<void> removeLastPlayedSong(Music music) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('title',);
    prefs.remove('subtitle',);
    prefs.remove('url', );
    prefs.remove('id',);
    prefs.remove('imageUrl',);
    prefs.remove('like',);
  }

  static Future<Music?> getLastPlayedSong() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? title = prefs.getString('title');
    final String? subtitle = prefs.getString('subtitle');
    final String? url = prefs.getString('url');
    final String? id = prefs.getString('id');
    final String? imageUrl = prefs.getString('imageUrl');
    final bool? like = prefs.getBool('like');

    if (title != null && subtitle != null && url != null && id != null && imageUrl != null) {
      return Music(
        title: title,
        subtitle: subtitle,
        url: url,
        id: id,
        image: imageUrl, year: '', singer_id: '',
        album_id: '', mood_id: '', language_id: '',
        genre_id: '', music_director_id: '', artist: '',
        file_data: '', image_data: '', status: '', release_date: '',
        like_flag: prefs.getBool('like') ?? false,
        album: '', imagealbum: '', song_lyrics: '',

      );
    }
    return null;
  }




}

