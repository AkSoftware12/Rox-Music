import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_player_saavn/constants/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PhoneNumber_New extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhoneNumber(),
    );
  }
}

class PhoneNumber extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PhoneNumberState();
  }
}

class PhoneNumberState extends State<PhoneNumber> {
  static const String id = 'phone_number';
  final TextEditingController _controller = TextEditingController();
  String isoCode = '+91';
  int numberLimit = 10;
  var showDialogBox = false;

  @override
  void initState() {
    super.initState();
    // getCountryCode();
  }



  // void getCountryCode() async {
  //   setState(() {
  //     showDialogBox = true;
  //   });
  //
  //   String url = country_code;
  //   Uri myUri = Uri.parse(url);
  //   http.get(myUri).then((response) {
  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);
  //       print('${response.body}');
  //       if (jsonData['status'] == "1") {
  //         var tagObjsJson = jsonData['Data'] as List;
  //         if (tagObjsJson.isNotEmpty) {
  //           setState(() {
  //             showDialogBox = false;
  //             numberLimit = int.parse('${tagObjsJson[0]['number_limit']}');
  //             isoCode = tagObjsJson[0]['country_code'];
  //           });
  //         } else {
  //           setState(() {
  //             showDialogBox = false;
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           showDialogBox = false;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         showDialogBox = false;
  //       });
  //     }
  //   }).catchError((e) {
  //     print(e);
  //     setState(() {
  //       showDialogBox = false;
  //     });
  //   });
  //
  //   setState(() {
  //     showDialogBox = false;
  //     numberLimit = 10;
  //     isoCode = '+91';
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          return _handlePopBack();
        },
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    Image.asset(
                      "assets/rox.png", //gomarketdelivery logo
                      height: 400,
                      width: 400,
                    ),
                    //text on page
                    Text(
                      '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Visibility(
                        visible: showDialogBox,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // CountryCodePicker(
                              //   onChanged: (value) {
                              //     isoCode = value.code;
                              //   },
                              //   builder: (value) => buildButton(value),
                              //   initialSelection: '+91',
                              //   textStyle: Theme.of(context).textTheme.caption,
                              //   showFlag: false,
                              //   showFlagDialog: true,
                              //   favorite: ['+91', 'IN'],
                              // ),
                              Text('${isoCode}'),
                              SizedBox(
                                width: 5.0,
                              ),
                              //takes phone number as input
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 52,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: _controller,
                                    keyboardType: TextInputType.number,
                                    readOnly: false,
                                    textAlign: TextAlign.left,
                                    enabled: !showDialogBox,
                                    decoration: InputDecoration(
                                      hintText: 'number',
                                      border: InputBorder.none,
                                      counter: Offstage(),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstants.greyColor,
                                          fontSize: 16),
                                    ),
                                    maxLength: numberLimit,
                                  ),
                                ),
                              ),
                            ])),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.greyColor,
                          foregroundColor: ColorConstants.greyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.purple,
                          padding: EdgeInsets.all(12),
                          textStyle: TextStyle(
                              color: ColorConstants.greyColor, fontWeight: FontWeight.w400)),
                      onPressed: () {
                        if (!showDialogBox) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            showDialogBox = true;
                          });
                          if (_controller.text.length < 10) {
                            setState(() {
                              showDialogBox = false;
                            });
                            Fluttertoast.showToast(
                                msg: "Enter Valid mobile number!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black26,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else {
                            store(_controller.text);
                          }
                        }
                      },
                      child: Text(
'',                        style: TextStyle(
                            color: ColorConstants.greyColor,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Set the background color here
                          ),

                          onPressed: () async {
                            // common.login(context);

                          },


                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    'assets/gmail.png',
                                    // Replace with your image path
                                    height:
                                    30, // Adjust the height as needed
                                  )),
                              SizedBox(width: 8.0),
                              // Add some space between image and text
                              Text(
                                "Social Login".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                    18 // Change the color to your desired color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ])),
        ),
      ),

    );
  }


  Future<bool> _handlePopBack() async {
    bool isVal = false;
    if (showDialogBox) {
      setState(() {
        showDialogBox = false;
      });
    } else {
      isVal = true;
    }
    return isVal;
  }

  Future<void> store(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_phone", '${phoneNumber}');
  }
}
