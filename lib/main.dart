import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/io_client.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_saavn/Home/home.dart';
import 'package:music_player_saavn/Route/homebottom.dart';
import 'package:music_player_saavn/Service/MusicService.dart';
import 'package:music_player_saavn/Widget/likeUnlike.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Auth/auth_service.dart';
import 'BackgroudPlay/backgrpoud.dart';
import 'Login/login.dart';
import 'MiniPlayer Demo/utils.dart';
import 'OfflineSongs/data/services/hive_box.dart';
import 'package:http/http.dart' as http;

import 'Service/audio_handler.dart';
import 'Widget/playPause.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

late AudioHandler myAudioHandler;
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();



  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCtv6MbZ-NW9gX1N-5_MCeh45w1gdBhqHI',
        appId: '1:912153009740:android:e05546e5714ae782fadee9',
        messagingSenderId: '912153009740',
        projectId: 'ring-music-player',
        storageBucket: "ring-music-player.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }


  runApp(MyApp());

}



class MyApp extends StatelessWidget {

  const MyApp({super.key, });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: AuthenticationWrapper(),
          // routes: {
          //   '/login': (context) => LoginScreen(),
          //   '/home': (context) => HomeBottom(),
          // },
        );
      },
    );
  }
}



class AuthenticationWrapper extends StatelessWidget {

  const AuthenticationWrapper({super.key, });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isUserLoggedIn(),
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? HomeBottom() : LoginScreen();
      },
    );
  }
}





