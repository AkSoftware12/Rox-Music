import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_saavn/Home/home.dart';

import 'Auth/auth_service.dart';
import 'Demo/demo.dart';
import 'Login/login.dart';
import 'OfflineSongs/data/services/hive_box.dart';
import 'Service/audio_handler.dart';
late AudioHandler _audioHandler;

Future<void> main() async {

  // _audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
  //     androidNotificationChannelName: 'Audio playback',
  //     androidNotificationOngoing: true,
  //   ),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize hive
  await Hive.initFlutter();
  await Hive.openBox(HiveBox.boxName);
  //
  // // initialize audio service
  //
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.shokhrukhbek.meloplay.channel.audio',
  //   androidNotificationChannelName: 'Meloplay Audio',
  //   androidNotificationOngoing: true,
  //   androidStopForegroundOnPause: true,
  // );
  //

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  AuthenticationWrapper(),
      // home:   PhoneAuthScreen(),
    );
  }
}
class AuthenticationWrapper extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the Future is still running
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          // Use the result of the Future to determine UI
          bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? MyHomePage() : LoginScreen();
        }
      },
    );
  }
}