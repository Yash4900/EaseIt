//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';

import 'package:ease_it/screens/resident/userApproval.dart';

import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/screens/resident/resident.dart';
import 'package:ease_it/screens/security/security.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String uid;
  Home(this.uid);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  String role = '';

  void getUserInfo(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DocumentSnapshot snapshot =
        await Database().getUserDetails(prefs.getString("society"), uid);

    // Defining user properties globally
    Globals g = Globals();
    g.setSociety = prefs.getString("society");
    Map<String, dynamic> societySnapshot =
        await Database().getSocietyInfo(g.society);
    g.setHierarchy = List<String>.from(societySnapshot["Hierarchy"]);
    //print(societySnapshot["Hierarchy"]);
    //print(g.hierarchy);
    g.setStructure = societySnapshot["structure"];
    g.setUid = uid;
    g.setRole = snapshot.get('role');
    g.setEmail = snapshot.get('email');
    g.setFname = snapshot.get('fname');
    g.setLname = snapshot.get('lname');
    g.setPhoneNum = snapshot.get('phoneNum');
    g.setImageUrl = snapshot.get('imageUrl');
    g.setStatus = snapshot.get('status');

    role = snapshot.get('role');
    if (role != 'Security Guard') {
      g.setHomeRole = snapshot.get('homeRole');
      g.setFlat = snapshot.get('flat');
      g.setFlatNo = snapshot.get('flatNo');
      g.setWing = snapshot.get('wing');
    }

    setState(() => loading = false);
  }

  // void saveTheApprovalUpdate() {
  //   setState(() {});
  // }

  // Decide which screen to show
  Widget showScreen() {
    Globals g = Globals();
    return role == 'Security Guard'
        ? StreamBuilder(
            stream: Database().userStream(g.society, g.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data["status"] == "accepted") {
                    return Security();
                  } else if (snapshot.data["status"] == "pending") {
                    return Pending();
                  } else {
                    return ReApproval();
                  }
                } else {
                  return Scaffold(
                    body: SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 50, color: Colors.redAccent),
                            Text(
                              "Error loading your profile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 50, color: Colors.redAccent),
                          Text(
                            "Error loading your profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          )
        : StreamBuilder(
            stream: Database().userStream(g.society, g.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  if (snapshot.data["status"] == "accepted") {
                    //print("Am I returning Resident Home");
                    return Resident();
                  } else if (snapshot.data["status"] == "pending") {
                    return Pending();
                  } else {
                    return ReApproval();
                  }
                } else {
                  print("In else");
                  return Scaffold(
                    body: SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 50, color: Colors.redAccent),
                            Text(
                              "Error loading your profile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else {
                //print(snapshot.hasData);
                return Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 50, color: Colors.redAccent),
                          Text(
                            "Error loading your profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
  }

  @override
  void initState() {
    getUserInfo(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Scaffold(body: Loading()) : showScreen();
  }
}
