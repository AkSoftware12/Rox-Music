import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_player_saavn/Home/home.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../baseurlp/baseurl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


final Color yellow = Color(0xfffbc31b);
final Color orange = Color(0xfffb6900);
final String image1 = "images/broccoli.jpg";
final String image2 = "images/carrots.jpg";

String image = image1;

class AddSonglistScreen extends StatefulWidget {
  AddSonglistScreen({Key? key,}) : super(key: key);
  @override
  _LoadFirbaseStorageImageState createState() =>
      _LoadFirbaseStorageImageState();
}

class _LoadFirbaseStorageImageState extends State<AddSonglistScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  File? file;
  FilePickerResult? result;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode focusNodeNickname = FocusNode();
  final List<String> items = List.generate(100, (index) => 'Item $index');
  List<dynamic> allSongs = [];
  List<int> selectedIds = [];
  bool check=false;


  Future<void> addPost(File? file) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
              // SizedBox(width: 16.0),
              // Text("Logging in..."),
            ],
          ),
        );
      },
    );

    setState(() {
      _isLoading = true;
    });
    final title = titleController.text;
    final des = artistController.text;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');


    var request = http.MultipartRequest(
      'POST',
      Uri.parse(userAddplaylist),
    );

    // Add token to request headers
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = title;
    request.fields['description'] = des;
    request.fields['songs'] = selectedIds.toString();
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', file.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print("Playlist added successfully");

      // Navigator.pop(context);
      Navigator.pop(context);


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );


    } else {
      print("Failed to add post. Error: ${response.body}");
      // Handle failure
    }


  }

  Future<void> hitAllSong() async {
    final response = await http.get(Uri.parse(songs));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('songs')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          allSongs = responseData['songs'];
          // restBanner=responseData['data']['banner_img'];
          print(allSongs);

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }


  @override
  void initState() {
    super.initState();
    hitAllSong();
    print(selectedIds);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 200.sp,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0)),
                  gradient: LinearGradient(
                      colors: [Colors.redAccent.shade200,Colors.orange.shade200,  Colors.purple.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Container(
                child: GestureDetector(
                  onTap: () async {
                    try {
                      result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png', ],
                      );
                      if (result != null) {
                        if (!kIsWeb) {
                          file = File(result!.files.single.path!);
                        }
                        setState(() {});
                      } else {
                        // User canceled the picker
                      }
                    } catch (_) {}
                  },
                  child: Center(
                    child: Card(
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'jpeg', 'png', ],
                            );
                            if (result != null) {
                              if (!kIsWeb) {
                                file = File(result!.files.single.path!);
                              }
                              setState(() {});
                            } else {
                              // User canceled the picker
                            }
                          } catch (_) {}
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                          child: (file != null || result != null) ?
                          (kIsWeb ?
                          Image.memory(
                            result!.files.first.bytes!,
                            height: 120.sp,
                            width: 200.sp,
                            fit: BoxFit.fill,
                          ) :
                          Image.file(
                            file!,
                            height: 120.sp,
                            width: 200.sp,
                            fit: BoxFit.fill,
                          )
                          ) :
                          Container(
                            height: 120.sp,
                            width: 200.sp,
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                'No image Selected',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ),
            Container(
              height: MediaQuery.of(context).size.height -     200.sp,
              margin:  EdgeInsets.only(top: 200.sp,),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                            child: Column( // Use Column for vertical alignment
                              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text('Playlist Name', textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                      textStyle:  TextStyle(
                                          color: Colors.white,
                                          fontSize: TextSizes.textmedium,
                                          fontWeight: FontWeight.normal),
                                    ),),
                                ), // Align text to the start
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Card(
                                    elevation: 5.0,
                                    color: Colors.white, // Set the background color here
                                    margin: EdgeInsets.only(left: 15.0, right: 15),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                            hintText: 'Enter playlist name',
                                            border: InputBorder.none,

                                          ),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0,top: 15),
                                  child: Text('Description', textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                      textStyle:  TextStyle(
                                          color: Colors.white,
                                          fontSize: TextSizes.textmedium,
                                          fontWeight: FontWeight.normal),
                                    ),),
                                ), // Align text to the start
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Card(
                                    elevation: 5.0,
                                    color: Colors.white, // Set the background color here
                                    margin: EdgeInsets.only(left: 15.0, right: 15),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: TextField(
                                          controller: artistController,
                                          decoration: InputDecoration(
                                            hintText: 'Enter description',
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),



                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0,top: 15),
                                  child: Text('Songs', textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                      textStyle:  TextStyle(
                                          color: Colors.white,
                                          fontSize: TextSizes.textmedium,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: allSongs.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: SizedBox(
                                              width: 20.sp,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(2.0),
                                                child: Image.network(
                                                  allSongs[index]['image_data'].toString(),
                                                  width: 20.sp,
                                                  height: 15.sp,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    // Return a default image widget here
                                                    return Container(
                                                      width: 20.sp,
                                                      height: 15.sp,
                                                      color: Colors.grey, // Placeholder color
                                                      // You can customize the default image as needed
                                                      child: Icon(
                                                        Icons.image,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text(
                                                      allSongs[index]['title'].toString(),
                                                      style: GoogleFonts.poppins(
                                                        textStyle:  TextStyle(
                                                            color: Colors.white,
                                                            fontSize: TextSizes.textsmallPlayer,
                                                            fontWeight: FontWeight.normal),
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(playlists[index]['description'].toString(),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  activeColor: Colors.orange,
                                                  value: allSongs[index]['isChecked'] ?? false,
                                                  onChanged: (bool? newValue) {
                                                    // Update the isChecked value of the song
                                                    setState(() {
                                                      allSongs[index]['isChecked'] = newValue;
                                                      if (newValue == true) {
                                                        // If checkbox is checked, add the corresponding ID to the selectedIds list
                                                        selectedIds.add(allSongs[index]['id']);
                                                        print(selectedIds);
                                                        // Assuming 'id' is the key for ID in your data
                                                      } else {
                                                        // If checkbox is unchecked, remove the corresponding ID from the selectedIds list
                                                        selectedIds.remove(allSongs[index]['id']);
                                                        print(selectedIds);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ]
                            )

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
      floatingActionButton:Padding(
        padding: const EdgeInsets.only(right: 108.0,top: 10),
        child: Container(
          child: Stack(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {


                  if (file != null) {
                    addPost(file);
                  } else {
                    print('Please pick a file first.');
                  }
                },
                child: Text(
                  "Add Playlist",

                  style: TextStyle(fontSize: 20,color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: ElevatedButton(
              onPressed: () {
                if (file != null) {
                  addPost(file);
                } else {
                  print('Please pick a file first.');
                }
              },
              child: Text(
                "Add Playlist",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
