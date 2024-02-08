import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Model/recentaly.dart';
import '../../Service/MusicService.dart';
import 'package:http/http.dart' as http;

class WeeklyForecastList extends StatefulWidget {
  const WeeklyForecastList({Key? key}) : super(key: key);

  @override
  State<WeeklyForecastList> createState() => _WeeklyForecastListState();
}

class _WeeklyForecastListState extends State<WeeklyForecastList> {
  MusicService musicService = MusicService();
  bool isLiked = false;
  bool download = false;
  List<dynamic> songData = [];


  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://suryavanshifilms.in/api-song'));
    if (response.statusCode == 200) {
      setState(() {
        songData = json.decode(response.body); // Decode the JSON response
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<RecentlySongs> recently = [
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
            'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title: 'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
            'https://c.saavncdn.com/529/Shiv-Shankara-Hindi-2019-20190228184236-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/120/1fa9e474ab4df104cb3deecabd2ec342_96.mp4',
        title: 'Man Mera Mandir,Shiv Meri Puja',
        subtitle: 'Sameer Sen, Dilip Sen, Anuradha Paudwal',
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
            'https://aac.saavncdn.com/905/bb762b053b0704eb6a75be040e208c69_96.mp4',
        title: 'Tujhe Yaad Na Meri Ayee-2',
        subtitle: 'Tujhe Yaad Na Meri Ayee-2',
        image:
            'https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/318/1feec2b62321a4cbb9b5a29e179768b9_96.mp4',
        title: 'Pehli Pehli Baar Mohabbat Ki Hai',
        subtitle: 'Pehli Pehli Baar Mohabbat Ki Hai',
        image:
            'https://c.saavncdn.com/318/Sirf-Tum-Hindi-1999-20221205181935-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/255/802bd5104b367a501584c9955910168b_96.mp4',
        title: 'Hamein Tumse Hua Pyar',
        subtitle: 'Hamein Tumse Hua Pyar',
        image:
            'https://c.saavncdn.com/255/Ab-Tumhare-Hawale-Watan-Sathiyo-Hindi-2004-20221118021108-500x500.jpg'),
    RecentlySongs(
        url:
            'https://aac.saavncdn.com/228/d28a57ac4d8bbc4bdc0dba65795c7add_96.mp4',
        title: 'Main Nikla Gaddi Leke',
        subtitle: 'Main Nikla Gaddi Leke',
        image:
            'https://c.saavncdn.com/228/Gadar-Ek-Prem-Katha-Hindi-2001-20230811123918-500x500.jpg'),
    RecentlySongs(
        url:
            "https://aac.saavncdn.com/088/64ec11ed2a357085a5c598b91e18723c_96.mp4",
        title: "Jaan - E - Jigar Jaaneman",
        subtitle: "Jaan - E - Jigar Jaaneman",
        image:
            "https://c.saavncdn.com/088/Aashiqui-Hindi-1989-20221118014024-500x500.jpg"),
    RecentlySongs(
      url:
          "https://aac.saavncdn.com/026/3687b7ddfa714fcd3d7e1a4af95ead4e_96.mp4",
      title: "Chaleya (From \"Jawan\")",
      subtitle: "Chaleya (From \"Jawan\")",
      image:
          "https://c.saavncdn.com/026/Chaleya-From-Jawan-Hindi-2023-20230814014337-500x500.jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();

  }

  void _openDialog(BuildContext context, int index) {
      showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                SizedBox(
                  height: 420,
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 400.0,
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 12, right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    height: 310,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        bottom: 10,
                                        left: 12,
                                        right: 12),
                                    decoration: BoxDecoration(

                                      color: Color(0xFF222B40),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        // Add your image widget here
                                        SizedBox(
                                          width: 200,
                                          child: Image.network(
                                            '${recently[index].image}',
                                            // Set the width as per your requirement
                                            height: 130,
                                            width: 200,

                                            fit: BoxFit
                                                .fill, // Set the height as per your requirement
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // Adjust the spacing between image and text
                                        Text(
                                          '${recently[index].title}',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Text(
                                          '${recently[index].subtitle}',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            decoration: TextDecoration.none,

                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(top: 18.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              musicService.playSong(
                                                  recently[index].url,
                                                  recently[index].image,
                                                  recently[index].title,
                                                  recently[index].subtitle);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                // Image Icon
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.play_circle,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                ),

                                                // Title
                                                Text(
                                                  'Play Now',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const Divider(
                                          color: Colors.grey,
                                          // You can customize the color
                                          thickness: 1.0,
                                          // You can customize the thickness
                                          height:
                                          20.0, // You can customize the height
                                        ),

                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.music_note_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              'Details',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                                decoration: TextDecoration.none,

                                              ),
                                            ),
                                            Spacer(),
                                            // Adds flexible space between title and trailing
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,size: 25,color: Colors.white,),
                                              onPressed: () {
                                                // Add your onPressed logic here
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();

                                    },
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF222B40),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SizedBox.expand(
                                        child: Center(
                                          child: Text(
                                            'cancel',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   top: 00.0,
                //   left: 110,
                //   child: Image.network(
                //     'https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg',
                //     width: 200.0,
                //     height: 200.0,
                //     fit: BoxFit.cover,
                //   ),
                // ),

              ],
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(
                begin: Offset(0, 1), end: Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
      );
  }
  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          songData.length;
          // apiData.length;
          return GestureDetector(
              onTap: () {
                musicService.playSong(
                    songData[index]['image2'],
                    // recently[index].url,
                    songData[index]['image1'],
                    // recently[index].image,
                    songData[index]['productName'],
                    // recently[index].title,
                    songData[index]['entryDate'],
                    // recently[index].subtitle
                );
              },
              child: Card(
                color: Colors.black,
                elevation: 4,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 70.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                          child: Image.network(
                            // recently[index].image,
                            songData[index]['image1'],
                            width: 200.0, // Adjust the width as needed
                            height: 50.0, // Adjust the height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text( songData[index]['productName']),
                            SizedBox(height: 10.0),
                            Text(songData[index]['entryDate']),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(
                                right: 8.0),
                            child: IconButton(
                              icon: Icon(
                                recently[index].isLiked ? Icons.favorite : Icons.favorite_border,
                                color: recently[index].isLiked ? Colors.red : null,
                              ),
                              onPressed: () {
                                // Toggle the like status when the icon is pressed
                                recently[index].isLiked = !recently[index].isLiked;
                                // Update the UI
                                setState(() {});
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _openDialog(context, index);

                            },
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
        childCount: songData.length,
      ),
    );
  }
}
