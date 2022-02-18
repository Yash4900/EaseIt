import 'package:ease_it/screens/security/approval/add_daily_visitor.dart';
import 'package:ease_it/screens/security/approval/approve_visitor.dart';
import 'package:ease_it/screens/security/approval/past_approvals.dart';
import 'package:ease_it/screens/security/approval/recent_approvals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Visitor Approval',
            style: GoogleFonts.sourceSansPro(
                fontSize: 25, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddDailyVisitor()));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Text(
                    'Add daily visitor',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton(
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApproveVisitor()));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Row(children: [
                      Icon(
                        Icons.how_to_reg,
                        color: Color(0xff037DD6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Approve visitor',
                        style: TextStyle(
                            color: Color(0xff037DD6),
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ))
            ],
          ),
          SizedBox(height: 15),
          TabBar(
              indicatorColor: Color(0xff037DD6),
              labelColor: Colors.black,
              indicatorWeight: 2.5,
              labelStyle: GoogleFonts.sourceSansPro(
                  fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                  text: 'Past',
                ),
                Tab(
                  text: 'Today',
                )
              ]),
          Expanded(
            child: TabBarView(children: [PastApproval(), RecentApproval()]),
          ),
        ]),
      ),
    );
  }
}
