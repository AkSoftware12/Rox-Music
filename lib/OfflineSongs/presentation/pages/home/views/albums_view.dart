import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../../../bloc/home/home_bloc.dart';
import '../../../utils/app_router.dart';
import '../../album_page.dart';

class AlbumsView extends StatefulWidget {
  const AlbumsView({super.key});

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView>
    with SingleTickerProviderStateMixin {


  final audioQuery = OnAudioQuery();
  List<AlbumModel> items = [];

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child:  FutureBuilder<List<AlbumModel>>(
          // Default values:
          future: audioQuery.queryAlbums(
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
            List<AlbumModel> songs = item.data!;
            return  GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                final album = item.data![index];

                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  columnCount: 2,
                  child: FlipAnimation(
                    child: GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AlbumPage(album: album,);
                            },
                          ),
                        );


                        // Navigator.of(context).pushNamed(
                        //   AppRouter.albumRoute,
                        //   arguments: album,
                        // );
                      },
                      child: Column(
                        children: [
                          QueryArtworkWidget(
                            id: album.id,
                            type: ArtworkType.ALBUM,
                            artworkHeight: 136,
                            artworkWidth: 136,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: Container(
                              width: 136,
                              height: 136,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                              child: const Icon(
                                Icons.music_note_outlined,color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              album.album,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.white
                              ),
                            ),
                          ),
                          Text(
                            album.artist ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );





          },
        ),
      ),
    );

  }
}
