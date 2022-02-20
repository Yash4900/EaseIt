import 'package:ease_it/utility/pick_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddDailyVisitor extends StatefulWidget {
  @override
  _AddDailyVisitorState createState() => _AddDailyVisitorState();
}

class _AddDailyVisitorState extends State<AddDailyVisitor> {
  List<String> dropDownItems = [
    "Maid",
    "Cook",
    "Driver",
    "Milkman",
    "Newspaper",
    "Laundry",
    "Car Cleaner",
    "Gym Instructor",
    "Tution Teacher",
    "Mechanic",
    "Plumber",
    "Delivery",
    "Technician",
    "Nanny",
    "Salesman"
  ];

  TextEditingController flatController = TextEditingController();
  TextEditingController wingController = TextEditingController();

  String dropDownValue = "Maid";

  Future<String> showFlatDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Flat'),
        content: Container(
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Wing',
                    hintStyle: TextStyle(fontSize: 16),
                  ),
                  controller: wingController,
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
                  controller: flatController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop("");
            },
            child: Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              if (wingController.text == "" || flatController.text == "") {
                Navigator.of(context).pop("");
              } else {
                Navigator.of(context)
                    .pop(wingController.text + "-" + flatController.text);
              }
            },
            child: Text("ADD"),
          )
        ],
      ),
    );
  }

  List<String> flats = [];

  File _profilePicture;

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
              'Add to Daily Visitor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Add visitor details below',
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
                        ? AssetImage('assets/profile_dummy.png')
                        : FileImage(_profilePicture),
                  ),
                ),
              ),
            ),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'NAME',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Enter visitor\'s name'),
                ),
                SizedBox(height: 20),
                Text(
                  'PHONE NUMBER',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Enter visitor\'s phone number'),
                ),
                SizedBox(height: 20),
                Row(children: [
                  Text(
                    'FLATS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      String flat = await showFlatDialog();
                      if (flat != "") {
                        flats.add(flat);
                        setState(() {});
                      }
                      wingController.clear();
                      flatController.clear();
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xff1a73e8).withOpacity(0.2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 16, color: Color(0xff1a73e8)),
                          Icon(Icons.home_outlined,
                              size: 16, color: Color(0xff1a73e8))
                        ],
                      ),
                    ),
                  )
                ]),
                SizedBox(height: 5),
                Wrap(
                  children: flats
                      .map(
                        (flat) => InkWell(
                          onTap: () {
                            flats.remove(flat);
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 15),
                                Text(flat),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.clear,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(width: 20),
                Row(children: [
                  Text(
                    'PURPOSE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(width: 15),
                  DropdownButton(
                    value: dropDownValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onChanged: (value) => setState(() => dropDownValue = value),
                    items: dropDownItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
                SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
                      child: Text(
                        'Add',
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
