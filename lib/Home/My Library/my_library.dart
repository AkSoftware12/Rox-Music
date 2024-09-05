import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/AccountBalance/wallet.dart';
import 'package:music_player_saavn/Home/Home%20Bottom/miniplayer.dart';
import 'package:music_player_saavn/Seetings/settings.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ArtistFollow/artist_follow.dart';
import '../../CommonCalling/Common.dart';
import '../../History Songs/history_songs.dart';
import '../../LikeSongs/like_songs.dart';
import '../../Profile/profile.dart';
import '../../Widget/widgetShuffle.dart';
import '../../constants/color_constants.dart';
import '../../constants/firestore_constants.dart';
import '../Home Bottom/player.dart';
import '../Home Bottom/src/weslide_controller.dart';
import '../Home View All/All_tab_view_all.dart';
import 'dart:io';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<LibraryScreen> {
  CommonMethod common = CommonMethod();
  bool isPlaying = false;

  String id = '';
  String nickname = '';
  String userContact = '';
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
      userContact=prefs.getString(FirestoreConstants.userEmail) ?? "";

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 30.sp,
            // backgroundColor: const Color(0xFF222B40),
            backgroundColor: Colors.black,
            onStretchTrigger: () async {},
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Container(
                  height: 40.sp,
                  // Card elevation
                  child: Center(
                    child: ListTile(
                      title: Text(
                        'My Library',
                        style: GoogleFonts.poppins(
                          textStyle:  TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SettingScreen();
                              },
                            ),
                          );
                        },
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return SettingScreen();
                        //     },
                        //   ),
                        // );
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
                    height: 45.sp,
                    // Controls the shadow depth
                    // Card elevation
                    child: ListTile(
                      title: nickname.isNotEmpty ? Text(
                        '${nickname }',
                        style: GoogleFonts.poppins(
                          textStyle:  TextStyle(
                              color: Colors.white,
                              fontSize: TextSizes.textlarge,
                              fontWeight: FontWeight.bold),
                        ),
                      ):Text(
                        '${'User' }',
                        style: GoogleFonts.poppins(
                          textStyle:  TextStyle(
                              color: Colors.white,
                              fontSize: TextSizes.textlarge,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        userEmail,
                        style: GoogleFonts.poppins(
                          textStyle:  TextStyle(
                              color: Colors.white,
                              fontSize: TextSizes.textmedium,
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
                            errorBuilder:
                                (context, object, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 45.sp,
                                color: ColorConstants.greyColor,
                              );
                            },
                            loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null)
                                return child;
                              return Container(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color:
                                    ColorConstants.themeColor,
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
                          size: 45.sp,
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
                  padding: EdgeInsets.only(top: 20.0, left: 75),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return AccountBalance();
                      //     },
                      //   ),
                      // );



                    },
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [

                              SizedBox(
                                width: 5.sp,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Earning Balance\n${'₹ 100.00'}",
                                    style: GoogleFonts.poppins(
                                      textStyle:  TextStyle(
                                          color: Colors.orange,
                                          fontSize: TextSizes.textmedium,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Card(
                                  elevation: 5,
                                  color: Colors.orange,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Withdraw',
                                      style: GoogleFonts.poppins(
                                        textStyle:  TextStyle(
                                            color: Colors.white,
                                            fontSize: TextSizes.textmedium,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 28.0),
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.white10,
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(5.sp),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecentlySongsClass(
                                name: 'Songs',
                              );
                            },
                          ),
                        );
                      },
                      child:  Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets
                                    .all(
                                    5.0),
                                child:
                                SizedBox(
                                  width:
                                  40.sp,
                                  child:
                                  Icon(
                                    Icons.music_note_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Songs',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets
                                    .only(
                                    right:
                                    2.0),
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Songs',
                                              );
                                            },
                                          ),
                                        );                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.white10,
                          ),

                        ],
                      ),
                    );




                  },
                  childCount: 1,
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.all(5.sp),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecentlySongsClass(
                                name: 'Albums',
                              );
                            },
                          ),
                        );
                      },
                      child:  Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets
                                    .all(
                                    5.0),
                                child:
                                SizedBox(
                                  width:
                                  40.sp,
                                  child:
                                  Icon(
                                    Icons.album,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Album',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets
                                    .only(
                                    right:
                                    2.0),
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Albums',
                                              );
                                            },
                                          ),
                                        );                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.white10,
                          ),

                        ],
                      ),
                    );




                  },
                  childCount: 1,
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.all(5.sp),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ArtistFollow(

                              );
                            },
                          ),
                        );
                      },
                      child:  Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets
                                    .all(
                                    5.0),
                                child:
                                SizedBox(
                                  width:
                                  40.sp,
                                  child:
                                  Icon(
                                    Icons.perm_camera_mic_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Artists',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets
                                    .only(
                                    right:
                                    2.0),
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ArtistFollow(

                                              );
                                            },
                                          ),
                                        );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.white10,
                          ),

                        ],
                      ),
                    );




                  },
                  childCount: 1,
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.all(5.sp),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecentlySongsClass(
                                name: 'Artists',
                              );
                            },
                          ),
                        );
                      },
                      child:  Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets
                                    .all(
                                    5.0),
                                child:
                                SizedBox(
                                  width:
                                  40.sp,
                                  child:
                                  Icon(
                                    Icons.download_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Downloads',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets
                                    .only(
                                    right:
                                    2.0),
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Artists',
                                              );
                                            },
                                          ),
                                        );                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.white10,
                          ),

                        ],
                      ),
                    );




                  },
                  childCount: 1,
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.all(5.sp),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecentlySongsClass(
                                name: 'Playlists',
                              );
                            },
                          ),
                        );
                      },
                      child:  Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets
                                    .all(
                                    5.0),
                                child:
                                SizedBox(
                                  width:
                                  40.sp,
                                  child:
                                  Icon(
                                    Icons.playlist_play_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Playlists',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets
                                    .only(
                                    right:
                                    2.0),
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RecentlySongsClass(
                                                name: 'Playlists',
                                              );
                                            },
                                          ),
                                        );                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.white10,
                          ),

                        ],
                      ),
                    );




                  },
                  childCount: 1,
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.all(5.sp),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LikeSongsClass(
                              );
                            },
                          ),
                        );
                      },
                      child:  Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets
                                    .all(
                                    5.0),
                                child:
                                SizedBox(
                                  width:
                                  40.sp,
                                  child:
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.all(5.sp),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Like Songs',
                                        style: TextStyle(color: Colors.white, fontSize: TextSizes.textlarge),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets
                                    .only(
                                    right:
                                    2.0),
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return LikeSongsClass(
                                              );
                                            },
                                          ),
                                        );                                       },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.white10,
                          ),

                        ],
                      ),
                    );




                  },
                  childCount: 1,
                )),
          ),


        ],
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
