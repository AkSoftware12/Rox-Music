import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Home/Home%20View%20All/trending_now_view_all.dart';
import '../../Model/recentaly.dart';
import '../../Model/search.dart';
import '../../Service/MusicService.dart';
import '../HomeDeatils/home_deatils_song_list.dart';
import '../HomeDeatils/weekly_forecast_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<SearchScreen> {
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
  List<SearchData> channelData = [
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/03/22/17/28/rings-684944_640.jpg',
      backgroundColor: Colors.blue,
      text: 'Romance',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/02/03/16/52/chain-257490_1280.jpg',
      backgroundColor: Colors.red,
      text: 'EDM',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/08/24/11/04/brain-2676370_640.jpg',
      backgroundColor: Colors.orangeAccent,
      text: 'The College Playlists',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/11/13/06/10/boy-529065_640.jpg',
      backgroundColor: Colors.green,
      text: 'Dance',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/01/12/17/40/padlock-597495_640.jpg',
      backgroundColor: Colors.lime,
      text: 'Workout',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/05/26/07/43/sea-5221913_640.jpg',
      backgroundColor: Colors.pink,
      text: 'The 1990s',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2013/07/25/11/52/rajiv-gandhi-sea-link-166867_640.jpg',
      backgroundColor: Colors.purple,
      text: 'Happy',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/09/08/09/10/rings-7440500_640.jpg',
      backgroundColor: Colors.brown,
      text: 'Best Of 2023',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/07/29/14/34/ballet-1553361_640.jpg',
      backgroundColor: Colors.orange,
      text: 'Chill',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2013/01/29/00/47/search-engine-76519_640.png',
      backgroundColor: Colors.redAccent,
      text: 'Party',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/09/27/19/35/red-3707726_640.jpg',
      backgroundColor: Colors.brown,
      text: 'Best Of 2020',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/04/05/08/22/pair-707508_640.jpg',
      backgroundColor: Colors.blueGrey,
      text: 'Best Of 2021',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/04/05/08/21/heart-707504_640.jpg',
      backgroundColor: Colors.amber,
      text: 'Love',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/07/11/15/08/peacock-2493865_640.jpg',
      backgroundColor: Colors.deepOrange,
      text: 'Best Of 2019',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/05/13/11/01/car-history-free-2309305_640.jpg',
      backgroundColor: Colors.indigo,
      text: 'Hip Hop',
    ),
    SearchData(
      imageUrl:
          'https://cdn.pixabay.com/photo/2012/11/13/17/45/e-mail-65928_640.jpg',
      backgroundColor: Colors.lightGreen,
      text: 'The 2010s',
    ),
  ];

  List<RecentlySongs> filteredItems = [];
  List<SearchData> filteredItems1 = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(recently);
    filteredItems1 = List.from(channelData);
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(recently);
        filteredItems1 = List.from(channelData);
      });
    } else {
      setState(() {
        filteredItems = recently.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();

        filteredItems1 = channelData.where((item) {
          return item.text.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      filteredItems = List.from(recently);
      filteredItems1 = List.from(channelData);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Music Player Saavn',
      home: Scaffold(
        backgroundColor:  Colors.black,

        // backgroundColor: const Color(0xFF222B40),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 40,
              // backgroundColor: const Color(0xFF222B40),
              backgroundColor:  Colors.black,
              onStretchTrigger: () async {
                // await Server.requestNewData();
              },
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 15, right: 15),
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
                titlePadding: EdgeInsets.only(top: 1),
                centerTitle: true,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 50,
                      // Controls the shadow depth
                      // Card elevation
                      child: ListTile(
                        title: SizedBox(
                            child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'its pretty quiet in here.',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              TextSpan(text: '\n'), // Add a line break
                              TextSpan(
                                text: 'You havent searched for anything yet.',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        )),
                        trailing: Container(
                          width: 100,
                          // Set the desired width and height for your round card
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            // Adjust the radius to change the roundness
                            color: Colors.white, // Background color of the card
                          ),
                          child: Center(
                            child: Text(
                              'Surprise Me!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          // GoRouter.of(context).go('/account/details');
                          // context.goNamed("subAccount");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return NotificationScreen();
                          //     },
                          //   ),
                          // );
                        },
                      ), // Margin around the card
                    ),
                  ),

                  SizedBox(
                    height: 50,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                              itemCount: 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0),
                                        child: Text(
                                          'Trending',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 240.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return TrendingNowViewAll();
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'See All',
                                            style: GoogleFonts.poppins(
                                              textStyle:
                                              const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                              }),
                        ),
                      ),
                    ]),
                  ),

                ],
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
                        musicService.playSong(cartItem.url, cartItem.image,
                            cartItem.title, cartItem.subtitle);
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
                                    cartItem.image,
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
                childCount: filteredItems.length,
              )),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 18.0, left: 15.0, right: 15),
                child: Row(
                  children: [
                    SizedBox(
                        height: 20,
                        width: 340,
                        child: Text(
                          'Channel',
                          style: TextStyle(
                            color: Colors.white,
                            // Text color
                            fontSize: 16.0,
                            // Font size
                            fontWeight: FontWeight.bold,
                            // Font weight
                            fontStyle: FontStyle.normal,
                            // Font style
                            fontFamily: 'Roboto', // Custom font family
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.7),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // Define your ratios here as needed
                    List<double> ratios = [1.0, 0.5, 1.5, 0.8];

                    final cartItem = filteredItems1[index];
                                                            // Example ratios
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SongsDeatilsList(
                                  url: cartItem.imageUrl,
                                  image: cartItem.imageUrl,
                                  title: cartItem.text,
                                );
                              },
                            ),
                          );
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
                                    color: cartItem.backgroundColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        cartItem.text,
                                        style: TextStyle(
                                          color: Colors.white,
                                          // Text color
                                          fontSize: 17.0,
                                          // Font size
                                          fontWeight: FontWeight.bold,
                                          // Font weight
                                          fontStyle: FontStyle.normal,
                                          // Font style
                                          fontFamily:
                                              'Roboto', // Custom font family
                                        ),
                                      ),
                                    ),
                                  )),
                              // Overlapping Card
                              Positioned(
                                  top: 40,
                                  left: 25,
                                  right: 25,
                                  child: Transform.rotate(
                                    angle: -8 * (3.141592653589793 / 180),
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
                                              cartItem.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                    ),
                                  )),
                            ],
                          ),
                        ));
                  },
                  childCount: filteredItems1
                      .length, // Replace this with your desired number of children
                ),
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
