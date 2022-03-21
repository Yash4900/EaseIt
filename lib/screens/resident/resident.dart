// Resident Landing page

import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/screens/common/forum.dart';
import 'package:ease_it/screens/resident/maintenance/maintenance.dart';
import 'package:ease_it/screens/resident/my_vehicle/my_vehicle.dart';
import 'package:ease_it/screens/resident/residentHome.dart';
import 'package:ease_it/utility/drawer.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart';

class Resident extends StatefulWidget {
  @override
  _ResidentState createState() => _ResidentState();
}

class _ResidentState extends State<Resident> {
  Globals g = Globals();
  String name;
  String role;
  int _pageIndex = 0;
  bool loading = false;
  Globals g = Globals();
  int numOfPendingRequests;
  List<Widget> pages = [
    ResidentHome(),
    MyVehicle(),
    Forum(),
    Approval(),
    Maintenance()
  ];

  void getTotalPendingRequests

  @override
  void initState() {
    name = g.fname + " " + g.lname;
    role = g.role;
    setState(() {
      loading = true;
    });

    setState(() {
      loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Loading()
        : Scaffold(
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  role == "Secretary"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Badge(
                            badgeColor: Color(0xff1a73e8),
                            badgeContent: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.people),
                              iconSize: 25,
                              onPressed: () {},
                            ),
                          ),
                        )
                      : SizedBox(),
                ]),
            drawer: showDrawer(context),
            backgroundColor: Colors.white,
            body: pages[_pageIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _pageIndex,
              onTap: (value) => setState(() => _pageIndex = value),
              selectedItemColor: Color(0xff037DD6),
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              showUnselectedLabels: true,
              selectedFontSize: 15,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.car), label: 'My Vehicle'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_outlined), label: 'Forum'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.security_outlined), label: 'Approvals'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.build_outlined), label: 'Maintenance')
              ],
            ),
          );
  }
}
