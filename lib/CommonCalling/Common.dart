
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_saavn/baseurlp/baseurl.dart';
import 'package:share/share.dart';
import '../Auth/auth_service.dart';
import '../Home/home.dart';
import '../Login/login.dart';
import '../Route/homebottom.dart';
import '../Service/MusicService.dart';
import '../Utils/color.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommonMethod{
  AuthService _authService = AuthService();
  MusicService musicService = MusicService();


  // logout
  Future<void > showProgressBar(BuildContext context) async {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return const Center(
           child: CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(ColorSelect.buttonColor),
           ), // Progress bar widget
         );
       },
     );
     // Simulate a delay before hiding the progress bar
     Future.delayed(const Duration(seconds: 5), () async {
       await _authService.logout();
       musicService.stopSong();
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => LoginScreen()),
       ); // Close the progress bar dialog
     });
   }




  // login
  Future<void > login(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorSelect.buttonColor),

          ),
        );
      },
    );

    await _authService.loginWithGoogle();
    if (await _authService.isUserLoggedIn()) {

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => MyHomePage()),
      // );


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeBottom()),
      );
    }
  }


// check Autho login
  Future<void> checkAutoLogin(BuildContext context) async {
    bool isLoggedIn = await _authService.isUserLoggedIn();
    if (isLoggedIn) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeBottom()),
      );
      // Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeBottom()),
    );
  }



  // share

  Future<void> onShareButtonPressed(BuildContext context) async {
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



 }