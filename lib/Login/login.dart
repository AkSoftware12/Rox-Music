import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/auth_service.dart';
import '../CommonCalling/Common.dart';
import '../Home/home.dart';
import '../Otp/verify.dart';
import '../Themes/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onTap});

  final Function? onTap;

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<LoginScreen> {

  CommonMethod common = CommonMethod();

  bool showOTPField = false;
  bool showSendOTPButton = true;
  bool showProgressBar = false;

  final FirebaseAuth? _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = "";
  late String smsOTP="";


  Future<void> _sendOTP() async {
    try {
      await _auth!.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth!.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval of OTP timed out
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth!.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      // Authentication successful, perform necessary actions
    } catch (e) {
      print(e.toString());
      // Show a pop-up indicating wrong OTP
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid OTP'),
            content: Text('The OTP entered is incorrect.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    common.checkAutoLogin(context);
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor:  Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 450,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          // bottomLeft: Radius.circular(60),
                          //  bottomRight: Radius.circular(100),
                        ),
                        color: Colors.black,
                      ),
                      child: Container(
                          child: Container(
                            child: Column(
                              children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top: 58.0),
                                   child: SizedBox(
                                     height: 300,
                                     child: Image.asset(
                                      "assets/rox.png", //gomarketdelivery logo
                                                                     ),
                                   ),
                                 ),
                                Container(
                                  child: const Column(
                                    children: [
                                      Text(
                                        'Mobile Number',
                                        style: TextStyle(
                                          color: Colors.white,
                                          // Text color
                                          fontSize: 25.0,
                                          // Font size
                                          fontWeight: FontWeight.normal,
                                          // Font weight
                                          fontStyle: FontStyle.normal,
                                          // Font style
                                          fontFamily: 'Roboto', // Custom font family
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 17.0),
                                        child: Text(
                                          'We need to send OTP to authenticate your number',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            // Text color
                                            fontSize: 16.0,
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
                          )),
                    ),
                  ),


                ],
              ),
              Container(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0,left: 25,right: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), // adjust the radius as needed
                                child: IntlPhoneField(
                                  controller: _phoneNumberController,
                                  flagsButtonPadding: const EdgeInsets.all(8),
                                  dropdownIconPosition: IconPosition.trailing,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF222B40),
                                    ),
                                    fillColor: Colors.black,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF222B40),
                                      ),
                                    ),
                                  ),
                                  initialCountryCode: 'IN',
                                  onChanged: (phone) {
                                    print(phone.completeNumber);
                                  },
                                ),
                              ),
                              SizedBox(height: 25),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 0, top: 5),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.orange, // Set the background color here
                                    ),

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyVerify()),
                                      );

                                    },

                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Add some space between image and text
                                        Text(
                                          "Send Otp".toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              18 // Change the color to your desired color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: 25,),
                        Text(
                          "- - - - - - - - - - - - OR - - - - - - - - - - - -".toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                              18 // Change the color to your desired color
                          ),
                        ),




                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25, top: 30),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange, // Set the background color here
                              ),

                              onPressed: () async {
                                common.login(context);

                              },


                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
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
                                        color: Colors.white,
                                        fontSize:
                                        18 // Change the color to your desired color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
