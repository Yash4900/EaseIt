import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/acknowledgement/input_dialog.dart';

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
      verificationCompleted: (PhoneAuthCredential credential) {
        print("------------------------------------");
        print("I am in verification completed");
        if (credential != null) {
          Navigator.pop(context, true);
        }
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int resendToken) async {
        print("The Verification ID obtained is: $verificationId");
        String returnedOtp = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InputDialog();
          },
          barrierColor: Color(
            0xaaa0a0a0,
          ),
        );
        PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: returnedOtp,
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
