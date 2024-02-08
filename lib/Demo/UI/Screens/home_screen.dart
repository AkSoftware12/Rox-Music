import 'package:flutter/material.dart';
import 'package:music_player_saavn/Demo/demo.dart';

import '../../Core/app_globals.dart';
import 'in_progess_screen.dart';


class RentalsDetailScreen extends StatefulWidget {
  const RentalsDetailScreen({Key? key}) : super(key: key);

  @override
  State<RentalsDetailScreen> createState() => _RentalsDetailScreenState();
}

class _RentalsDetailScreenState extends State<RentalsDetailScreen> {
  TextEditingController searchController = TextEditingController();
  int selectIndex = 0;
  String searchQuery = '';

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        color:  gOffWhite,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: TabBar(
                          onTap: (index) {
                            setState(() {
                              selectIndex = index;
                            });
                          },
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 05),
                          indicatorColor: gOffWhite,
                          tabs: [
                            selectIndex != 0
                                ? const Text(
                                    '$upComing (0)',
                                    style: TextStyle(
                                        color: gBlack, fontSize: 15),
                                  )
                                : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: const Color(0xffe9e9e9)),
                                      color: gWhite,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '$upComing (0)',
                                        style: TextStyle(
                                            color: gBlack, fontSize: 15),
                                      ),
                                    ),
                                  ),
                            selectIndex != 1
                                ? const Text(
                                    '$inProgress (0)',
                                    style: TextStyle(
                                        color: gBlack, fontSize: 15),
                                  )
                                : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: const Color(0xffe9e9e9)),
                                      color: gWhite,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '$inProgress (0)',
                                        style: TextStyle(
                                            color: gBlack, fontSize: 15),
                                      ),
                                    ),
                                  ),
                            selectIndex != 2
                                ? const Text(
                                    end,
                                    style: TextStyle(
                                        color: gBlack, fontSize: 15),
                                  )
                                : Container(
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: const Color(0xffe9e9e9)),
                                      color: gWhite,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        end,
                                        style: TextStyle(
                                            color: gBlack, fontSize: 18),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Home1Screen(
                            // searchQuery: searchQuery,
                          ),
                          InProgressScreen(
                            searchQuery: searchQuery,
                          ),
                          InProgressScreen(
                            searchQuery: searchQuery,
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
      ),
    );
  }
}
