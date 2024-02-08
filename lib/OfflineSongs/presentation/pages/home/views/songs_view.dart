import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../../Service/MusicService.dart';
import '../../../../bloc/home/home_bloc.dart';
import '../../../../data/models/player_page_arguments.dart';
import '../../../../data/repositories/song_repository.dart';
import '../../../components/song_list_tile.dart';



class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> with SingleTickerProviderStateMixin {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  MusicService musicService=MusicService();

  bool _hasPermission = false;
  List<SongModel> items = [];
  List<SongModel> filteredItems = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    filteredItems = List.from(items);
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: !_hasPermission
              ? noAccessToLibraryWidget()
              : FutureBuilder<List<SongModel>>(
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

                          musicService.playSong(
                            item.data![index].uri.toString(),
                            item.data![index].id.toString(),
                            item.data![index].title,
                            item.data![index].artist.toString(),
                          );
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
  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

}
