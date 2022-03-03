// In this screen details of the parked vehicle of a visitor is displayed

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParkingStatus extends StatefulWidget {
  final String docId;
  final String owner;
  final String phoneNum;
  final String vehicleNo;
  final String parkedAt;
  final DateTime inTime;
  ParkingStatus(this.docId, this.owner, this.phoneNum, this.vehicleNo,
      this.parkedAt, this.inTime);
  @override
  State<ParkingStatus> createState() => _ParkingStatusState();
}

class _ParkingStatusState extends State<ParkingStatus> {
  bool loading = true;
  DocumentSnapshot ds;
  Globals g = Globals();
  fetchData() async {
    ds = await Database().getSingleVehicleLog(g.society, widget.docId);
    setState(() => loading = false);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                  Info("Vehicle Number", widget.vehicleNo),
                  Info("Purpose", ds['purpose']),
                  Info("Parked At", widget.parkedAt),
                  Info("Entry Time", widget.inTime.toString()),
                  SizedBox(height: 20),
                  Text(
                    "OWNER INFO",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Info("Owner Name", widget.owner),
                  Info("Phone Number", widget.phoneNum),
                  Info("Guest At", '${ds['wing']}-${ds['flatNo']}'),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Allocate new parking space",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
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
            style: TextStyle(
                fontSize: 16,
                color: Colors.black38,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
