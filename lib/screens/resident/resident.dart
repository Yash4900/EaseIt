// Resident Landing page

//import 'dart:html';

import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/screens/common/forum.dart';
import 'package:ease_it/screens/resident/maintenance/maintenance.dart';
import 'package:ease_it/screens/resident/my_vehicle/my_vehicle.dart';
import 'package:ease_it/screens/resident/residentHome.dart';
import 'package:ease_it/screens/resident/secretary_approval.dart';
import 'package:ease_it/utility/drawer.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  int numOfPendingRequests;
  List<Widget> pages = [
    ResidentHome(),
    MyVehicle(),
    Forum(),
    Approval(),
    Maintenance()
  ];

  void getTotalPendingRequests() async {}

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
                      ? StreamBuilder(
                          stream: Database()
                              .getNumberOfPendingUsersForSociety(g.society),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.data.docs.length == 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showToast(
                                              context,
                                              "general",
                                              "All Requests info",
                                              "No pending requests found");
                                        },
                                        icon: Icon(
                                          Icons.people,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 7,
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SecretaryApproval(),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.people,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: Text(
                                              snapshot.data.docs.length > 9
                                                  ? "9+"
                                                  : snapshot.data.docs.length
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xff1a73e8),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showToast(
                                            context,
                                            "general",
                                            "All Requests info",
                                            "Waiting for requests data to load");
                                      },
                                      icon: Icon(
                                        Icons.people,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
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
