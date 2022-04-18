import 'dart:math';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class InputDialog extends StatefulWidget {
  const InputDialog({Key key}) : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  String errorText = "";
  OtpFieldController otpController = OtpFieldController();
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OTPTextField(
            controller: otpController,
            length: 6,
            width: MediaQuery.of(context).size.width * 0.8,
            fieldWidth: 20,
            textFieldAlignment: MainAxisAlignment.spaceEvenly,
            fieldStyle: FieldStyle.underline,
            onChanged: (pin) {
              this.pin = pin;
              print(pin);
            },
            onCompleted: (pin) {
              this.pin = pin;
              print(pin);
            },
          ),
          SizedBox(
            height: 5,
          ),
          errorText != ""
              ? Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                )
              : SizedBox(
                  height: 1,
                ),
        ],
      ),
      actions: [
        TextButton(
          child: Text("Clear"),
          onPressed: () {
            print("Value obtained is: ${otpController.toString()}");
            otpController.clear();
          },
        ),
        TextButton(
          child: Text("Submit OTP"),
          onPressed: () {
            print("On clicking : $pin");
            if (pin.length < 6) {
              setState(() {
                errorText = "Please enter the complete OTP";
              });
            } else {
              Navigator.pop(context, pin);
            }
          },
        ),
      ],
    );
  }
}
