import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  TextStyle headingStyle = TextStyle(
      color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  TextStyle mediumStyle = TextStyle(
      color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400);
  TextStyle normalStyle = TextStyle(
      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400);
  TextStyle buttonTextStyle = TextStyle(
      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w600);
  Color button = Colors.white;

TextStyle mediumBoldStyle = TextStyle(
    color: Colors.black,fontSize: 13.0,fontWeight: FontWeight.bold);


  TextStyle successMediumBoldStyle = TextStyle(
    color: Colors.green,fontSize: 13.0,fontWeight: FontWeight.bold);

String convertToDateTime(var t)
{
  print(t.seconds);
  var date = DateTime.fromMillisecondsSinceEpoch(t.seconds * 1000);
    var d12 = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
    return d12;
}
String convertToDate(var t)
{
  var date = DateTime.fromMillisecondsSinceEpoch(t.seconds * 1000);
    var d12 = DateFormat('MM-dd-yyyy').format(date);
    return d12;
}

String convertToTime(var t)
{
  var date = DateTime.fromMillisecondsSinceEpoch(t.seconds * 1000);
    var d12 = DateFormat('hh:mm a').format(date);
    return d12;
}
  
}
