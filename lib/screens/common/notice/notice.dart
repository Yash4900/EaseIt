import 'package:ease_it/screens/common/notice/add_notice.dart';
import 'package:ease_it/screens/common/notice/single_notice.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notice {
  String title;
  String content;
  DateTime postedOn;
  Notice(this.title, this.content, this.postedOn);
}

class NoticeView extends StatefulWidget {
  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
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
  List<Notice> notices = [
    Notice(
        "Regarding electric supply",
        "On Wednesday i.e. 19th Jan there will be power cut from afternoon 1 PM till evening 7 PM. Please take the note of same.",
        DateTime.now()),
    Notice(
        "Regarding electric supply",
        "On Wednesday i.e. 19th Jan there will be power cut from afternoon 1 PM till evening 7 PM. Please take the note of same.",
        DateTime.now()),
    Notice(
        "Regarding electric supply",
        "On Wednesday i.e. 19th Jan there will be power cut from afternoon 1 PM till evening 7 PM. Please take the note of same.",
        DateTime.now())
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleNotice(notices[index].title,
                          notices[index].content, notices[index].postedOn),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          notices[index].title,
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          notices[index].content.substring(0, 100) + " ...",
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${notices[index].postedOn.day} ${days[notices[index].postedOn.month - 1]}, ${notices[index].postedOn.year}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        g.role == "Secretary"
            ? Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddNotice()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xff1a73e8).withOpacity(0.2)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 15))),
                    child: Text(
                      '+ Publish a notice',
                      style: TextStyle(
                          color: Color(0xff1a73e8),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
