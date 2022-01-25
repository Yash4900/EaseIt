import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarDetail {
  String owner;
  String phoneNum;
  String flatNo;
  String vehicleNo;
  String model;
  String parkedAt;
  DateTime inTime;
}

class ParkingStatus extends StatelessWidget {
  final String owner;
  final String phoneNum;
  final String flatNo;
  final String vehicleNo;
  final String model;
  final String parkedAt;
  final DateTime inTime;
  ParkingStatus(this.owner, this.phoneNum, this.flatNo, this.vehicleNo,
      this.model, this.parkedAt, this.inTime);

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
              Icon(Icons.arrow_back, color: Colors.black),
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
        child: Column(
          children: [
            Text(
              "Visitor Parking Status",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "VEHICLE INFO",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Info("Vehicle Number", vehicleNo),
            Info("Model", model),
            Info("Parked At", parkedAt),
            Info("Entry Time", inTime.toString()),
            SizedBox(height: 20),
            Text(
              "OWNER INFO",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Info("Owner Name", owner),
            Info("Phone Number", phoneNum),
            Info("Guest At", flatNo),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {},
              child: Text(
                "Allocate new parking space",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call),
                    SizedBox(width: 10),
                    Text(
                      "Call Owner",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final String attribute;
  final String value;
  Info(this.attribute, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$attribute:  ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }
}
