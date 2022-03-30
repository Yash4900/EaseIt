// Child Safety Screen

import 'package:ease_it/screens/security/child_safety/past_approvals.dart';
import 'package:ease_it/screens/security/child_safety/recent_approvals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChildSafety extends StatefulWidget {
  @override
  _ChildSafetyState createState() => _ChildSafetyState();
}

class _ChildSafetyState extends State<ChildSafety> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Child Approval',
            style: GoogleFonts.sourceSansPro(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 15),
          TabBar(
              indicatorColor: Color(0xff037DD6),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black38,
              indicatorWeight: 2.5,
              labelStyle: GoogleFonts.sourceSansPro(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(
                  text: 'Today',
                ),
                Tab(
                  text: 'Past',
                )
              ]),
          Expanded(
            child: TabBarView(children: [
              RecentApproval(),
              PastApproval(),
            ]),
          ),
        ]),
      ),
    );
  }
}
