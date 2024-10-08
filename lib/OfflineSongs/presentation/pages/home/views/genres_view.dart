import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../../../bloc/home/home_bloc.dart';
import '../../../utils/app_router.dart';
import '../../genre_page.dart';

class GenresView extends StatefulWidget {
  const GenresView({super.key});

  @override
  State<GenresView> createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView>
    with SingleTickerProviderStateMixin {


  final audioQuery = OnAudioQuery();
  List<GenreModel> items = [];
  bool _hasPermission = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // context.read<HomeBloc>().add(GetGenresEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child:  FutureBuilder<List<GenreModel>>(
          // Default values:
          future: audioQuery.queryGenres(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
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
            List<GenreModel> songs = item.data!;
            return  ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                final genre = item.data![index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: FlipAnimation(
                    child: ListTile(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GenrePage(genre: genre,);
                            },
                          ),
                        );


                        // Navigator.of(context).pushNamed(
                        //   AppRouter.genreRoute,
                        //   arguments: genre,
                        // );
                      },
                      leading: QueryArtworkWidget(
                        id: genre.id,
                        type: ArtworkType.GENRE,
                        artworkBorder: BorderRadius.circular(10),
                        nullArtworkWidget: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.music_note_outlined,
                          ),
                        ),
                      ),
                      title: Text(
                        genre.genre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,color: Colors.white
                        ),
                      ),
                      subtitle: Text(
                        '${genre.numOfSongs} song${genre.numOfSongs == 1 ? '' : 's'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
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
