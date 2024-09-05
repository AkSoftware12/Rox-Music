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
        'https://c.saavncdn.com/255/Ab-Tumhare-Hawale-Watan-Sathiyo-Hindi-2004-20221118021108-500x500.jpg', id: ''),

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
                    // musicService.playSong(
                    //     cartItem.id,
                    //     cartItem.url,
                    //     cartItem.image,
                    //     cartItem.title, cartItem.subtitle);
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