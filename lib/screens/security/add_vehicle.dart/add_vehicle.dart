import 'package:ease_it/utility/pick_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  File _profilePicture;
  String dropDownValue = "Four Wheeler";
  List<String> dropDownItems = ["Four Wheeler", "Two Wheeler"];

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
                height: MediaQuery.of(context).size.height * 0.3,
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
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Enter license plate number'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter model'),
                ),
                SizedBox(width: 20),
                Row(children: [
                  Text(
                    "Vehicle Type",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 15),
                  DropdownButton(
                    value: dropDownValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onChanged: (value) => setState(() => dropDownValue = value),
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
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Parking space number'),
                ),
                SizedBox(height: 20),
                Text("Owner",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Wing',
                          hintStyle: TextStyle(fontSize: 16),
                        ),
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 3, 50, 3),
                      child: Text(
                        'Add Vehicle',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
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
