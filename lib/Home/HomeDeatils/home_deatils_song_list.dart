import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Home/HomeDeatils/weekly_forecast_list.dart';
import 'package:music_player_saavn/Widget/widgetShuffle.dart';
import 'package:share/share.dart';
import '../../Model/recentaly.dart';
import '../../Model/search.dart';
import '../../Service/MusicService.dart';
import 'package:http/http.dart' as http;


class SongsDeatilsList extends StatefulWidget {
  final String url;
  final String image;
  final String title;
  const SongsDeatilsList({super.key, required this.url, required this.image, required this.title});

  @override
  State<SongsDeatilsList> createState() => _SongsDeatilsListState();
}

class _SongsDeatilsListState extends State<SongsDeatilsList> {
  bool download = false;
  MusicService musicService = MusicService();
  void _onShareButtonPressed(BuildContext context) {
    String title = widget.title;
    String subtitle = widget.image;
    String url = widget.url;
    String imagePath = widget.image;

    Share.share(
      '$title\n$subtitle\n $url',
      subject: widget.title,

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
  void initState() {
    fetchData();
    super.initState();
    setState(() {
      // Navigator.pop(context);

    });

  }

  final List<RecentlySongs> recently = [
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
  final channelData =[
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2015/03/22/17/28/rings-684944_640.jpg', backgroundColor: Colors.blue, text: 'Romance',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2014/02/03/16/52/chain-257490_1280.jpg', backgroundColor: Colors.red, text: 'EDM',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2017/08/24/11/04/brain-2676370_640.jpg', backgroundColor: Colors.orangeAccent, text: 'The College Playlists',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2014/11/13/06/10/boy-529065_640.jpg', backgroundColor: Colors.green, text: 'Dance',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2015/01/12/17/40/padlock-597495_640.jpg', backgroundColor: Colors.lime, text: 'Workout',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2020/05/26/07/43/sea-5221913_640.jpg', backgroundColor: Colors.pink, text: 'The 1990s',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2013/07/25/11/52/rajiv-gandhi-sea-link-166867_640.jpg', backgroundColor: Colors.purple, text: 'Happy',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2022/09/08/09/10/rings-7440500_640.jpg', backgroundColor: Colors.brown, text: 'Best Of 2023',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2016/07/29/14/34/ballet-1553361_640.jpg', backgroundColor: Colors.orange, text: 'Chill',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2013/01/29/00/47/search-engine-76519_640.png', backgroundColor: Colors.redAccent, text: 'Party',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2018/09/27/19/35/red-3707726_640.jpg', backgroundColor: Colors.black, text: 'Best Of 2020',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2015/04/05/08/22/pair-707508_640.jpg', backgroundColor: Colors.blueGrey, text: 'Best Of 2021',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2015/04/05/08/21/heart-707504_640.jpg', backgroundColor: Colors.amber, text: 'Love',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2017/07/11/15/08/peacock-2493865_640.jpg', backgroundColor: Colors.deepOrange, text: 'Best Of 2019',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2017/05/13/11/01/car-history-free-2309305_640.jpg', backgroundColor: Colors.indigo, text: 'Hip Hop',),
    SearchData(imageUrl: 'https://cdn.pixabay.com/photo/2012/11/13/17/45/e-mail-65928_640.jpg', backgroundColor: Colors.lightGreen, text: 'The 2010s',),
  ];
  bool backButtonLocked = false;




  void _openDialog(BuildContext context, String title,String image,String url) {
      showModalBottomSheet(
        backgroundColor:  Color(0xFF222B40),

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
                           image,
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
                        title,
                        maxLines:
                        1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          decoration: TextDecoration.none,
                        ),

                      ),
                      SizedBox(
                          height:
                          5),
                      Text(
                       'subtitle',
                        maxLines:
                        1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          decoration: TextDecoration.none,
                        ),

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
                            onTap: () {

                            },
                            child: Icon(Icons.favorite_border,color: Colors.white,),
                          ),
                          SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              'Like',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
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
                            onTap: () {

                            },
                            child: Icon(Icons.file_download,color: Colors.white,),
                          ),
                          SizedBox(width: 8),
                          Text('Download',  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
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
                            onTap: () {

                            },
                            child: Icon(Icons.thumb_down,color: Colors.white,),
                          ),
                          SizedBox(width: 8),
                          Text('Unlike',    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
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
                            onTap: () {

                            },
                            child: Icon(Icons.info,color: Colors.white,),
                          ),
                          SizedBox(width: 8),
                          Text('Details',  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
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
                            onTap: () {
                              _onShareButtonPressed(context);

                            },
                            child: Icon(Icons.share,color: Colors.white,),
                          ),
                          SizedBox(width: 8),
                          Text('Share',   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
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

  }


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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardSize = MediaQuery.of(context).size.height * 0.4;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [

            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 280,
              backgroundColor: Colors.black,
              onStretchTrigger: () async {
                log('Load new data!');
                // await Server.requestNewData();
              },
              leading: IconButton(
                icon: Icon(Icons.arrow_circle_left_outlined,color: Colors.white,size: 40,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                title:  Text(widget.title),
                centerTitle: false,
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: <Color>[
                        Colors.black,
                        // Colors.teal[800]!,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  // child: Image.network(
                  //   widget.image,
                  //   fit: BoxFit.cover,
                  // ),

                  child: Image.network(widget.image,fit: BoxFit.fill,),
                ),
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
                  Container(
                      height: 170,
                      color:  Colors.black,
                    child: Column(
                      children: [
                         Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title.toString(),
                                  style: TextStyle(fontSize: 15),
                                ),

                              ],
                            )

                        ),
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Rox Music',
                                style: TextStyle(fontSize: 15),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: 20,
                                    height: 20,
                                    child: Image.asset('assets/rox.png')),
                              ),                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text(
                              //   'liks',
                              //   style: TextStyle(fontSize: 15),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.only(right: 8.0),
                                  //   child: IconButton(
                                  //     icon: Icon(Icons.add_circle_rounded,size: 35,color: Colors.white,),
                                  //     onPressed: () {
                                  //       // End button functionality
                                  //       print('End button pressed');
                                  //     },
                                  //   ),
                                  // ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        right: 8.0),
                                    child: IconButton(
                                      icon: download
                                          ? Icon(
                                        Icons.check,
                                        size: 35,
                                      )
                                          : Icon(
                                        Icons
                                            .download_for_offline,
                                        size: 35,
                                      ),
                                      color: download
                                          ? Colors.green
                                          : Colors.grey,
                                      onPressed: () {
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
                                        Icons.share,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _onShareButtonPressed(context);

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

                                        // _openDialog(context, widget.title,widget.image,widget.url,);

                                      },
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                 ShuffleWidget(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                      icon: Icon(Icons.play_circle,size: 40,color: Colors.orangeAccent,),
                                      onPressed: ()  async {

                                        // musicService.playSonglist(recently.first)





                                      }

                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),
                        )
                      ],
                    ),


                  ),


                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final cartItem = songData[index];
                      return GestureDetector(
                          onTap: () {
                            musicService.playSong(cartItem['image2'], cartItem['image1'],
                                cartItem['productName'], cartItem['entryDate']);
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
                                        cartItem['image1'],
                                        width: 200.0,
                                        // Adjust the width as needed
                                        height: 50.0,
                                        // Adjust the height as needed
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
                                        Text(cartItem['productName']),
                                        SizedBox(height: 10.0),
                                        Text(cartItem['entryDate']),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          icon: Icon(
                                            recently[index].isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: recently[index].isLiked
                                                ? Colors.red
                                                : null,
                                          ),
                                          onPressed: () {
                                            // Toggle the like status when the icon is pressed
                                            recently[index].isLiked =
                                            !recently[index].isLiked;
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
                                          // _openDialog(context, index);
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
                  )),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You might also like',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.7
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    // Define your ratios here as needed
                    List<double> ratios = [1.0, 0.5, 1.5, 0.8]; // Example ratios
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SongsDeatilsList(
                                  url: channelData[index].imageUrl,
                                  image: channelData[index].imageUrl,
                                  title: channelData[index].text,);
                              },
                            ),
                          );


                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return PlayerScreen(url: recently[index].url, image: recently[index].image, title: recently[index].title,);
                          //     },
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Stack(
                            children: [
                              // Background Image
                              Container(
                                  width: 300,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: channelData[index].backgroundColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),

                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text( channelData[index].text,style: TextStyle(
                                        color: Colors.white,
                                        // Text color
                                        fontSize: 17.0,
                                        // Font size
                                        fontWeight: FontWeight.bold,
                                        // Font weight
                                        fontStyle: FontStyle.normal,
                                        // Font style
                                        fontFamily: 'Roboto', // Custom font family
                                      ),),
                                    ),
                                  )


                              ),
                              // Overlapping Card
                              Positioned(
                                  top: 40,
                                  left: 25,
                                  right: 25,

                                  child: Transform.rotate(
                                    angle:-8 * (3.141592653589793 / 180),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                          width: 200,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            // borderRadius: BorderRadius.circular(10.0),
                                          ),

                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            child: Image.network(
                                              channelData[index].imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      ),

                                    ),)
                              ),
                            ],

                          ),
                        )
                    );

                  },
                  childCount: channelData.length, // Replace this with your desired number of children
                ),
              ),
            ),

            // SliverPadding(
            //   padding:  EdgeInsets.only(top: 0,left: 10,right: 10),
            //   sliver: SliverGrid(
            //     delegate: SliverChildBuilderDelegate(
            //           (context, index) =>
            //               GestureDetector(
            //                 onTap: () {
            //
            //                   Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                       builder: (context) {
            //                         return SongsDeatilsList(
            //                           url: channelData[index].imageUrl,
            //                           image: channelData[index].imageUrl,
            //                           title: channelData[index].text,);
            //                       },
            //                     ),
            //                   );
            //
            //                   // Navigator.push(
            //                   //   context,
            //                   //   MaterialPageRoute(
            //                   //     builder: (context) {
            //                   //       return MusicApp(url: 'recently[index].url', image: 'recently[index].image', title:' recently[index].title',);
            //                   //     },
            //                   //   ),
            //                   // );
            //
            //
            //                   // Navigator.push(
            //                   //   context,
            //                   //   MaterialPageRoute(
            //                   //     builder: (context) {
            //                   //       return PlayerScreen(url: recently[index].url, image: recently[index].image, title: recently[index].title,);
            //                   //     },
            //                   //   ),
            //                   // );
            //                 },
            //
            //
            //                 child: Column(
            //             children: [
            //               SizedBox(
            //                 height: 170,
            //                 child: Card(
            //                   color:Colors.white,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            //                     child: Image.network(
            //                       'https://cdn.pixabay.com/photo/2015/03/22/17/28/rings-684944_640.jpg',
            //                       fit: BoxFit.fill,
            //                     ),
            //                   ),
            //
            //                   // child: Column(
            //                   //   children: [
            //                   //
            //                   //     Text('title'),
            //                   //     Text('subtitle')
            //                   //
            //                   //   ],
            //                   // ),
            //                 ),
            //               ),
            //
            //               Text('title'),
            //            Text('subtitle')
            //             ],
            //           ),
            //     ),
            //       childCount: 6,
            //     ),
            //
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //     ),
            //   ),
            // ),
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