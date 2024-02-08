import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share/share.dart';
import '../../Login/login.dart';
import '../../Profile/profile.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});


  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<SettingScreen> {
  bool _progressVisible = false;


  // void _showProgressBar() {
  //   setState(() {
  //     _progressVisible = true;
  //   });
  //
  //   // Add a delay of 2 seconds before allowing the text
  // }

  void _hideProgressBar() {
    setState(() {
      _progressVisible = false;
    });
  }


  @override
  void initState() {
    super.initState();

  }


  void _showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Progress bar widget
        );
      },
    );
    // Simulate a delay before hiding the progress bar
    Future.delayed(Duration(seconds: 2), () {
    });
  }
  void _onShareButtonPressed(BuildContext context) {
    String title = "musicService.title";
    String subtitle =" musicService.subtitle";
    String url = "musicService.url";
    String imagePath =" musicService.getImageUrl()";

    Share.share(
      '$title\n$subtitle\n $url',
      // subject: musicService.title,

      sharePositionOrigin: Rect.fromCircle(
        center: Offset(0, 0),
        radius: 100,
      ),
      // shareRect: Rect.fromCircle(
      //   center: Offset(0, 0),
      //   radius: 100,
      // ),
      // imageUrl: 'file:///$imagePath',
    );
  }

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      title: Text(
      'Ravikant',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Text(
        'ravi@gmail.com',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
      leading:
       CircleAvatar(
        radius: 20.0,
        backgroundImage: AssetImage('assets/pngegg.png'),
        // backgroundImage: CachedNetworkImageProvider(img),
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
    );
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
            // _buildBody(),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 8),
              child: Container(
                height: 60,
                // Card elevation

                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: listTile,
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
                        _onShareButtonPressed(context);
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
                        _showProgressBar(context);
                        // _handleSignOut();
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
