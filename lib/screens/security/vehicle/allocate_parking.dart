import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';

class AllocateParking extends StatefulWidget {
  final String licensePlateNo;

  AllocateParking(this.licensePlateNo);
  @override
  _AllocateParkingState createState() => _AllocateParkingState();
}

class _AllocateParkingState extends State<AllocateParking> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _purposeController = TextEditingController();
  TextEditingController _flatController = TextEditingController();
  TextEditingController _wingController = TextEditingController();
  TextEditingController _stayTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Globals g = Globals();
  bool loading = false;
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
        child: loading
            ? Loading()
            : ListView(
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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NAME',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter owner\'s name'),
                          controller: _nameController,
                          validator: (value) =>
                              value.length == 0 ? 'Enter owner name' : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'PHONE NUMBER',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter owner\'s phone number'),
                          controller: _phoneController,
                          validator: (value) =>
                              value.length == 0 ? 'Enter phone number' : null,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'PURPOSE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter purpose'),
                          controller: _purposeController,
                          validator: (value) =>
                              value.length == 0 ? 'Enter purpose' : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'FLAT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Enter wing'),
                                controller: _wingController,
                                validator: (value) =>
                                    value.length == 0 ? 'Enter wing' : null,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter visiting flat'),
                                controller: _flatController,
                                validator: (value) => value.length == 0
                                    ? 'Enter flat number'
                                    : null,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter expected stay time'),
                                controller: _stayTimeController,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                bool confirmation =
                                    await showConfirmationDialog(
                                        context,
                                        "Alert!",
                                        "Are you sure you want to proceed?");
                                if (confirmation) {
                                  setState(() => loading = true);
                                  var response = await API().allocateParking(
                                      g.society
                                          .replaceAll(" ", "")
                                          .toLowerCase(),
                                      _stayTimeController.text);
                                  Map<String, dynamic> map =
                                      jsonDecode(response);
                                  DocumentReference dr;
                                  if (map['parking_space'] != '') {
                                    dr = await Database().saveParkingDetails(
                                        g.society,
                                        widget.licensePlateNo,
                                        _nameController.text,
                                        _phoneController.text,
                                        map['parking_space']);
                                    setState(() => loading = false);
                                    await showAlertDialog(
                                        context,
                                        'Parking Assignment',
                                        'Parking assignment is ${map['parking_space']}');
                                  }
                                  Database().logVisitorVehicleEntry(
                                      g.society,
                                      widget.licensePlateNo,
                                      _flatController.text,
                                      _wingController.text,
                                      _purposeController.text,
                                      dr.id);
                                }
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                'Allocate',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
