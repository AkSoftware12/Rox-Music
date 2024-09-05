import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/recentaly.dart';
import '../Service/MusicService.dart';


class HistorySongs extends StatefulWidget {
  const HistorySongs({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<HistorySongs> {

  TextEditingController _searchController = TextEditingController();

  MusicService musicService = MusicService();
  bool isLiked = false;
  bool download = false;

  List<RecentlySongs> recently = [
    RecentlySongs(
        url:
        'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
        'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg', id: ''),
  ];
  List<RecentlySongs> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(recently);
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(recently);
      });
    } else {
      setState(() {
        filteredItems = recently.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredItems = List.from(recently);
    });
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
                                            // musicService.playSong(
                                            //     recently[index].id,
                                            //     recently[index].url,
                                            //     recently[index].image,
                                            //     recently[index].title,
                                            //     recently[index].subtitle);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Music Player Saavn',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: false,
              expandedHeight: 40,
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
              title: Text('History Songs'),


            ),
            SliverToBoxAdapter(
              child:  Padding(
                padding: const EdgeInsets.only(top: 0.0,left: 10,right: 10),
                child: Card(
                  color: Colors.white,
                  elevation: 4, // Controls the shadow depth
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12.0), // Controls corner radius
                  ),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _searchController,
                      onChanged: (value) {
                         filterItems(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () {
                             _clearSearch();
                          },
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: 'Search',
                      ),
                    ),
                  ),

                  // Margin around the card
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {

                        final cartItem = filteredItems[index];
                    return GestureDetector(
                        onTap: () {
                          // musicService.playSong(
                          //     cartItem.id,
                          //     cartItem.url,
                          //     cartItem.image,
                          //     cartItem.title,
                          //     cartItem.subtitle);
                        },
                        child: Card(
                          color: Colors.black,
                          elevation: 5,
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
                                      cartItem.image,
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
                                      Text(cartItem.title.toString()),
                                      SizedBox(height: 10.0),
                                      Text(cartItem.subtitle),
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
                  childCount:  filteredItems.length,

                )
              ),
            ),


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