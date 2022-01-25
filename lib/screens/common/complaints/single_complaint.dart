import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleComplaint extends StatefulWidget {
  final String title;
  final String desc;
  final String image;
  final DateTime date;
  final String postedBy;
  final String status;
  SingleComplaint(
      this.title, this.desc, this.image, this.date, this.postedBy, this.status);
  @override
  _SingleComplaintState createState() => _SingleComplaintState();
}

class _SingleComplaintState extends State<SingleComplaint> {
  Globals g = Globals();
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
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image), fit: BoxFit.cover)),
          ),
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
              widget.desc,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.postedBy,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.date.day} ${days[widget.date.month - 1]}, ${widget.date.year}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: widget.status == "Resolved"
                ? Row(children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: Color(0xff107154)),
                    SizedBox(width: 10),
                    Text(
                      'Resolved',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ])
                : g.role == "Secretary"
                    ? TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff1a73e8).withOpacity(0.2)),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(horizontal: 15))),
                        child: Text(
                          'Mark as Resolved',
                          style: TextStyle(
                              color: Color(0xff1a73e8),
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    : Row(children: [
                        Icon(Icons.cancel_outlined, color: Color(0xffbb121a)),
                        SizedBox(width: 10),
                        Text(
                          'Unresolved',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ]),
          )
        ],
      ),
    );
  }
}
