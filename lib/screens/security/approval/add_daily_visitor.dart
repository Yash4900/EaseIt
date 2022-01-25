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
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter phone number'),
                ),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () async {
                      String flat = await showFlatDialog();
                      if (flat != "") {
                        flats.add(flat);
                        setState(() {});
                      }
                      wingController.clear();
                      flatController.clear();
                    },
                    child: Text(
                      'Add Flat',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Wrap(
                  children: flats
                      .map(
                        (flat) => Container(
                          margin: EdgeInsets.all(5),
                          width: 100,
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
                              IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    flats.remove(flat);
                                    setState(() {});
                                  })
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(width: 20),
                Row(children: [
                  Text(
                    "Purpose",
                    style: TextStyle(fontSize: 16),
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
                          MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 3, 50, 3),
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
