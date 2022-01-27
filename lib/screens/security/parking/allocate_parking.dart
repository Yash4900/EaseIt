import 'package:flutter/material.dart';

class AllocateParking extends StatefulWidget {
  final String licensePlateNo;

  AllocateParking(this.licensePlateNo);
  @override
  _AllocateParkingState createState() => _AllocateParkingState();
}

class _AllocateParkingState extends State<AllocateParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: MediaQuery.of(context).size.width * 0.3,
          backgroundColor: Colors.white,
          leading: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.keyboard_backspace, color: Colors.black),
                SizedBox(width: 5),
                Text(
                  'Back',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                'Allocate Parking Space',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Enter the visitor details below',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 30),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Enter owner\'s name'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter owner\'s phone number'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Enter visiting flat'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Enter vehicle model'),
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: Text(
                          'Allocate',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
