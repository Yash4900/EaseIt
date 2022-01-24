import 'package:ease_it/screens/security/security.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDialog extends StatelessWidget {
  static const double padding = 4.0;
  static const double avatarRadius = 11.0;
  final String title, description, buttonText;
  final Image image;
  var homePage;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.homePage,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            bottom: padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: totalHeight * 3.0 / 100,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: totalHeight * 10.0 / 100),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: totalHeight * 2.5 / 100,
                ),
              ),
              SizedBox(height: totalHeight * 10.0 / 100),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            homePage
                      ),
                    );
                  },
                  child: Text(buttonText.toString()),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: avatarRadius,
            child: Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}