import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Globals g = Globals();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: ListView(
        children: [
          Text(
            'Hello, ${g.fname}',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
