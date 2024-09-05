import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home.dart';
import '../Route/homebottom.dart';
import '../baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;

import '../constants/firestore_constants.dart';


class MyVerify extends StatefulWidget {
  final String verificationId;
  final String mobile;

  const MyVerify({Key? key, required this.verificationId, required this.mobile}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  bool isLoading = false;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/padlock.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 45,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
               Text(
                "phone: ${widget.mobile}",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 28.0),
                child: SizedBox(
                  height: 30,
                ),
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                controller: otpController,
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 75,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 40.sp,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222B40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              final cred = PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: otpController.text,
                              );

                              await FirebaseAuth.instance.signInWithCredential(cred);


                              final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                              String? deviceToken = await _firebaseMessaging.getToken();
                              print('Device id: $deviceToken');



                              final response = await http.post(
                                Uri.parse(register),
                                body: json.encode({'mobile_number': widget.mobile,'device_id': deviceToken,'name':'',
                                }),
                                headers: {'Content-Type': 'application/json'},
                              );

                              if (response.statusCode == 200) {
                                final Map<String, dynamic> responseData = json.decode(response.body);
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                final String token = responseData['token'];

                                await prefs.setString('token', token);
                                print('token: $token');

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeBottom()),
                                );

                                print(token);

                                print(response);
                                //   Registration successful

                              } else {
                                // Registration failed

                              }
                              final String _loggedInKey = 'loggedIn';
                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              // await prefs.setString(FirestoreConstants.id, currentUser!.uid);
                              // await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
                              // await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
                              await prefs.setString(FirestoreConstants.userContact, widget.mobile ?? "");
                              prefs.setBool(_loggedInKey, true);


                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const HomeBottom(),
                              //   ),
                              // );
                            } catch (e) {

                              Fluttertoast.showToast(
                                  msg: 'Invalid OTP Code',
                                  toastLength: Toast.LENGTH_LONG,  // or Toast.LENGTH_LONG
                                  gravity: ToastGravity.BOTTOM,     // position of the toast
                                  timeInSecForIosWeb: 1,            // duration for iOS and web
                                  backgroundColor: Colors.black,    // background color
                                  textColor: Colors.white,          // text color
                                  fontSize: 16.0                    // font size
                              );

                              log(e.toString());
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: const Text(
                            "Verify Phone Number",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      isLoading
                          ? Center(child: SizedBox(
                          height: 40.sp,
                          width: 40.sp,
                          child: const CircularProgressIndicator(
                            color: Colors.orange,
                          ))): SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
