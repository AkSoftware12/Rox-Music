import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_saavn/Demo/demo.dart';
import 'package:music_player_saavn/Home/Home%20View%20All/trending_now_view_all.dart';
import 'package:music_player_saavn/Service/service.dart';
import '../../Model/search.dart';
import '../Drawer/drawer.dart';
import '../Home/Home Screen/home_screen.dart';
import '../Home/Home View All/Music viewAll/Top_song_view_all.dart';
import '../Home/Home View All/Music viewAll/bollywood_song_view_all.dart';
import '../Home/Home View All/Music viewAll/haryanvi_song_view_all.dart';
import '../Home/Home View All/Music viewAll/punjabi_song_view_all.dart';
import '../Home/Home View All/Music viewAll/trending_song_view_all.dart';
import '../Home/Home View All/bollywood_masala_view_all.dart';
import '../Home/Home View All/new_releaees_view_all.dart';
import '../Home/Home View All/recently_songs.dart';
import '../Home/Home View All/top_chart_view_all.dart';
import '../Home/HomeDeatils/home_deatils_song_list.dart';
import '../Home/HomeDeatils/weekly_forecast_list.dart';
import '../Model/Music/bollywood_songs.dart';
import '../Model/Music/haryanvi.dart';
import '../Model/Music/punjabi.dart';
import '../Model/Music/top_hind_songs.dart';
import '../Model/Music/trendings_songs.dart';
import '../Model/Podcasts/trending_podcasts.dart';
import '../Model/artist.dart';
import '../Model/last.dart';
import '../Model/new_releasse.dart';
import '../Model/recentaly.dart';
import '../Model/top_charts.dart';
import '../Model/trending.dart';
import '../Seetings/settings.dart';
import '../Service/MusicService.dart';
import 'Core/app_globals.dart';

