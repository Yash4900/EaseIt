import 'package:ease_it/firebase/database2.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ApproveVisitor extends StatefulWidget {
  @override
  _ApproveVisitorState createState() => _ApproveVisitorState();
}

class _ApproveVisitorState extends State<ApproveVisitor> {
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

  String dropDownValue = "Maid";
  File _profilePicture;
  Globals g = Globals();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _flatController = TextEditingController();
  TextEditingController _wingController = TextEditingController();
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
        padding: EdgeInsets.all(15),
        child: loading
            ? Loading()
            : ListView(
                children: [
                  Text(
                    'Visitor Approval',
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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'NAME',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Enter name'),
                          controller: _nameController,
                          validator: (value) => value.length == 0
                              ? 'Please enter visitor name'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'PHONE NUMBER',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter phone number'),
                          controller: _phoneController,
                          validator: (value) => value.length < 10
                              ? 'Please enter a phone number'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'WING AND FLAT',
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
                                controller: _flatController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(children: [
                          Text(
                            'PURPOSE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 15),
                          DropdownButton(
                            value: dropDownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            onChanged: (value) =>
                                setState(() => dropDownValue = value),
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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                bool confirmation = await showConfirmationDialog(
                                    context,
                                    "Alert!",
                                    "Are you sure you want to send this request?");
                                if (confirmation) {
                                  setState(() => loading = true);
                                  String id = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  String imageUrl = _profilePicture == null
                                      ? ""
                                      : await Storage().storeImage(
                                          'dailyHelpers', id, _profilePicture);
                                  Database2()
                                      .sendApproval(
                                          g.society,
                                          _nameController.text,
                                          _phoneController.text,
                                          imageUrl,
                                          dropDownValue,
                                          _wingController.text,
                                          _flatController.text)
                                      .then((value) {
                                    setState(() => loading = false);
                                    showToast(context, "success", "Success!",
                                        "Approval request sent successfully");
                                    Navigator.pop(context);
                                  });
                                }
                              }
                            },
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
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
                              child: Text(
                                'Send Request',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
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
