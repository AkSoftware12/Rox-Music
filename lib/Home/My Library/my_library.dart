import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Seetings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonCalling/Common.dart';
import '../../History Songs/history_songs.dart';
import '../../Profile/profile.dart';
import '../../constants/color_constants.dart';
import '../../constants/firestore_constants.dart';
import '../Home View All/recently_songs.dart';
import 'dart:io';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<LibraryScreen> {
  CommonMethod common = CommonMethod();

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String userEmail = '';

  bool isLoading = false;
  File? avatarImageFile;



  @override
  void initState() {
    super.initState();
    readLocal();
  }

  Future<void> readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(FirestoreConstants.id) ?? "";
      nickname = prefs.getString(FirestoreConstants.nickname) ?? "";
      photoUrl = prefs.getString(FirestoreConstants.photoUrl) ?? "";
      userEmail = prefs.getString(FirestoreConstants.userEmail) ?? "";
    });


  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Music Player Saavn',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: false,
              expandedHeight: 40,
              // backgroundColor: const Color(0xFF222B40),
              backgroundColor: Colors.black,
              onStretchTrigger: () async {

              },
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: 50,
                    // Card elevation
                    child: Center(
                      child: ListTile(
                        title: Text(
                          'My Library',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        trailing: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 25,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SettingScreen();
                              },
                            ),
                          );
                        },
                      ),
                    ), // Margin around the card
                  ),
                ),
                titlePadding: EdgeInsets.only(top: 1),
                centerTitle: true,
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                  StretchMode.blurBackground,
                ],
              ),
            ),
            SliverToBoxAdapter(

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 50,
                      // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title:
                        Text(

                        nickname,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text(
                          userEmail,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        leading: Container(
                          child: avatarImageFile == null
                              ? photoUrl.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, object, stackTrace) {
                                return Icon(
                                  Icons.account_circle,
                                  size: 90,
                                  color: ColorConstants.greyColor,
                                );
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.themeColor,
                                      value: loadingProgress
                                          .expectedTotalBytes !=
                                          null
                                          ? loadingProgress
                                          .cumulativeBytesLoaded /
                                          loadingProgress
                                              .expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              : Icon(
                            Icons.account_circle,
                            size: 90,
                            color: ColorConstants.greyColor,
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              avatarImageFile!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.edit,
                          color: Colors.cyanAccent,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProfileScreen();
                              },
                            ),
                          );
                        },
                      ), // Margin around the card
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(

                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Icon(
                                              Icons.music_note_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Songs',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return RecentlySongsClass();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 190.0),
                                          //   child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return RecentlySongsClass();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //       child:
                                          //           Icon(Icons.arrow_forward_ios)),
                                          // ),
                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Icon(
                                              Icons.album,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Albums',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 287,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return RecentlySongsClass();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 190.0),
                                          //   child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return RecentlySongsClass();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //       child:
                                          //           Icon(Icons.arrow_forward_ios)),
                                          // ),
                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Icon(
                                              Icons.perm_camera_mic_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Artists',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 295,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return RecentlySongsClass();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 190.0),
                                          //   child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return RecentlySongsClass();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //       child:
                                          //           Icon(Icons.arrow_forward_ios)),
                                          // ),
                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),

                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Icon(
                                              Icons.shop,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Shows',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 295,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return RecentlySongsClass();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 190.0),
                                          //   child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return RecentlySongsClass();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //       child:
                                          //           Icon(Icons.arrow_forward_ios)),
                                          // ),
                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child:  Icon(
                                              Icons.download_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Downloads',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 255,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return RecentlySongsClass();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),

                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Icon(
                                              Icons.playlist_play_sharp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Playlists',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 277,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return RecentlySongsClass();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 190.0),
                                          //   child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return RecentlySongsClass();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //       child:
                                          //           Icon(Icons.arrow_forward_ios)),
                                          // ),
                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: 1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child:Icon(
                                              Icons.history,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'History',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 290,
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return HistorySongs();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward_ios)),

                                                ]),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.only(left: 190.0),
                                          //   child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return RecentlySongsClass();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //       child:
                                          //           Icon(Icons.arrow_forward_ios)),
                                          // ),
                                        ]);
                                  }),
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),
                      SizedBox(
                        height: 60,
                        child: Column(children: [


                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Container(
                              height: 58,
                              color: Colors.black, // Controls the shadow depth
                              // Card elevation
                              child: ListTile(
                                title:Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // leading: Icon(
                                //   Icons.logout,
                                //   color: Colors.white,
                                // ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 23,
                                      color: Colors.cyanAccent,
                                    ),
                                  ],
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        size: 23,
                                        color: Colors.cyanAccent,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  common.showProgressBar(context);

                                },
                              ), // Margin around the card
                            ),
                          ),
                          Divider(height: 1,thickness: 2,color: Colors.white10,),

                        ]),
                      ),

                    ],
                  ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.android;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
