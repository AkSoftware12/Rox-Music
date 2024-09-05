import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_player_saavn/Utils/textSize.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/auth_service.dart';
import '../CommonCalling/Common.dart';
import '../Home/home.dart';
import '../Otp/verify.dart';
import '../Route/homebottom.dart';
import '../Themes/colors.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../baseurlp/baseurl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onTap});

  final Function? onTap;

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<LoginScreen> {
  CommonMethod common = CommonMethod();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  bool isloading = false;
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    // common.checkAutoLogin(context);

    phoneController.addListener(() {
      final text = phoneController.text;
      if (text.length == 10) {
        // Unfocus the TextField to hide the keyboard
        FocusScope.of(context).unfocus();
      }
    });
  }

  String? validationMessage;

  void validatePhoneNumber() {
    setState(() {
      String value = phoneController.text;
      // Remove the "+91" prefix before validation
      value = value.replaceFirst('+91', '');
      if (value.isEmpty) {
        validationMessage = 'Please enter your phone number';
      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
        validationMessage = 'Please enter a valid 10-digit phone number';
      } else {
        validationMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 98.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: GestureDetector(
                            child: Container(
                              width: 120.sp,
                              height: 120.sp,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  // Set the border color here
                                  width: 0.0, // Set the border width
                                ),
                                color: Colors.white,
                                // Container background color
                                borderRadius: BorderRadius.circular(120.sp),
                                // Optional: Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.2),
                                    // Shadow color
                                    spreadRadius: 5,
                                    // Spread radius
                                    blurRadius: 10,
                                    // Blur radius
                                    offset: Offset(
                                        0, 3), // Offset from the top-left
                                  ),
                                ],
                              ),

                              child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset('assets/mobile.png')),

                              // slider banner ad close
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 120.sp,
                      child: Column(
                        children: [
                          Text(
                            'Mobile Number',
                            style: TextStyle(
                              color: Colors.white,
                              // Text color
                              fontSize: 20.sp,
                              // Font size
                              fontWeight: FontWeight.normal,
                              // Font weight
                              fontStyle: FontStyle.normal,
                              // Font style
                              fontFamily: 'Roboto', // Custom font family
                            ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 17.0),
                            child: Text(
                              'We need to send OTP to authenticate your number',
                              style: TextStyle(
                                color: Colors.white70,
                                // Text color
                                fontSize: TextSizes.textmedium,
                                // Font size
                                fontWeight: FontWeight.normal,
                                // Font weight
                                fontStyle: FontStyle.normal,
                                // Font style
                                fontFamily: 'Roboto', // Custom font family
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 370.sp,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        // bottomLeft: Radius.circular(60),
                        // bottomRight: Radius.circular(60),
                      ),
                      color: Colors.white,
                    ),
                    child: Container(
                        child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 50.sp, left: 25, right: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                          width: 40,
                                          child: Text(
                                            '+91',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.sp),
                                          )),
                                      Text(
                                        "|",
                                        style: TextStyle(
                                            fontSize: 33, color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Phone",
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          onChanged: (value) {
                                            validatePhoneNumber();
                                            // // Remove non-digit characters
                                            // String cleanedValue = value.replaceAll(RegExp(r'\D'), '');
                                            //
                                            // // Update the text field value with only the first 10 digits
                                            // if (cleanedValue.length > 10) {
                                            //   cleanedValue = cleanedValue.substring(0, 10);
                                            // }
                                            //
                                            // // Update the controller with the cleaned value
                                            // phoneController.value = phoneController.value.copyWith(
                                            //   text: cleanedValue,
                                            //   selection: TextSelection.collapsed(offset: cleanedValue.length),
                                            // );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (validationMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red[100],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              validationMessage!,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 50),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50.sp,
                                      child: GestureDetector(
                                        onTap: () async {
                                          validatePhoneNumber();
                                          if (validationMessage == null) {
                                            if (formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isloading = true;
                                              });

                                              await FirebaseAuth.instance
                                                  .verifyPhoneNumber(
                                                phoneNumber:
                                                    '+91${phoneController.text}',
                                                verificationCompleted:
                                                    (phoneAuthCredential) {},
                                                verificationFailed: (error) {
                                                  log(error.toString());
                                                },
                                                codeSent: (verificationId,
                                                    forceResendingToken) {
                                                  setState(() {
                                                    isloading = false;
                                                  });

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyVerify(
                                                                verificationId:
                                                                    verificationId,
                                                                mobile: phoneController
                                                                    .text
                                                                    .toString(),
                                                              )));
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => OTPScreen(
                                                  //           verificationId: verificationId,
                                                  //         )));
                                                },
                                                codeAutoRetrievalTimeout:
                                                    (verificationId) {
                                                  log("Auto Retrieval timeout");
                                                  setState(() {
                                                    // isLoading = false;
                                                  });
                                                },
                                              );
                                            }
                                          } else {
                                            // Show validation message
                                            print(
                                                'Validation failed: $validationMessage');
                                          }
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                "Continue".toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        TextSizes.textlarge
                                                    // Change the color to your desired color
                                                    ),
                                              ),
                                            )),
                                      ),
                                    ),
                                    isloading
                                        ? SizedBox(
                                            height: 40.sp,
                                            child: Center(
                                                child:
                                                    const CircularProgressIndicator(
                                              color: Colors.orange,
                                            )))
                                        : SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, top: 20),
                            child: SizedBox(
                                width: double.infinity,
                                height: 50.sp,
                                child: GestureDetector(
                                  onTap: () async {
                                    common.login(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.asset(
                                                  'assets/gmail.png',
                                                  // Replace with your image path
                                                  height: 20
                                                      .sp, // Adjust the height as needed
                                                )
                                            ),
                                            SizedBox(width: 8.0),
                                            // Add some space between image and text
                                            Text(
                                              "Social Login".toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: TextSizes.textlarge
                                                  // Change the color to your desired color
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
