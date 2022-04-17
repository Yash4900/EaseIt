import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/flat_data.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/display/custom_dropdown_widget.dart';

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
  // TextEditingController _flatController = TextEditingController();
  // TextEditingController _wingController = TextEditingController();
  TextEditingController _stayTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Globals g = Globals();
  bool loading = false;
  String errorText = "";
  FlatData flatVar = FlatData();

  @override
  void initState() {
    super.initState();
    getSocietyStructure(g.society);
  }

  void _update() {
    setState(() {});
  }

  void getSocietyStructure(String societyValue) async {
    setState(() => loading = true);
    //print(List<String>.from(societyStructureWidget[societyStructureWidget["Hierarchy"][0]]));
    //Empty all previous data and set new data
    //print(
    //    "%%%%%%%%%%%%%%%%%%%%% getSocietyStructure is called %%%%%%%%%%%%%%%%%%%%%");
    //print("Set error text to null");
    errorText = "";
    //print("Clearing the Widget form that I have created");
    flatVar.clearFlatWidgetForm();
    //print("Clearing the flat values map");
    flatVar.clearFlatNum();
    //print("Clearing the flat value list");
    flatVar.clearFlatValue();
    //print("Setting current level");
    flatVar.setCurrentLevel = 1;
    //print("Setting widget flat form to empty");
    flatVar.setFlatWidgetForm = [];
    //print("Setting all update functions to null");
    flatVar.setAllUpdateFunctions = [];

    //get society info
    Map<dynamic, dynamic> tempSnapData =
        await Database().getSocietyInfo(societyValue);
    //print("The data: $tempSnapData");

    //set structure
    //print("Setting the structure to incoming data");
    flatVar.setStructure = Map<String, dynamic>.from(tempSnapData);
    //print("Setting the total levels of hierarchy");
    flatVar.setTotalLevels =
        tempSnapData["Hierarchy"].length; // set total levels
    //print("Flat value list to null");
    flatVar.setFlatValue =
        List<String>.filled(flatVar.totalLevels, null, growable: true);
    //print("Adding initial dropdown to the flatWidgetForm that is the list");
    flatVar.addInFlatWidgetForm(CustomDropDown(
      options: flatVar.getILevelInHierarchy(flatVar.currentLevel),
      typeText: flatVar.getTypeText(flatVar.currentLevel),
      flatVariable: flatVar,
      update: _update,
    ));
    //print(
    //    "%%%%%%%%%%%%%%%%%%%%% getSocietyStructure is called %%%%%%%%%%%%%%%%%%%%%");
    //print(societyStructureWidget);
    setState(() => loading = false);
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
                        Column(
                          //physics: ClampingScrollPhysics(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(flatVar.flatWidgetForm.length, (i) {
                            //return flatVar.flatWidgetForm[i];
                            if ((i + 1) % 2 == 1) {
                              if (i + 1 < flatVar.flatWidgetForm.length) {
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: flatVar.flatWidgetForm[i],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: flatVar.flatWidgetForm[i + 1],
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: flatVar.flatWidgetForm[i],
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return SizedBox();
                            }
                          }),
                        ),
                        Text(
                          errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter expected stay time'),
                          controller: _stayTimeController,
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (!flatVar.flatValue.contains(null)) {
                                  setState(() {
                                    errorText = "";
                                  });
                                  bool confirmation =
                                      await showConfirmationDialog(
                                          context,
                                          "Alert!",
                                          "Are you sure you want to proceed?");
                                  if (confirmation) {
                                    setState(() => loading = true);
                                    QuerySnapshot qs = await Database()
                                        .findGuestSpace(g.society);
                                    String parkingSpaceAllocated;
                                    if (qs.docs.length == 0) {
                                      var response = await API()
                                          .allocateParking(
                                              g.society
                                                  .replaceAll(" ", "")
                                                  .toLowerCase(),
                                              _stayTimeController.text);
                                      Map<String, dynamic> map =
                                          jsonDecode(response);
                                      parkingSpaceAllocated =
                                          map['parking_space'];
                                    } else {
                                      parkingSpaceAllocated = qs.docs[0].id;
                                    }
                                    print(parkingSpaceAllocated);
                                    DocumentReference dr;
                                    if (parkingSpaceAllocated != '') {
                                      dr = await Database().saveParkingDetails(
                                        g.society,
                                        widget.licensePlateNo,
                                        _nameController.text,
                                        _phoneController.text,
                                        parkingSpaceAllocated,
                                        int.parse(_stayTimeController.text),
                                      );
                                      setState(() => loading = false);
                                      await showMessageDialog(
                                          context, 'Parking Assignment', [
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
                                            parkingSpaceAllocated,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ]);
                                      flatVar.createMapFromListForFlat();
                                      Database().logVisitorVehicleEntry(
                                          g.society,
                                          widget.licensePlateNo,
                                          flatVar.flatNum,
                                          _purposeController.text,
                                          dr.id);
                                    }
                                    Database().updateParkingStatus(
                                        g.society, parkingSpaceAllocated, true);
                                  }
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                } else {
                                  setState(() {
                                    errorText =
                                        "Please fill all the flat fields";
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                'Allocate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
