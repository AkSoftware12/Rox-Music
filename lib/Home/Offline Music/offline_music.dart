import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Service/MusicService.dart';

class OfflineMusicScreen extends StatefulWidget {
  const OfflineMusicScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<OfflineMusicScreen> {
  TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  MusicService musicService=MusicService();

  // Save the base64-encoded image to shared preferences

  // Indicate if application has permission to the library.
  bool _hasPermission = false;
  List<SongModel> items = [];
  List<SongModel> filteredItems = [];
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
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(items);
      });
    } else {
      setState(() {
        filteredItems = items.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredItems = List.from(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                height: 30,
                // Card elevation

                child: Center(
                  child: ListTile(
                    title: Text(
                      'Offline Songs ',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return ProfileScreen();
                      //     },
                      //   ),
                      // );
                    },
                  ),
                ), // Margin around the card
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 15, right: 15),
              child: Card(
                color: Colors.white,
                elevation: 4, // Controls the shadow depth
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12.0), // Controls corner radius
                ),
                margin: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        filterItems(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                          ),
                          onPressed: () {
                            _clearSearch();
                          },
                        ),
                        hintText: 'Search',
                      ),
                    ),
                  ),
                ), // Margin around the card
              ),
            ),
            Expanded(
              child: Center(
                child: !_hasPermission
                    ? noAccessToLibraryWidget()
                    : FutureBuilder<List<SongModel>>(
                        // Default values:
                        future: _audioQuery.querySongs(
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
            )

          ],
        ));
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
