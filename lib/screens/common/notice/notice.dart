import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/notice/add_notice.dart';
import 'package:ease_it/screens/common/notice/single_notice.dart';
import 'package:ease_it/utility/display/time_ago.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticeView extends StatefulWidget {
  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  Globals g = Globals();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: StreamBuilder(
              stream: Database().fetchNotices(g.society),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  return snapshot.data.docs.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            DateTime date = ds['postedOn'].toDate();
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleNotice(
                                        ds['title'],
                                        ds['body'],
                                        ds['postedOn']),
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        ds['title'],
                                        style: GoogleFonts.sourceSansPro(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        ds['body'].length < 100
                                            ? ds['body']
                                            : ds['body'].substring(0, 100) +
                                                " ...",
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            timeAgo(date),
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
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/no_data.png',
                                width: 300,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No Notices found',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        );
                }
              }),
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                          side: BorderSide(
                            color: Color(0xff037DD6),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xff037DD6)),
                          SizedBox(width: 10),
                          Text(
                            'Publish a notice',
                            style: TextStyle(
                                color: Color(0xff037DD6),
                                fontWeight: FontWeight.w600),
                          ),
                        ]),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
