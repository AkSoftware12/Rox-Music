import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_saavn/ApiModel/playModel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../Home/home.dart';
import '../../../../../Service/MusicService.dart';




class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> with SingleTickerProviderStateMixin {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  MusicService musicService=MusicService();

  List<SongModel> items = [];
  List<SongModel> filteredItems = [];
  List<MediaItem> globalQueue = [];
  List response = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    filteredItems = List.from(items);
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    // checkAndRequestPermissions();
    setOffValues(response);
  }


  void setOffValues(List response) {
    getTemporaryDirectory().then((tempDir) async {
      final File file = File('${tempDir.path}/cover.jpg');
      if (!await file.exists()) {
        final byteData = await rootBundle.load('assets/cover.jpg');
        await file.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
      for (int i = 0; i < response.length; i++) {
        globalQueue.add(
          await setTags(response[i] as SongModel, tempDir),
        );
      }
    });
  }

  Future<MediaItem> setTags(SongModel response, Directory tempDir) async {
    String playTitle = response.title;
    playTitle == ''
        ? playTitle = response.displayNameWOExt
        : playTitle = response.title;
    String playArtist = response.artist!;
    playArtist == '<unknown>'
        ? playArtist = 'Unknown'
        : playArtist = response.artist!;

    final String playAlbum = response.album!;
    final int playDuration = response.duration ?? 180000;
    final String imagePath = '${tempDir.path}/${response.displayNameWOExt}.jpg';

    final MediaItem tempDict = MediaItem(
      id: response.id.toString(),
      album: playAlbum,
      duration: Duration(milliseconds: playDuration),
      title: playTitle.split('(')[0],
      artist: playArtist,
      genre: response.genre,
      artUri: Uri.file(imagePath),
      extras: {
        'url': response.data,
        'date_added': response.dateAdded,
        'date_modified': response.dateModified,
        'size': response.size,
        'year': response.getMap['year'],
      },
    );
    return tempDict;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child:  FutureBuilder<List<SongModel>>(
            // Default values:
            future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.DESC_OR_GREATER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item) {
              // Display error, if any.
              if (item.hasError) {
                return Text(item.error.toString());
              }

              // Waiting content.
              if (item.data == null) {
                return const CircularProgressIndicator();
              }

              // 'Library' is empty.
              if (item.data!.isEmpty)
                return const Text("Nothing found!");

              // You can use [item.data!] direct or you can create a:
              List<SongModel> songs = item.data!;
              return ListView.builder(
                itemCount: item.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          item.data![index].title,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          item.data![index].artist ?? "No Artist",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        leading: QueryArtworkWidget(
                          controller: _audioQuery,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                        ),
                        onTap: () async {


                          // musicService.newPlaylist.add(AudioSource.uri(
                          //   Uri.parse(songData.file_data),
                          //   tag: musicToMediaItem(songData),
                          // )

                          musicService.newPlaylist.clear();

                          musicService.newPlaylist.add(AudioSource.uri(
                            Uri.parse(item.data![index].uri.toString()),
                            tag: MusicService.musicToMediaItemoffline(songs[index]),
                          ));
                          musicService.playSongAtIndex3(index);
                          //
                          //
                          // musicService.playSong(
                          //   item.data![index].id.toString(),
                          //   item.data![index].uri.toString(),
                          //   item.data![index].id.toString(),
                          //   item.data![index].title,
                          //   item.data![index].artist.toString(),
                          // );

                          // (context as Element).findAncestorStateOfType<BottomNavBarDemoState>()?.toggleMiniPlayerVisibility(true);

                        },
                      ),
                      // Add a Divider after each ListTile, except for the last one
                      if (index < item.data!.length - 1) Divider(color: Colors.white10),
                    ],
                  );
                },
              );

            },
          ),
        ),
    );
  }

}
