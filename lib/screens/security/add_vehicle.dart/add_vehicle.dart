import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  File _profilePicture;
  TextEditingController _licensePlateController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _parkingNumberController = TextEditingController();
  TextEditingController _wingController = TextEditingController();
  TextEditingController _flatNoController = TextEditingController();

  String dropDownValue = "Four Wheeler";
  List<String> dropDownItems = ["Four Wheeler", "Two Wheeler"];
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
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Text(
                    'Add Vehicle',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add details of vehicle below',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'IMAGE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _profilePicture = await PickImage().showPicker(context);
                      setState(() {});
                    },
                    child: Container(
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _profilePicture == null
                              ? AssetImage('assets/dummy_image.jpg')
                              : FileImage(_profilePicture),
                        ),
                      ),
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'LICENSE PLATE NO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter license plate number'),
                            controller: _licensePlateController,
                            validator: (value) => value.length == 0
                                ? 'Please enter license plate number'
                                : null,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'MODEL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(hintText: 'Enter model'),
                            controller: _modelController,
                            validator: (value) => value.length == 0
                                ? 'Please enter vehicle number'
                                : null,
                          ),
                          SizedBox(width: 20),
                          Row(children: [
                            Text(
                              'VEHICLE TYPE',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            SizedBox(width: 15),
                            DropdownButton(
                              value: dropDownValue,
                              icon: Icon(Icons.keyboard_arrow_down),
                              onChanged: (value) =>
                                  setState(() => dropDownValue = value),
                              items: dropDownItems.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Row(children: [
                                    Icon(item == "Two Wheeler"
                                        ? FontAwesomeIcons.motorcycle
                                        : FontAwesomeIcons.car),
                                    SizedBox(width: 10),
                                    Text(
                                      item,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                );
                              }).toList(),
                            ),
                          ]),
                          SizedBox(height: 10),
                          Text(
                            'PARKING SPACE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Parking space number'),
                            controller: _parkingNumberController,
                            validator: (value) => value.length == 0
                                ? 'Please enter parking space number'
                                : null,
                          ),
                          SizedBox(height: 20),
                          Text("Owner",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          SizedBox(height: 5),
                          Text(
                            'FLAT DETAILS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Wing',
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                  controller: _wingController,
                                  validator: (value) => value.length == 0
                                      ? 'Please enter wing'
                                      : null,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Flat No',
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _flatNoController,
                                  validator: (value) => value.length == 0
                                      ? 'Please enter flat number'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  bool confirmation = await showConfirmationDialog(
                                      context,
                                      "Alert!",
                                      "Are you sure you want to register this vehicle?");
                                  if (confirmation) {
                                    setState(() => loading = true);
                                    String id = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    String imageUrl = _profilePicture == null
                                        ? ""
                                        : await Storage().storeImage(
                                            'vehicles', id, _profilePicture);
                                    await API().addVehicle(
                                        g.society
                                            .replaceAll(" ", "")
                                            .toLowerCase(),
                                        _licensePlateController.text,
                                        _parkingNumberController.text);
                                    Database()
                                        .addVehicle(
                                            g.society,
                                            imageUrl,
                                            _licensePlateController.text,
                                            _modelController.text,
                                            _parkingNumberController.text,
                                            dropDownValue,
                                            _wingController.text,
                                            _flatNoController.text)
                                        .then((value) {
                                      setState(() => loading = false);
                                      Navigator.pop(context);
                                      showToast(context, "success", "Success!",
                                          "Vehicle added successfully in the database.");
                                    }).catchError(() {
                                      setState(() => loading = false);
                                      showToast(context, "error", "Oops!",
                                          "Something went wrong");
                                    });
                                  }
                                }
                              },
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
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
                                child: Text(
                                  'Add Vehicle',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
    );
  }
}
