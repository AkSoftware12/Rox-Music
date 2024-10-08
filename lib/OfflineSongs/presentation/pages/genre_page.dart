import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../Home/Home Bottom/miniplayer.dart';
import '../../../Home/Home Bottom/player.dart';
import '../../data/models/player_page_arguments.dart';
import '../components/song_list_tile.dart';
import '../utils/theme/themes.dart';

class GenrePage extends StatefulWidget {
  final GenreModel genre;

  const GenrePage({Key? key, required this.genre}) : super(key: key);

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late List<SongModel> _songs;

  @override
  void initState() {
    super.initState();
    _songs = [];
    _getSongs();
  }
  void _refresh() {
    setState(() {

    });
  }
  Future<void> _getSongs() async {
    final OnAudioQuery audioQuery = OnAudioQuery();

    final List<SongModel> songs = await audioQuery.queryAudiosFrom(
      AudiosFromType.GENRE_ID,
      widget.genre.id,
    );

    // remove songs less than 10 seconds long (10,000 milliseconds)
    songs.removeWhere((song) => (song.duration ?? 0) < 10000);

    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,color: Colors.white,
          ),
        ),
        title: Text(
          widget.genre.genre, style: TextStyle(
          color: Colors.white,
        ),
        ),
      ),
      body: Stack(
        children: [
          Ink(
            decoration: BoxDecoration(
              // gradient: Themes.getTheme().linearGradient,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _songs.length,
                    itemBuilder: (context, index) {
                      final SongModel song = _songs[index];
                      final args = PlayerPageArguments(
                        songs: _songs,
                        initialIndex: index,
                      );
                      return SongListTile(
                        song: song,
                        args: args,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: OpenContainer(
              transitionType: ContainerTransitionType.fadeThrough,
              closedColor: Theme.of(context).cardColor,
              closedElevation: 0.0,
              openElevation: 4.0,
              transitionDuration: Duration(milliseconds: 500),
              openBuilder: (BuildContext context, VoidCallback _) =>  Player(onReturn: _refresh),
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return MiniPlayer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
