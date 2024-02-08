import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Home/My%20PlayList/add_song_list.dart';
import 'package:music_player_saavn/Widget/widgetShuffle.dart';
import 'package:share/share.dart';
import '../../CategoryScreen/category_aritist.dart';
import '../../Model/recentaly.dart';
import '../../Service/MusicService.dart';
import '../../Service/Service.dart';
import '../../Widget/widget.dart';
import '../../Widget/widgetRepeat.dart';

class Player extends StatefulWidget {
  final Function onTap;
  final bool isPlaying;



  Player({super.key,
    required this.onTap, required this.isPlaying,
  });

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  MusicService musicService = MusicService();
  // bool isPlaying = false;
  double currentSliderValue = 0.0;
  bool visible = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _currentSongIndex = 0;
  bool isLiked = false;
  bool download = false;
  bool isSharePopupShown = false;
  bool isRepeat = false;

  List<RecentlySongs> recently = [
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/255/802bd5104b367a501584c9955910168b_96.mp4',
        title: 'Hamein Tumse Hua Pyar',
        subtitle: 'Hamein Tumse Hua Pyar',
        image:
            'https://c.saavncdn.com/255/Ab-Tumhare-Hawale-Watan-Sathiyo-Hindi-2004-20221118021108-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
            'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/905/bb762b053b0704eb6a75be040e208c69_96.mp4',
        title: 'Tujhe Yaad Na Meri Ayee-2',
        subtitle: 'Satish Dehra',
        image:
            'https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title: 'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
            'https://c.saavncdn.com/529/Shiv-Shankara-Hindi-2019-20190228184236-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/318/1feec2b62321a4cbb9b5a29e179768b9_96.mp4',
        title: 'Pehli Pehli Baar Mohabbat Ki Hai',
        subtitle: 'Satish Dehra',
        image:
            'https://c.saavncdn.com/318/Sirf-Tum-Hindi-1999-20221205181935-500x500.jpg'),
    RecentlySongs(
        url:
            "https://aac.saavncdn.com/088/64ec11ed2a357085a5c598b91e18723c_96.mp4",
        title: "Jaan - E - Jigar Jaaneman",
        subtitle: "Shreyas Puranik",
        image:
            "https://c.saavncdn.com/088/Aashiqui-Hindi-1989-20221118014024-500x500.jpg"),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/120/1fa9e474ab4df104cb3deecabd2ec342_96.mp4',
        title: 'Man Mera Mandir,Shiv Meri Puja',
        subtitle: 'Shreyas Puranik',
        image: 'https://c.saavncdn.com/120/Shiv-Aaradhna-1991-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/122/b8bc2c1a0de0010582dfdb33a1f06436_96.mp4',
        title: 'Shiv Amritvaani',
        subtitle: 'Surender Kohli, Anuradha Paudwal',
        image: 'https://c.saavncdn.com/122/Shiv-Amritvani-1999-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/256/f912a4f10ab5505d5f80d7c87cdc23ab_96.mp4',
        title: 'Shree Hanuman Chalisa',
        subtitle: 'Hariharan - Shree Hanuman Chalisa (Hanuman Ashtak)',
        image:
            'https://c.saavncdn.com/256/Shree-Hanuman-Chalisa-Hanuman-Ashtak-Hindi-1992-20230904173628-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/835/4af7820e1519cc777b4bcb6549e23af2_96.mp4',
        title: 'Bajrang Baan',
        subtitle: 'Suresh Wadkar - Hanuman Chalisa',
        image:
            'https://c.saavncdn.com/835/Hanuman-Chalisa-Hindi-2016-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/222/fd095a4516b3a78ee065ea4e391ad39f_96.mp4',
        title: 'Hanuman Aarti',
        subtitle:
            'Anup Jalota - Shree Ram Bhakt Hanuman Chalisa With Transcreation',
        image:
            'https://c.saavncdn.com/222/Shree-Ram-Bhakt-Hanuman-Chalisa-With-Transcreation-Telugu-2016-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/228/d28a57ac4d8bbc4bdc0dba65795c7add_96.mp4',
        title: 'Main Nikla Gaddi Leke',
        subtitle: 'Main Nikla Gaddi Leke',
        image:
            'https://c.saavncdn.com/228/Gadar-Ek-Prem-Katha-Hindi-2001-20230811123918-500x500.jpg'),
    RecentlySongs(
      url:
          "https://aac.saavncdn.com/026/3687b7ddfa714fcd3d7e1a4af95ead4e_96.mp4",
      title: "Chaleya (From \"Jawan\")",
      subtitle: "Chaleya (From \"Jawan\")",
      image:
          "https://c.saavncdn.com/026/Chaleya-From-Jawan-Hindi-2023-20230814014337-500x500.jpg",
    ),
  ];

  void _onShareButtonPressed(BuildContext context) {
    String title = musicService.title;
    String subtitle = musicService.subtitle;
    String url = musicService.url;
    String imagePath = musicService.getImageUrl();

    Share.share(
      '$title\n$subtitle\n $url',
      subject: musicService.title,

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

  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
    });
  }

  @override
  void initState() {
    super.initState();

    // _playSong(_currentSongIndex);

    musicService.getPositionStream().listen((position) {
      setState(() {
        _position = position ?? Duration.zero;
        if (_position >= _duration) {
          // _playNextSong(); // Function to play the next song
        }
      });
    });

    musicService.getDurationStream().listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    musicService.getPositionStream().listen((Duration? position) {
      if (position != null) {
        setState(() {
          currentSliderValue = position.inMilliseconds.toDouble();
        });
      }
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inMinutes}:${twoDigitSeconds}';
  }

  // void togglePlayPause() {
  //   setState(() {
  //     isPlaying = !isPlaying;
  //   });
  // }

  void _onSliderChange(double value) {
    musicService.seekTo(Duration(milliseconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardSize = MediaQuery.of(context).size.height * 0.4;
    return Material(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B1220).withOpacity(0.0),
                    Color(0xFF0B1220).withOpacity(0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                                height: MediaQuery.of(context).padding.top),
                            // Header
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => widget.onTap(),
                                    iconSize: 32,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "PLAYING NOW",
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!
                                              .apply(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     Icons.more_horiz,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  height: cardSize,
                                  width: cardSize,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    // Adjust the value as needed
                                    child: Image.network(
                                      MusicService().getImageUrl(),
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        // Return a placeholder/default image when the network image fails to load
                                        return Image.asset(
                                          'assets/no_image_icons.png',
                                        ); // Replace 'default_image.png' with your default image asset path
                                      },
                                    ),
                                  )

                                  // child:
                                  //     Image.network(MusicService().getImageUrl(),
                                  // ),
                                  ),
                            ),
                            // Music info
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .add_circle_rounded,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return AddSonglistScreen();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.share,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        String title =
                                                            musicService.title;
                                                        String subtitle =
                                                            musicService.title;
                                                        String url =
                                                            musicService.url;

                                                        Share.share(
                                                          '$title\n$subtitle\n $url',
                                                          subject: musicService
                                                              .title,

                                                          sharePositionOrigin:
                                                              Rect.fromCircle(
                                                            center:
                                                                Offset(0, 0),
                                                            radius: 100,
                                                          ),
                                                          // shareRect: Rect.fromCircle(
                                                          //   center: Offset(0, 0),
                                                          //   radius: 100,
                                                          // ),
                                                          // imageUrl: 'file:///$imagePath',
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: IconButton(
                                                      icon: isLiked
                                                          ? Icon(
                                                              Icons.check,
                                                              size: 30,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .download_for_offline,
                                                              size: 30,
                                                            ),
                                                      color: isLiked
                                                          ? Colors.green
                                                          : Colors.grey,
                                                      onPressed: () {
                                                        setState(() {
                                                          isLiked = !isLiked;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: IconButton(
                                                      icon: download
                                                          ? Icon(
                                                              Icons.favorite,
                                                              size: 30,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              size: 30,
                                                            ),
                                                      color: download
                                                          ? Colors.red
                                                          : Colors.grey,
                                                      onPressed: () {
                                                        // if (song.isLiked) {
                                                        //   // Do something when the song is liked
                                                        //   print("Song is liked!");
                                                        // } else {
                                                        //   // Do something when the song is not liked
                                                        //   print("Song is not liked.");
                                                        // }
                                                        setState(() {
                                                          download = !download;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0.0),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        size: 35,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors.white,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              150,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            // Adjust the value as needed
                                                                            child:
                                                                                Image.network(
                                                                              MusicService().getImageUrl(),
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                // Return a placeholder/default image when the network image fails to load
                                                                                return Image.asset(
                                                                                  'assets/no_image_icons.png',
                                                                                ); // Replace 'default_image.png' with your default image asset path
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                8),
                                                                        Text(
                                                                          MusicService()
                                                                              .title,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: textTheme
                                                                              .headline5!
                                                                              .apply(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                          MusicService()
                                                                              .subtitle,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: textTheme
                                                                              .headline6!
                                                                              .apply(color: Colors.grey.withOpacity(0.5)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {},
                                                                              child: Icon(Icons.favorite_border),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            const Padding(
                                                                              padding: EdgeInsets.only(left: 0.0),
                                                                              child: Text(
                                                                                'Like',
                                                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {},
                                                                              child: Icon(Icons.file_download),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              'Download',
                                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {},
                                                                              child: Icon(Icons.thumb_down),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              'Unlike',
                                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {},
                                                                              child: Icon(Icons.info),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              'Details',
                                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 18.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                _onShareButtonPressed(context);
                                                                                // if (!isSharePopupShown) {
                                                                                //   isSharePopupShown = true;
                                                                                //
                                                                                //   await Share.share(
                                                                                //     '$title\n$subtitle\n$url',
                                                                                //
                                                                                // subject: musicService.title,
                                                                                //
                                                                                //   ).whenComplete(() {
                                                                                //     Timer(const Duration(milliseconds: 600), () {
                                                                                //       isSharePopupShown = false;
                                                                                //     });
                                                                                //   });
                                                                                // }
                                                                              },
                                                                              child: Icon(Icons.share),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              'Share',
                                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          16),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            List<RecentlySongs> filteredList = recently
                                                .where((item) => item.subtitle == musicService.subtitle)
                                                .toList();

                                            showModalBottomSheet(
                                              backgroundColor: Colors.grey,
                                              context: context,
                                              builder: (BuildContext context) {
                                                if (filteredList.isEmpty) {
                                                  // Show a message or widget indicating no data found
                                                  return Center(
                                                    child: Text(
                                                      'No data found',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  );
                                                } else {
                                                  // Show the ListView.builder if data is found
                                                  return ListView.builder(
                                                    itemCount: filteredList.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final cartItem = filteredList[index];

                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                          musicService.playSong(
                                                            cartItem.url,
                                                            cartItem.image,
                                                            cartItem.title,
                                                            cartItem.subtitle,
                                                          );
                                                        },
                                                        child: ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundImage: NetworkImage(cartItem.image),
                                                          ),
                                                          title: Text(
                                                            cartItem.title,
                                                            style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 17,
                                                                fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            cartItem.subtitle,
                                                            style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            );

                                          },
                                          child: Text(
                                            MusicService().title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.headline5!.apply(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            List<RecentlySongs> filteredList =
                                                recently
                                                    .where((item) =>
                                                        item.subtitle ==
                                                        musicService.subtitle)
                                                    .toList();
                                            showModalBottomSheet(
                                              backgroundColor: Colors.grey,
                                              context: context,
                                              builder: (BuildContext context) {
                                                if (filteredList.isEmpty) {
                                                  // Show a message or widget indicating no data found
                                                  return Center(
                                                    child: Text(
                                                      'No data found',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  );
                                                } else {
                                                  // Show the ListView.builder if data is found
                                                  return ListView.builder(
                                                    itemCount:
                                                    filteredList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      final cartItem =
                                                      filteredList[index];

                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
                                                          musicService.playSong(
                                                              cartItem.url,
                                                              cartItem.image,
                                                              cartItem.title,
                                                              cartItem.subtitle);
                                                        },
                                                        child: ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                            NetworkImage(
                                                                cartItem.image), // Replace with your image URL
                                                          ),
                                                          title: Text(
                                                            cartItem.title,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle:
                                                              const TextStyle(
                                                                color:
                                                                Colors.white,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                              ),
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            cartItem.subtitle,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle:
                                                              const TextStyle(
                                                                color:
                                                                Colors.white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                      );
                                                    },
                                                  );
                                                }


                                              },
                                            );
                                          },
                                          child: Text(
                                            MusicService().subtitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .apply(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<Duration?>(
                          stream: musicService.getDurationStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              double maxDuration =
                                  snapshot.data!.inMilliseconds.toDouble();
                              return Slider(
                                value: currentSliderValue,
                                min: 0.0,
                                max: maxDuration,
                                onChanged: _onSliderChange,
                                activeColor: Colors.redAccent,
                                inactiveColor: Colors.grey,
                              );
                            } else {
                              return const Slider(
                                value: 0.0,
                                min: 0.0,
                                max: 1.0,
                                onChanged: null,
                                activeColor: Colors.redAccent,
                                inactiveColor: Colors.grey,
                              );
                            }
                          },
                        ), //SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                formatDuration(_position),
                                style: textTheme.bodyText2!.apply(
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                              Text(
                                formatDuration(_duration),
                                style: textTheme.bodyMedium!.apply(
                                    color: Colors.white.withOpacity(0.7)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // IconButton(
                              //   highlightColor: Colors.transparent,
                              //   splashColor: Colors.transparent,
                              //   onPressed: () {
                              //     Switch(
                              //       value: isRepeat,
                              //       onChanged: (value) {
                              //         toggleRepeat();
                              //       },
                              //     );
                              //   },
                              //   icon:
                              //   Icon(isRepeat  ? Icons.repeat_one : Icons.repeat),
                              //
                              // ),

                              RepeatWidget(),
                              IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  // _PreviousNextSong();
                                  // musicService.skipPrevious();
                                  musicService.playPreviousSong();

                                },
                                icon: Icon(Icons.skip_previous,
                                    color: Colors.white),
                              ),
                              // SizedBox(
                              //   width: 50,
                              //   height: 50,
                              //   child: FloatingActionButton(
                              //     backgroundColor: Colors.white,
                              //     onPressed: () {
                              //       musicService.pauseSong();
                              //     },
                              //     child: IconButton(
                              //       icon: Icon(
                              //         isPlaying
                              //             ? Icons.play_arrow
                              //             : Icons.pause,
                              //         size: 32.0,
                              //       ),
                              //       onPressed: () {
                              //         togglePlayPause();
                              //
                              //         if (isPlaying) {
                              //           musicService.pauseSong();
                              //         } else {
                              //           musicService.resumeSong();
                              //         }
                              //       },
                              //     ),
                              //   ),
                              // ),

                             PlayPauseWidget(),
                              IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  // _playNextSong();
                                  musicService.playNextSong();

                                  // musicService.skipNext();
                                  // musicService.playNext();
                                },
                                icon:
                                    Icon(Icons.skip_next, color: Colors.white),
                              ),
                              ShuffleWidget(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
