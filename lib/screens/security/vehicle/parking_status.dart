// In this screen details of the parked vehicle of a visitor is displayed

import 'dart:convert';
import 'package:ease_it/utility/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/alert.dart';
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
  bool visible = false;
  String btnText = "Allocate new parking space";
  DocumentSnapshot ds;
  TextEditingController _stayTimeController = TextEditingController();
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
              Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Text(
                    "Visitor Parking Status",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "VEHICLE INFO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Info("Vehicle Number", widget.vehicleNo),
                  Info("Purpose", ds['purpose']),
                  Info("Parked At", widget.parkedAt),
                  Info("Entry Time", widget.inTime.toString()),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "OWNER INFO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Info("Owner Name", widget.owner),
                  Info("Phone Number", widget.phoneNum),
                  Info("Guest At", '${ds['wing']}-${ds['flatNo']}'),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      if (btnText == "Allocate new parking space") {
                        btnText = "Cancel";
                      } else {
                        btnText = "Allocate new parking space";
                      }
                      visible = !visible;
                      setState(() {});
                    },
                    child: Text(
                      btnText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  visible
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter stay time',
                                ),
                                textAlign: TextAlign.center,
                                controller: _stayTimeController,
                                validator: (value) =>
                                    int.tryParse(_stayTimeController.text) ==
                                            null
                                        ? 'Enter numeric value'
                                        : null,
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  await API().disAllocateParking(
                                      g.society.replaceAll(" ", ""),
                                      widget.parkedAt);
                                  setState(() => loading = true);
                                  var response = await API().allocateParking(
                                      g.society
                                          .replaceAll(" ", "")
                                          .toLowerCase(),
                                      _stayTimeController.text);
                                  Map<String, dynamic> map =
                                      jsonDecode(response);
                                  if (map['parking_space'] != '') {
                                    setState(() => loading = false);
                                    await Database().updateParkingSpace(
                                        g.society,
                                        widget.docId,
                                        map['parking_space']);
                                    await showMessageDialog(
                                        context, 'Parking Assignment', '', [
                                      Center(
                                        child: Image.asset(
                                          'assets/success.png',
                                          width: 230,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'Parking space allotment is',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          map['parking_space'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]);
                                  }
                                },
                                child: Text(
                                  'Allocate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff037DD6)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      try {
                        await launch('tel:${widget.phoneNum}');
                      } catch (e) {
                        showToast(
                            context, 'error', 'Oops!', 'Something went wrong!');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call),
                        SizedBox(width: 10),
                        Text(
                          "Call Owner",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
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
