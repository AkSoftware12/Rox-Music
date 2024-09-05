import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/MusicService.dart';
import '../baseurlp/baseurl.dart';
import '../constants/firestore_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  MusicService musicService = MusicService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final String _loggedInKey = 'loggedIn';






  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
  Future<User?> loginWithGoogle() async {


    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      User? firebaseUser = (await _auth.signInWithCredential(credential)).user;

      // Replace 'your_registration_api_url' with your actual registration API URL





      // Write data to local storage

      SharedPreferences prefs = await SharedPreferences.getInstance();
      User? currentUser = firebaseUser;
      final String email = currentUser!.email.toString();
      final String name = currentUser!.displayName.toString();

      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? deviceToken = await _firebaseMessaging.getToken();
      print('Device id: $deviceToken');

      final response = await http.post(
        Uri.parse(register),
        body: json.encode({'email': email,'device_id': deviceToken,'name':name,
        }),
        headers: {'Content-Type': 'application/json'},
      );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String token = responseData['token'];
          final String uesrid = responseData['user']['id'].toString();

          await prefs.setString('token', token);
          await prefs.setString('userid', uesrid);

          print(token);
          print(uesrid);

          print(response);
          // Registration successful

        } else {
          // Registration failed

      }


      await prefs.setString(FirestoreConstants.id, currentUser!.uid);
      await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
      await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      await prefs.setString(FirestoreConstants.userEmail, currentUser.email ?? "");
      prefs.setBool(_loggedInKey, true);



    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }



  Future<void> logout() async {
    await _googleSignIn.signOut();
    musicService.stopSong();


    // Clear login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loggedInKey, false);

    prefs.remove(FirestoreConstants.id,);
    prefs.remove(FirestoreConstants.nickname,);
    prefs.remove(FirestoreConstants.photoUrl,);
    prefs.remove(FirestoreConstants.userEmail,);
    prefs.remove(FirestoreConstants.miniPlayerShow,);
    prefs.remove('token',);
    prefs.remove('miniPlayershow',);
    clearSharedPreferences();


  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}
