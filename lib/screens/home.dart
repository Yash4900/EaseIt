import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
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

    role = snapshot.get('role');
    if (role != 'Security Guard') {
      g.setFlat = snapshot.get('flat');
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
