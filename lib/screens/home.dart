import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/screens/resident/resident.dart';
import 'package:ease_it/screens/security/security.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';

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
    DocumentSnapshot snapshot = await Database().getUserDetails(uid);

    // Defining user properties globally
    Globals g = Globals();
    g.setUid = uid;
    g.setRole = snapshot.get('role');
    g.setEmail = snapshot.get('email');
    g.setFname = snapshot.get('fname');
    g.setLname = snapshot.get('lname');
    g.setPhoneNum = snapshot.get('phoneNum');

    role = snapshot.get('role');
    if (role != 'Security Guard') {
      g.setFlatNo = snapshot.get('flatNo');
      g.setWing = snapshot.get('wing');
    }

    setState(() => loading = false);
  }

  // Decide which screen to show
  Widget showScreen() {
    return role == 'Security Guard' ? Security() : Resident();
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
