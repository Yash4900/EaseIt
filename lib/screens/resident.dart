// Resident Landing page

import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';

class Resident extends StatefulWidget {
  @override
  _ResidentState createState() => _ResidentState();
}

class _ResidentState extends State<Resident> {
  Globals g = Globals();
  String name;

  @override
  void initState() {
    name = g.fname + " " + g.lname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Hello, $name',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }
}
