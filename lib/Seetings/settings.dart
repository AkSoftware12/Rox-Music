import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Profile/profile.dart';
import '../CommonCalling/Common.dart';
import 'dart:io';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<SettingScreen> {
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
    return Scaffold(
        backgroundColor:  Colors.black,
        // backgroundColor: Color(0xEE2B2E2F),

        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                height: 60,
                // Card elevation
                child: Center(
                  child: ListTile(
                    title: Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_circle_left_outlined,color: Colors.white,size: 40,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),  ),
                ), // Margin around the card
              ),
            ),

 //  6230115742
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 30),
              child: Container(
                // Card elevation

                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
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
                    ],
                  ),

                ),
                // Margin around the card
              ),
            ),
            Divider(height: 1,thickness: 2,color: Colors.white10,),


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
                        'Mobile Notification',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.mobile_friendly,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Email Notification',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.email,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Theme',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.color_lens,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Share',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.share,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        common.onShareButtonPressed(context);
                      },
                    ), // Margin around the card
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
                        'Downloads',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download_for_offline,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Contact Us',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.connect_without_contact,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Help & FAQ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.help,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Rate on Google Play',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.rate_review,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                        'Terms & Privacy',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
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
                            color: Colors.white,
                          ),
                        ],
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.privacy_tip_outlined,
                              size: 23,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // _handleSignOut();
                      },
                    ), // Margin around the card
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
                              fontWeight: FontWeight.normal),
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
        ));
  }
}
