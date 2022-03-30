import 'package:ease_it/screens/security/vehicle/allotments.dart';
import 'package:ease_it/screens/security/vehicle/actions.dart';
import 'package:ease_it/screens/security/vehicle/vehicle_log.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Vehicle extends StatefulWidget {
  @override
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Vehicle Management',
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
                  text: 'Actions',
                ),
                Tab(
                  text: 'Log',
                ),
                Tab(
                  text: 'Allotments',
                ),
              ]),
          Expanded(
            child: TabBarView(children: [
              ActionList(),
              VehicleLog(),
              Allotments(),
            ]),
          ),
        ]),
      ),
    );
  }
}
