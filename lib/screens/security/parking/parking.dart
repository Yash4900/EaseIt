import 'package:ease_it/screens/security/parking/status.dart';
import 'package:ease_it/screens/security/parking/actions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Parking extends StatefulWidget {
  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Parking Management',
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
                  text: 'Current Status',
                ),
                Tab(
                  text: 'Actions',
                )
              ]),
          Expanded(
            child: TabBarView(children: [Status(), ActionList()]),
          ),
        ]),
      ),
    );
  }
}
