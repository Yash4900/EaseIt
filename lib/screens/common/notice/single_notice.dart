import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleNotice extends StatefulWidget {
  final String title;
  final String content;
  final DateTime postedOn;
  SingleNotice(this.title, this.content, this.postedOn);
  @override
  _SingleNoticeState createState() => _SingleNoticeState();
}

class _SingleNoticeState extends State<SingleNotice> {
  List<String> days = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.title,
              style: GoogleFonts.sourceSansPro(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
