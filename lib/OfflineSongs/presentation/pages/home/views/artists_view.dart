import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../bloc/home/home_bloc.dart';
import '../../../utils/app_router.dart';
import '../../artist_page.dart';

class ArtistsView extends StatefulWidget {
  const ArtistsView({super.key});

  @override
  State<ArtistsView> createState() => _ArtistsViewState();
}

class _ArtistsViewState extends State<ArtistsView>
    with SingleTickerProviderStateMixin {
  // bool get wantKeepAlive => true;
  bool _hasPermission = false;

  final audioQuery = OnAudioQuery();
  List<ArtistModel> items = [];

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // context.read<HomeBloc>().add(GetArtistsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child:   FutureBuilder<List<ArtistModel>>(
          // Default values:
          future: audioQuery.queryArtists(
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
            List<ArtistModel> songs = item.data!;
            return  GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                final artist = item.data![index];

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
                              return ArtistPage(artist: artist,);
                            },
                          ),
                        );


                        // Navigator.of(context).pushNamed(
                        //   AppRouter.artistRoute,
                        //   arguments: artist,
                        // );
                      },
                      child: Column(
                        children: [
                          QueryArtworkWidget(
                            id: artist.id,
                            type: ArtworkType.ARTIST,
                            artworkHeight: 136,
                            artworkWidth: 136,
                            artworkBorder: BorderRadius.circular(100),
                            nullArtworkWidget: Container(
                              width: 136,
                              height: 136,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey,
                              ),
                              child: const Icon(
                                Icons.person,color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              artist.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.white
                              ),
                            ),
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

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
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
