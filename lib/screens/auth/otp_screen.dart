import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:ease_it/utility/display/count_down_timer.dart';
import 'package:ease_it/config/auth.config.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';

class OtpScreen extends StatefulWidget {
  String emailId;

  OtpScreen({
    Key key,
    @required this.emailId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  EmailAuth emailAuth;
  bool firstTimeOtpRequested = false;
  bool timerOn = false, isLoading = false;
  String errorText = "";
  int resendTimes = 0;
  OtpFieldController otpController = OtpFieldController();

  void sendOtp(String emailId) async {
    if (resendTimes >= 3) {
      Database().addEmailInWaitingList(emailId, DateTime.now());
      await showMessageDialog(context, "Alert", [
        Text(
            "Since you are unable to receive OTP we request you to try to register after 2 hours")
      ]);
      Navigator.pop(context, false);
      return;
    }
    bool result = await emailAuth.sendOtp(recipientMail: widget.emailId);
    resendTimes += 1;
    print(resendTimes);
  }

  bool verifyOtp(String emailId, String pin) {
    return emailAuth.validateOtp(recipientMail: emailId, userOtp: pin);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    emailAuth = EmailAuth(sessionName: "Ease IT App");
    emailAuth.config(remoteServerConfiguration);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Loading(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "OTP Verification",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: firstTimeOtpRequested
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Enter your OTP to verify",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            OTPTextField(
                              controller: otpController,
                              length: 6,
                              width: MediaQuery.of(context).size.width * 0.8,
                              fieldWidth: 35,
                              textFieldAlignment: MainAxisAlignment.spaceEvenly,
                              fieldStyle: FieldStyle.box,
                              onChanged: (pin) {
                                print(pin);
                              },
                              onCompleted: (pin) {
                                bool checkOtp = verifyOtp(widget.emailId, pin);
                                print("Value of checkOtp $checkOtp");
                                if (checkOtp) {
                                  print("Otp Verified");
                                  setState(() {
                                    errorText = "";
                                  });
                                  Navigator.pop(context, true);
                                  Database()
                                      .deleteEmailFromWaitList(widget.emailId);
                                } else {
                                  print("Otp not verified");
                                  setState(() {
                                    errorText = "Invalid OTP";
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            errorText == null || errorText == ""
                                ? SizedBox()
                                : Center(
                                    child: Text(
                                      "Invalid OTP",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            timerOn == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Didnt't Receive the OTP",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          sendOtp(widget.emailId);
                                          setState(() {
                                            timerOn = true;
                                          });
                                        },
                                        child: Text(
                                          "Resend",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationStyle:
                                                TextDecorationStyle.dotted,
                                            decorationColor: Colors.redAccent,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Didnt't Receive the OTP",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          sendOtp(widget.emailId);
                                          setState(() {
                                            timerOn = true;
                                          });
                                        },
                                        child: Text(
                                          "Sent",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationStyle:
                                                TextDecorationStyle.dotted,
                                            decorationColor: Colors.grey[800],
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            timerOn == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Wait for ",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      CountDownTimer(
                                        secondsRemaining: 120,
                                        whenTimeExpires: () {
                                          setState(() {
                                            timerOn = false;
                                          });
                                        },
                                        countDownTimerStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      )
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              "To verify your email ID: ${widget.emailId}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                sendOtp(widget.emailId);
                                setState(() {
                                  firstTimeOtpRequested = true;
                                  timerOn = true;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff037DD6)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                                child: Text(
                                  'Request OTP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
  }
}
