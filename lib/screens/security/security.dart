// Resident Landing page
import 'package:ease_it/screens/security/approval/approval.dart';
import 'package:ease_it/screens/common/forum.dart';
import 'package:ease_it/screens/security/child_safety/child_safety.dart';
import 'package:ease_it/screens/security/vehicle/vehicle.dart';
import 'package:ease_it/screens/security/home/securityHome.dart';
import 'package:ease_it/utility/display/drawer.dart';
import 'package:ease_it/utility/variables/globals.dart';
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
    Vehicle(),
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
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: showDrawer(context),
      backgroundColor: Colors.white,
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) => setState(() => _pageIndex = value),
        selectedItemColor: Color(0xff037DD6),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedFontSize: 15,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('assets/home.png', height: 20), label: 'Home'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/approve.png', height: 20),
              label: 'Approval'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/parking.png', height: 20),
              label: 'Vehicle'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/child-safety.png', height: 20),
              label: 'Child Safety'),
          BottomNavigationBarItem(
              icon: Image.asset('assets/forum.png', height: 20), label: 'Forum')
        ],
      ),
    );
  }
}
