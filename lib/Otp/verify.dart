import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Home/home.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key,  }) : super(key: key);


  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/otp_verfiy.png',
                height: 250,
              ),
              const SizedBox(
                height: 25,
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
              const Padding(
                padding: EdgeInsets.only(top: 28.0),
                child: SizedBox(
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter 6-digit OTP code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        // Handle OTP value changes
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      animationDuration: Duration(milliseconds: 300),
                      autoFocus: true,
                      textStyle: TextStyle(fontSize: 20.0),
                      cursorColor: Colors.black,
                      autoDisposeControllers: false,
                      enablePinAutofill: true, // Enable auto-fill for OTP
                      // You can add more parameters and callbacks as per your requirement
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return   MyHomePage();
                              },
                            ),
                          );
                        },
                        child: const Text("Verify Phone Number", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          // Change the color to your desired color
                        ),)),
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pushNamedAndRemoveUntil(
              //             context,
              //             'phone',
              //             (route) => false,
              //           );
              //         },
              //         child: Text(
              //           "Edit Phone Number ?",
              //           style: TextStyle(color: Colors.black),
              //         ))
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
