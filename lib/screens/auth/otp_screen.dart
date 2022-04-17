import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  String phoneNumber;

  OtpScreen({
    Key key,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String finalPhoneNumber;
  FirebaseAuth auth = FirebaseAuth.instance;

  void sendOtp(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: finalPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int resendToken) {
        print("The Verification ID obtained is: $verificationId");
        PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: "111111",
        );
        print(authCredential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    super.initState();
    finalPhoneNumber = "+91" + widget.phoneNumber;
    print(finalPhoneNumber);
    sendOtp(finalPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "OTP Verification",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Text(
            "Working",
          ),
        ),
      ),
    );
  }
}