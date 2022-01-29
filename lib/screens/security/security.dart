// Resident Landing page

import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/screens/security/approval/approval.dart';
import 'package:ease_it/screens/common/forum.dart';
import 'package:ease_it/screens/security/child_safety/child_safety.dart';
import 'package:ease_it/screens/security/parking/parking.dart';
import 'package:ease_it/screens/security/home/securityHome.dart';
import 'package:ease_it/utility/drawer.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  Globals g = Globals();
  String name;
  int _pageIndex = 0;
  List<Widget> pages = [
    SecurityHome(),
    Approval(),
    Parking(),
    ChildSafety(),
    Forum()
  ];

  @override
  void initState() {
    name = g.fname + " " + g.lname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.logout),
              onPressed: () async {
                await Auth().logout();
              }),
        ],
      ),
      drawer: showDrawer(context, g.role),
      backgroundColor: Colors.white,
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        // backgroundColor: Colors.white,
        onTap: (value) => setState(() => _pageIndex = value),
        selectedItemColor: Color(0xff1a73e8),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Approval'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_taxi), label: 'Parking'),
          BottomNavigationBarItem(
              icon: Icon(Icons.child_care_outlined), label: 'Child Safety'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: 'Forum')
        ],
      ),
    );
  }
}
