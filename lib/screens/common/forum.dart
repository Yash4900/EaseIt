import 'package:ease_it/screens/common/complaints/complaint.dart';
import 'package:ease_it/screens/common/notice/notice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forum',
              style: GoogleFonts.sourceSansPro(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            TabBar(
                indicatorColor: Color(0xff037DD6),
                unselectedLabelColor: Colors.black38,
                labelColor: Colors.black,
                indicatorWeight: 2.5,
                labelStyle: GoogleFonts.sourceSansPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(
                    text: 'Notice',
                  ),
                  Tab(
                    text: 'Complaints',
                  )
                ]),
            Expanded(
              child: TabBarView(
                children: [
                  NoticeView(),
                  ComplaintView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
