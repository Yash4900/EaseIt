import 'package:flutter/material.dart';

class ComplaintStatusPage extends StatefulWidget {
  ComplaintStatusPage({Key key}) : super(key: key);

  @override
  State<ComplaintStatusPage> createState() => _ComplaintStatusPageState();
}

class _ComplaintStatusPageState extends State<ComplaintStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 25,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Complaint Progress",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