class AkScreen extends StatefulWidget {
  const AkScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<AkScreen> with SingleTickerProviderStateMixin {
  MusicService musicService = MusicService();
  TabController? _tabController;
  bool isDrawerOpen = false;

  bool isLiked = false;
  bool download = false;
  int selectIndex = 0;
  String searchQuery = '';

  // Home All List model class
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
        subtitle: 'Tujhe Yaad Na Meri Ayee-2',
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
        subtitle: 'Pehli Pehli Baar Mohabbat Ki Hai',
        image:
            'https://c.saavncdn.com/318/Sirf-Tum-Hindi-1999-20221205181935-500x500.jpg'),
    RecentlySongs(
        url:
            "https://aac.saavncdn.com/088/64ec11ed2a357085a5c598b91e18723c_96.mp4",
        title: "Jaan - E - Jigar Jaaneman",
        subtitle: "Jaan - E - Jigar Jaaneman",
        image:
            "https://c.saavncdn.com/088/Aashiqui-Hindi-1989-20221118014024-500x500.jpg"),
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
  List<LastSongs> lastSongs = [
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://f4.bcbits.com/img/a0029673845_16.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: 'https://f4.bcbits.com/img/a3819056082_16.jpg'),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://f4.bcbits.com/img/a2487127244_16.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: 'https://f4.bcbits.com/img/a4090357764_16.jpg'),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://f4.bcbits.com/img/a4251419452_16.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image:
            'https://c.saavncdn.com/256/Shree-Hanuman-Chalisa-Hanuman-Ashtak-Hindi-1992-20230904173628-500x500.jpg'),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg"),
    LastSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image:
            'https://c.saavncdn.com/256/Shree-Hanuman-Chalisa-Hanuman-Ashtak-Hindi-1992-20230904173628-500x500.jpg'),
  ];
  List<ArtistSongs> artistSongs = [
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Hansraj',
        image:
            "https://c.saavncdn.com/artists/Hansraj_Raghuwanshi_001_20220916054832_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Arijit Singh',
        image:
            "https://c.saavncdn.com/artists/Arijit_Singh_002_20230323062147_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Neha Kakkar',
        image:
            "https://c.saavncdn.com/artists/Neha_Kakkar_006_20200822042626_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Badshah',
        image:
            "https://c.saavncdn.com/artists/Badshah_005_20230608084021_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Lata Mangeshkar',
        image:
            "https://c.saavncdn.com/artists/Lata_Mangeshkar_004_20230623105323_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Sonu Nigam',
        image: "https://c.saavncdn.com/artists/Sonu_Nigam_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Himesh Reshammiya',
        image: "https://c.saavncdn.com/artists/Himesh_Reshammiya_500x500.jpg"),
    ArtistSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Alia Bhatt',
        image: "https://c.saavncdn.com/artists/Alia_Bhatt_500x500.jpg"),
  ];
  List<TrendingSongs> trendingSongs = [
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Only Khushiyaan',
        image:
            "https://c.saavncdn.com/editorial/OnlyKhushiyaan_20231117032829.jpg?bch=1702977020"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Mahalaxmi Mantra',
        image:
            "https://c.saavncdn.com/153/Mahalaxmi-Mantra-Hindi-2005-20230508104311-500x500.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Jawan',
        image:
            "https://c.saavncdn.com/047/Jawan-Hindi-2023-20230921190854-500x500.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Aashiqon ki Mehfil',
        image:
            "https://c.saavncdn.com/843/Aashiqon-ki-Mehfil-Hindi-2023-20231208123453-500x500.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Starfish',
        image:
            "https://c.saavncdn.com/115/Starfish-Hindi-2023-20231122161004-500x500.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Kho Gaye Hum Kahan',
        image:
            "https://c.saavncdn.com/773/Kho-Gaye-Hum-Kahan-Hindi-2023-20231208120916-500x500.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'ANIMAL',
        image:
            "https://c.saavncdn.com/092/ANIMAL-Hindi-2023-20231124191036-500x500.jpg"),
    TrendingSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Farrey',
        image:
            "https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg"),
  ];
  List<TopChartSongs> topchartSongs = [
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Superhits Top 50',
        image:
            "https://c.saavncdn.com/editorial/Hindi-IndiaSuperhitsTop50_20231201043314.jpg?bch=1702628462"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Charts Trending Today',
        image:
            "https://c.saavncdn.com/editorial/charts_TrendingToday_134351_20230826113717.jpg?bch=1696856401"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'CHARTS SAAVN',
        image:
            "http://c.saavncdn.com/editorial/charts_CHARTS_SAAVN_hindi_2000s_139784_20230711094322.jpg?bch=1696867250"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Delhi Hot 50',
        image:
            "https://c.saavncdn.com/editorial/charts_DelhiHot50_151698_20220311195731.jpg?bch=1502438867"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'India Superhits Top 50',
        image:
            "https://c.saavncdn.com/editorial/IndiaSuperhitsTop50_20231201053857.jpg?bch=1702623930"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Romantic Top 40',
        image:
            "https://c.saavncdn.com/editorial/charts_RomanticTop40_167985_20220311173413.jpg?bch=1696856401"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Hindi 1990s',
        image:
            "https://c.saavncdn.com/editorial/charts_CHARTS_SAAVN_hindi_1990s_175982_20230711094900.jpg?bch=1696867249"),
    TopChartSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Hindi 1970s',
        image:
            "https://c.saavncdn.com/editorial/charts_Hindi1970s_180599_20230713045713.jpg?bch=1696867248")
  ];
  List<NewReleasseSongs> newReleasseSongs = [
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Pakeezah',
        image:
            "https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Pyaar Hai Toh Hai',
        image:
            "https://c.saavncdn.com/781/Pyaar-Hai-Toh-Hai-Hindi-2023-20231027235523-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Barse Re From Manush',
        image:
            "https://c.saavncdn.com/057/Barse-Re-From-Manush-Hindi-Hindi-2023-20231113122507-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Pippa',
        image:
            "https://c.saavncdn.com/172/Pippa-Hindi-2023-20231113184331-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Farrey',
        image:
            "https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Tiger 3',
        image:
            "https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'Ishq Nahi Aasan',
        image:
            "https://c.saavncdn.com/216/Ishq-Nahi-Aasan-From-Anari-Is-Backk-Hindi-2023-20231207111403-500x500.jpg"),
    NewReleasseSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'The Archies',
        image:
            "https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg")
  ];

  // Music model class
  List<BollywoodSongs> bollywoodSongs = [
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image: 'https://wallpapercave.com/wp/wp5510430.jpg'),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://media.timeout.com/images/102136087/image.jpg"),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            'https://img.mensxp.com/media/content/2020/Jun/Bollywood-Songs-Shot-In-Royal-Palaces1200_5ef079279d525.jpeg'),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image:
            'https://i.scdn.co/image/ab67616d0000b27399dcaf80953b083cc7139a5f'),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://www.saregama.com/blog/wp-content/uploads/2021/04/Evolution-of-Bollywood-Song-Lyrics-1200x675.jpg"),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            'https://images.news18.com/ibnlive/uploads/2022/03/gulabi-song-1.jpg'),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "https://i.ytimg.com/vi/IYDm2KWDHo4/maxresdefault.jpg"),
    BollywoodSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://i0.wp.com/www.awaradiaries.com/wp-content/uploads/2018/07/Filimg-Locations-of-Top-Bollywood-Songs.jpg?fit=1200%2C800&ssl=1"),
  ];
  List<TrendingsSongs> trendingsSongs = [
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://blog.byoh.in/wp-content/uploads/2016/04/Romantic-Bollywood-Songs.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://stat5.bollywoodhungama.in/wp-content/uploads/2016/04/99-Songs-3-306x393.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://browngirlmagazine.com/wp-content/uploads/2018/01/Rab-Ne-Bana-Di-Jodi-Bollywood-Songs.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://img.mensxp.com/media/content/2019/Apr/bollywood-songs-which-turn-10-years-old-in-20191200-1555074788.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://images.herzindagi.info/image/2022/Apr/early-2000s-songs-main.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/shiv4.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa1.jpg"),
    TrendingsSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image: "assets/maa2.jpg"),
  ];
  List<PunjabiSongs> punjabiSongs = [
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image: 'https://f4.bcbits.com/img/a1452248449_16.jpg'),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/4899f7183645667.Y3JvcCwyNjkyLDIxMDUsOTksMjI2.jpg"),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            'https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/5eac77186141461.Y3JvcCwxMjI4LDk2MSwxMzYsMA.jpg'),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: "B Praak, Jaani, Jatin-Lalit - Tujhe Yaad Na Meri Ayee-2",
        image:
            'https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/1e9703186308903.Y3JvcCwxMDgwLDg0NCwwLDExNw.jpg'),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/1a689c186046727.656eb6b4d6763.jpg"),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            'https://t4.ftcdn.net/jpg/04/73/45/75/240_F_473457554_c79tvqr3digVdHHOSZAtVvfefvjPjkla.jpg'),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            'https://t3.ftcdn.net/jpg/03/99/89/10/240_F_399891068_HnVlhQGTT6N4vWGCW8U8NSSB0nHWAqII.jpg'),
    PunjabiSongs(
        url:
            'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
        title: 'title',
        image:
            "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/68115a180336939.Y3JvcCw4MDgsNjMyLDE1OCww.jpg"),
  ];
  List<HaryanviSongs> haryanviSongs = [
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
            'https://c.saavncdn.com/editorial/logo/DanceHits2021Haryanvi_20211206180419.jpg?bch=1698158461'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title: 'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
            'https://c.saavncdn.com/059/Loot-Liya-Haryanvi-2021-20210313013657-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/120/1fa9e474ab4df104cb3deecabd2ec342_96.mp4',
        title: 'Man Mera Mandir,Shiv Meri Puja',
        subtitle: 'Sameer Sen, Dilip Sen, Anuradha Paudwal',
        image:
            'https://c.saavncdn.com/635/Ghungroo-Hindi-2021-20210414141141-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/122/b8bc2c1a0de0010582dfdb33a1f06436_96.mp4',
        title: 'Shiv Amritvaani',
        subtitle: 'Surender Kohli, Anuradha Paudwal',
        image:
            'https://c.saavncdn.com/069/Badnam-Gabru-Haryanvi-2021-20210218144354-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/256/f912a4f10ab5505d5f80d7c87cdc23ab_96.mp4',
        title: 'Shree Hanuman Chalisa',
        subtitle: 'Hariharan - Shree Hanuman Chalisa (Hanuman Ashtak)',
        image:
            'https://c.saavncdn.com/385/Heavy-Ghaghra-Haryanvi-2021-20210927204233-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/835/4af7820e1519cc777b4bcb6549e23af2_96.mp4',
        title: 'Bajrang Baan',
        subtitle: 'Suresh Wadkar - Hanuman Chalisa',
        image:
            'https://c.saavncdn.com/785/Naam-Tera-Haryanvi-2021-20210821045947-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/222/fd095a4516b3a78ee065ea4e391ad39f_96.mp4',
        title: 'Hanuman Aarti',
        subtitle:
            'Anup Jalota - Shree Ram Bhakt Hanuman Chalisa With Transcreation',
        image:
            'https://c.saavncdn.com/978/Bp-High-Hindi-2021-20210323133538-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/905/bb762b053b0704eb6a75be040e208c69_96.mp4',
        title: 'Tujhe Yaad Na Meri Ayee-2',
        subtitle: 'Tujhe Yaad Na Meri Ayee-2',
        image:
            'https://c.saavncdn.com/977/Superman-Jat-Punjabi-2021-20231007154044-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/318/1feec2b62321a4cbb9b5a29e179768b9_96.mp4',
        title: 'Pehli Pehli Baar Mohabbat Ki Hai',
        subtitle: 'Pehli Pehli Baar Mohabbat Ki Hai',
        image:
            'https://c.saavncdn.com/020/Sulfa-Punjabi-2020-20200525134614-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/255/802bd5104b367a501584c9955910168b_96.mp4',
        title: 'Hamein Tumse Hua Pyar',
        subtitle: 'Hamein Tumse Hua Pyar',
        image:
            'https://c.saavncdn.com/001/Chatak-Matak-Haryanvi-2020-20201221105140-500x500.jpg'),
    HaryanviSongs(
        url:
            'https://aac.saavncdn.com/228/d28a57ac4d8bbc4bdc0dba65795c7add_96.mp4',
        title: 'Main Nikla Gaddi Leke',
        subtitle: 'Main Nikla Gaddi Leke',
        image:
            'https://c.saavncdn.com/175/Gajban-Hindi-2021-20231007134158-500x500.jpg'),
    HaryanviSongs(
        url:
            "https://aac.saavncdn.com/088/64ec11ed2a357085a5c598b91e18723c_96.mp4",
        title: "Jaan - E - Jigar Jaaneman",
        subtitle: "Jaan - E - Jigar Jaaneman",
        image:
            "https://c.saavncdn.com/592/Kamar-Teri-Left-Right-Hale-Haryanvi-2022-20220414144503-500x500.jpg"),
    HaryanviSongs(
      url:
          "https://aac.saavncdn.com/026/3687b7ddfa714fcd3d7e1a4af95ead4e_96.mp4",
      title: "Chaleya (From \"Jawan\")",
      subtitle: "Chaleya (From \"Jawan\")",
      image:
          "https://c.saavncdn.com/111/4-G-Ka-Jamana-Single-Hindi-2019-20190617084107-500x500.jpg",
    ),
  ];
  List<TopHindiSongs> tophindiSongs = [
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/113/6618ccbc327d1f238da8de775e07a693_96.mp4',
        title: 'He Shiv Shankar',
        subtitle: 'Satish Dehra',
        image:
            'https://c.saavncdn.com/590/Wajah-Tum-Ho-Hindi-2016-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/529/34fec258d486adfae4d5faf460e6b519_96.mp4',
        title: 'Shiv Shankara',
        subtitle: 'Shreyas Puranik',
        image:
            'https://c.saavncdn.com/blob/461/Saajan-Hindi-1991-20220616044407-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/120/1fa9e474ab4df104cb3deecabd2ec342_96.mp4',
        title: 'Man Mera Mandir,Shiv Meri Puja',
        subtitle: 'Sameer Sen, Dilip Sen, Anuradha Paudwal',
        image: 'https://c.saavncdn.com/430/Aashiqui-2-Hindi-2013-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/122/b8bc2c1a0de0010582dfdb33a1f06436_96.mp4',
        title: 'Shiv Amritvaani',
        subtitle: 'Surender Kohli, Anuradha Paudwal',
        image:
            'https://c.saavncdn.com/088/Aashiqui-Hindi-1989-20221118014024-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/256/f912a4f10ab5505d5f80d7c87cdc23ab_96.mp4',
        title: 'Shree Hanuman Chalisa',
        subtitle: 'Hariharan - Shree Hanuman Chalisa (Hanuman Ashtak)',
        image:
            'https://c.saavncdn.com/807/Pathaan-Hindi-2022-20221222104158-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/835/4af7820e1519cc777b4bcb6549e23af2_96.mp4',
        title: 'Bajrang Baan',
        subtitle: 'Suresh Wadkar - Hanuman Chalisa',
        image:
            'https://c.saavncdn.com/734/Champagne-Talk-Hindi-2022-20221008011951-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/222/fd095a4516b3a78ee065ea4e391ad39f_96.mp4',
        title: 'Hanuman Aarti',
        subtitle:
            'Anup Jalota - Shree Ram Bhakt Hanuman Chalisa With Transcreation',
        image:
            'https://c.saavncdn.com/807/Kabir-Singh-Hindi-2019-20190614075009-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/905/bb762b053b0704eb6a75be040e208c69_96.mp4',
        title: 'Tujhe Yaad Na Meri Ayee-2',
        subtitle: 'Tujhe Yaad Na Meri Ayee-2',
        image:
            'https://c.saavncdn.com/348/Kisi-Ka-Bhai-Kisi-Ki-Jaan-Hindi-2023-20230427184704-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/318/1feec2b62321a4cbb9b5a29e179768b9_96.mp4',
        title: 'Pehli Pehli Baar Mohabbat Ki Hai',
        subtitle: 'Pehli Pehli Baar Mohabbat Ki Hai',
        image:
            'https://c.saavncdn.com/238/Shershaah-Original-Motion-Picture-Soundtrack--Hindi-2021-20210815181610-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/255/802bd5104b367a501584c9955910168b_96.mp4',
        title: 'Hamein Tumse Hua Pyar',
        subtitle: 'Hamein Tumse Hua Pyar',
        image:
            'https://c.saavncdn.com/001/Chatak-Matak-Haryanvi-2020-20201221105140-500x500.jpg'),
    TopHindiSongs(
        url:
            'https://aac.saavncdn.com/228/d28a57ac4d8bbc4bdc0dba65795c7add_96.mp4',
        title: 'Main Nikla Gaddi Leke',
        subtitle: 'Main Nikla Gaddi Leke',
        image:
            'https://c.saavncdn.com/175/Gajban-Hindi-2021-20231007134158-500x500.jpg'),
    TopHindiSongs(
        url:
            "https://aac.saavncdn.com/088/64ec11ed2a357085a5c598b91e18723c_96.mp4",
        title: "Jaan - E - Jigar Jaaneman",
        subtitle: "Jaan - E - Jigar Jaaneman",
        image:
            "https://c.saavncdn.com/592/Kamar-Teri-Left-Right-Hale-Haryanvi-2022-20220414144503-500x500.jpg"),
    TopHindiSongs(
      url:
          "https://aac.saavncdn.com/026/3687b7ddfa714fcd3d7e1a4af95ead4e_96.mp4",
      title: "Chaleya (From \"Jawan\")",
      subtitle: "Chaleya (From \"Jawan\")",
      image:
          "https://c.saavncdn.com/111/4-G-Ka-Jamana-Single-Hindi-2019-20190617084107-500x500.jpg",
    ),
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this); // Adjust the length based on the number of tabs you want
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Existing MaterialApp code...
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          // backgroundColor: const Color(0xFF222B40),
          backgroundColor:  Colors.black,

          // Existing Scaffold code...
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
                        const EdgeInsets.only(top: 45.0, left: 10, right: 15),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: SizedBox(
                              width: 50,
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          'https://c.saavncdn.com/113/He-Shiv-Shankar-Hindi-2020-20200214121917-500x500.jpg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                //This is for background color
                                color: Colors.white.withOpacity(0.0),
                                //This is for bottom border that is needed
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                child: TabBar(
                                  dividerColor: Colors.transparent,
                                  onTap: (index) {
                                    setState(() {
                                      selectIndex = index;
                                    });
                                  },
                                  labelPadding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  indicator: BoxDecoration(),
                                  controller: _tabController,
                                  tabs: [
                                    selectIndex != 0
                                        ? const Text(
                                            '$upComing ',
                                            style: TextStyle(
                                                color: gWhite, fontSize: 18),
                                          )
                                        : Container(
                                            width: 130,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: const Color(0xffe9e9e9)),
                                              color: Colors.orange,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '$upComing',
                                                style: TextStyle(
                                                    color: gBlack,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                    selectIndex != 1
                                        ? const Text(
                                            '$inProgress',
                                            style: TextStyle(
                                                color: gWhite, fontSize: 18),
                                          )
                                        : Container(
                                            width: 130,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: const Color(0xffe9e9e9)),
                                              color: Colors.orange,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '$inProgress',
                                                style: TextStyle(
                                                    color: gBlack,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Container(
                              constraints: BoxConstraints.expand(height: 90),
                              // Height of the tab bar
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Container(
                              constraints: BoxConstraints.expand(height: 90),
                              // Height of the tab bar
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SettingScreen();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Contents of Tab 1
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          //  recently view all
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
                                                  'Recently Songs',
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
                                                    left: 190.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return RecentlySongsClass();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // recntly list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                            onTap: () async {
                                              // _playSong(recently[index].toString());

                                              // _playSong(recently[index] as int);
                                              // musicService.songPlay(recently);

                                              musicService.playSong(
                                                  recently[index].url,
                                                  recently[index].image,
                                                  recently[index].title,
                                                  recently[index].subtitle);
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            // child: Image.network(
                                                            //   songs[index].metas.image!.path,
                                                            //   fit: BoxFit.fill,
                                                            // ),

                                                            child:
                                                                Image.network(
                                                              recently[index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    recently[index].title,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                          recently[index]
                                                              .subtitle,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                  ),
                                ),
                              ),
                            ]),
                          ),


                          // trending view all
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
                                                  'Trending Now',
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
                                                    left: 195.0),
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
                                                    'View All',
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
                          // trending list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = trendingSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                            Image.network(
                                                              trendingSongs[
                                                              index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  cartItem.title,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                      GoogleFonts.poppins(
                                                        textStyle:
                                                        const TextStyle(
                                                            color:
                                                            Colors.grey,
                                                            fontSize: 11,
                                                            fontWeight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),

                          //  bollywood view all
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
                                                  'BollyWood Masala',
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
                                                    left: 185.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return BollywoodMasala();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // bollywood list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = lastSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return SongsDeatilsList();
                                              //     },
                                              //   ),
                                              // );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              lastSongs[index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  'Mei Ho Ja',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),

                          // Artist Stations list
                          SizedBox(
                            height: 290,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  top: 20,
                                ),
                                child: Column(children: [
                                  Row(children: [
                                    Text(
                                      'Recommennded Artist Stations',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 220,
                                  child: ListView.builder(
                                      itemCount: artistSongs.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = artistSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Card(
                                                        color: Colors.grey,
                                                        elevation: 4.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  100.0), // Adjust the value as needed
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: const SizedBox(
                                                          height: 160,
                                                          width: 160,
                                                          child: Column(
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 5.0,
                                                                  top: 10,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Center(
                                                      child: Card(
                                                          elevation: 4.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0), // Adjust the value as needed
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: SizedBox(
                                                            height: 140,
                                                            width: 140,
                                                            child: Column(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 0.0,
                                                                    top: 0,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            0.0),

                                                                    child:
                                                                        ClipOval(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            140.0,
                                                                        // Adjust the width and height as needed
                                                                        height:
                                                                            140.0,
                                                                        color: Colors
                                                                            .blue,
                                                                        // Background color of the circular container
                                                                        child: Image.network(
                                                                            artistSongs[index].image),
                                                                      ),
                                                                    ),
                                                                    // child: SizedBox(
                                                                    //   height: 130,
                                                                    //   width: 130,
                                                                    //   child: Image.asset("assets/Kumar_sanu.jpg"),
                                                                    //
                                                                    //   // child: Image.network(
                                                                    //   //   mapResponse1['base_url'] +
                                                                    //   //       listResponse1[index]['photo'],
                                                                    //   //
                                                                    //   // )
                                                                    // ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  cartItem.title,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Artist Radio',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),



                          // top charts view all
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
                                                  'Top Charts',
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
                                                    left: 225.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return TopChartViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // top charts list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: topchartSongs.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = topchartSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              topchartSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  cartItem.title,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),

                          // new releasse view all
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
                                                  'New Releasse',
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
                                                    left: 195.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return NewReleasseViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // new releasse list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem =
                                            newReleasseSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              newReleasseSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  cartItem.title,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),

                    // Contents of Tab 2
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          //  recently view all
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
                                                  'Punjabi Songs',
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
                                                    left: 190.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return PunjabiViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // recntly list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                            onTap: () async {
                                              // _playSong(recently[index].toString());

                                              // _playSong(recently[index] as int);
                                              // musicService.songPlay(recently);

                                              musicService.playSong(
                                                  recently[index].url,
                                                  recently[index].image,
                                                  recently[index].title,
                                                  recently[index].subtitle);
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            // child: Image.network(
                                                            //   songs[index].metas.image!.path,
                                                            //   fit: BoxFit.fill,
                                                            // ),

                                                            child:
                                                                Image.network(
                                                              punjabiSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    punjabiSongs[index].title,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                          punjabiSongs[index]
                                                              .title,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                  ),
                                ),
                              ),
                            ]),
                          ),

                          //  bollywood view all
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
                                                  'BollyWood Songs',
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
                                                    left: 185.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return BollywoodSongsViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // bollywood list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = lastSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return SongsDeatilsList();
                                              //     },
                                              //   ),
                                              // );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              bollywoodSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  'Mei Ho Ja',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
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
                                                  'Trending Songs',
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
                                                    left: 195.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return TrendingSongsViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // trending list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = trendingsSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              trendingsSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  'Mei Ho Ja',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),

                          // top charts view all
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
                                                  'Haryanvi Songs',
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
                                                    left: 195.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return HaryanviSongsViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          // top charts list
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: haryanviSongs.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = haryanviSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              haryanviSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  'Mei Ho Ja',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
                          ),

                          // new releasse view all
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
                                                  'Top Songs - Hindi',
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
                                                    left: 185.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return TopSongsViewAll();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'View All',
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
                          SizedBox(
                            height: 230,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final cartItem = tophindiSongs[index];

                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return SongsDeatilsList(
                                                      url: cartItem.url,
                                                      image: cartItem.image,
                                                      title: cartItem.title,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Card(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            // Adjust the radius as needed
                                                            child:
                                                                Image.network(
                                                              tophindiSongs[
                                                                      index]
                                                                  .image,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),

                                                          // child: Column(
                                                          //   children: [
                                                          //
                                                          //     Text('title'),
                                                          //     Text('subtitle')
                                                          //
                                                          //   ],
                                                          // ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  'Mei Ho Ja',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Sachet Tandon',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }),
                                ),
                              ),
                            ]),
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
