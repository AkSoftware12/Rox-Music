import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:music_player_saavn/Model/recentaly.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  static AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<bool> _loadingController = StreamController<bool>.broadcast();
  bool _isLoading = false;

  Stream<bool> getLoadingStream() {
    return _loadingController.stream;
  }

  List<RecentlySongs> _songs =  [
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
        'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title: 'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
        'https://c.saavncdn.com/529/Shiv-Shankara-Hindi-2019-20190228184236-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/120/1fa9e474ab4df104cb3deecabd2ec342_96.mp4',
        title: 'Man Mera Mandir,Shiv Meri Puja',
        subtitle: 'Sameer Sen, Dilip Sen, Anuradha Paudwal',
        image: 'https://c.saavncdn.com/120/Shiv-Aaradhna-1991-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/122/b8bc2c1a0de0010582dfdb33a1f06436_96.mp4',
        title: 'Shiv Amritvaani',
        subtitle: 'Surender Kohli, Anuradha Paudwal',
        image: 'https://c.saavncdn.com/122/Shiv-Amritvani-1999-500x500.jpg'),
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/256/f912a4f10ab5505d5f80d7c87cdc23ab_96.mp4',
        title: 'Shree Hanuman Chalisa',
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
        subtitle:
        'Anup Jalota - Shree Ram Bhakt Hanuman Chalisa With Transcreation',
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
  int _currentIndex = 0;

  void setSongs(List<RecentlySongs> songs) {
    _songs = songs;
  }

  // void playSonglist(RecentlySongs song) {
  //   _title = title;
  //   _url = url;
  //   _subtitle = subtitle;
  //   _imageUrl = _imageUrl;
  //   _audioPlayer.setUrl(song.url);
  //   _audioPlayer.play();
  //   _currentIndex = _songs.indexOf(song);
  //
  // }
  String _imageUrl = '';
  String _title = '';
  String _subtitle = '';
  String _url = '';

  factory MusicService() {
    return _instance;
  }


  MusicService._internal();

  String get title => _title;
  String get subtitle => _subtitle;
  String get url => _url;



  // Get the playback state stream
  Stream<bool> getPlaybackStateStream() {
    return _audioPlayer.playingStream;
  }

  Future<void> playSong(String url,String imageUrl, String title, String subtitle,) async {
    try {

      _isLoading = true;
      _loadingController.add(_isLoading);
      _title = title;
      _url = url;
      _subtitle = subtitle;
      _imageUrl = imageUrl;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
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
    if (_currentIndex < _songs.length - 1) {
      _currentIndex++;
      // playSonglist(_songs[_currentIndex]);
    } else {
      // If at the end of the list, start from the beginning
      _currentIndex = 0;
      // playSonglist(_songs[_currentIndex]);
    }
  }

  void playPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      // playSonglist(_songs[_currentIndex]);
    } else {
      // If at the beginning of the list, go to the end
      _currentIndex = _songs.length - 1;
      // playSonglist(_songs[_currentIndex]);
    }
  }

  void stopSong() {
    _audioPlayer.stop();
  }

}
