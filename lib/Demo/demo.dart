import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../Themes/colors.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
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
        MaterialPageRoute(builder: (context) => Home1Screen()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntlPhoneField(
              controller: _phoneNumberController,
              flagsButtonPadding: const EdgeInsets.all(8),
              dropdownIconPosition: IconPosition.trailing,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: Color(0xFF222B40), // Change the label text color
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

            SizedBox(height: 16.0),
            SizedBox(height: 16.0),

            Container(
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  PinCodeTextField(
                    autofocus: false,
                    controller: _otpController,
                    hideCharacter: false,
                    highlight: true,
                    highlightColor: kHintColor,
                    defaultBorderColor: kMainColor,
                    hasTextBorderColor: kMainColor,
                    maxLength: 6,
                    pinBoxRadius: 20,
                    onDone: (text) {
                      SystemChannels.textInput
                          .invokeMethod('TextInput.hide');
                      _verificationId = text;
                      smsOTP = text as String;
                    },
                    pinBoxWidth: 40,
                    pinBoxHeight: 40,
                    hasUnderline: false,
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinBoxDecoration: ProvidedPinBoxDecoration
                        .roundedPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 22.0),
                    pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration:
                    Duration(milliseconds: 300),
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15.0),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Didn't you receive any code?",
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      // generateOtp('+91$contact');

                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Resend Code"),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Visibility(
                  //     visible: showDialogBox,
                  //     child: const Align(
                  //       alignment: Alignment.center,
                  //       child: CircularProgressIndicator(),
                  //     )),
                ],
              ),
            ),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signInWithOTP,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class Home1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
