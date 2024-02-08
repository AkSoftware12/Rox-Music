import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/recentaly.dart';
import '../Service/MusicService.dart';

class CategorySong extends StatefulWidget {
  final String airtist;
  const CategorySong({super.key, required this.airtist});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategorySong> {
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

  MusicService musicService = MusicService();


  @override
  Widget build(BuildContext context) {

    List<RecentlySongs>filteredList = recently
        .where((item) => item.subtitle ==  widget.airtist)
        .toList();

    return Column(
      children: [


        Expanded(
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              final cartItem = filteredList[index];

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
                                Text(cartItem.title,style: TextStyle(color: Colors.white),),
                                Text(cartItem.subtitle,style: TextStyle(color: Colors.white),),

                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                },
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}