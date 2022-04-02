import 'package:ease_it/screens/resident/maintenance/transactionHistory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ease_it/utility/variables/globals.dart';

class ResidentPOV extends StatefulWidget {
  const ResidentPOV({Key key}) : super(key: key);

  @override
  _ResidentPOVState createState() => _ResidentPOVState();
}

Globals g = Globals();

class _ResidentPOVState extends State<ResidentPOV> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Maintenance',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 25, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 15),
            TabBar(
                indicatorColor: Color(0xff1a73e8),
                labelColor: Colors.black,
                indicatorWeight: 2.5,
                labelStyle: GoogleFonts.sourceSansPro(
                    fontSize: 16, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(
                    text: 'My Maintenance History',
                  )
                ]),
            Expanded(
              child: TabBarView(children: [
                TransactionHistory(),
              ]),
            ),
          ]),
        ));
  }
}
