import 'package:ease_it/screens/security/parking/allocate_parking.dart';
import 'package:ease_it/utility/firebase_ml_api.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ActionList extends StatefulWidget {
  @override
  _ActionListState createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  void showResidentBottomSheet(String licensePlateNo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      builder: (BuildContext context) {
        return Wrap(children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  licensePlateNo,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text('belongs to a resident!'),
                SizedBox(height: 20),
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: Color(0xff107154),
                  size: 150,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey[200]),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                      ),
                      child: Text(
                        'Log activity',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
      },
    );
  }

  void showVisitorBottomSheet(String licensePlateNo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      builder: (BuildContext context) {
        return Wrap(children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  licensePlateNo,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text('doesn\'t belong to a resident!'),
                SizedBox(height: 20),
                Icon(
                  Icons.warning_amber_outlined,
                  color: Color(0xffe68619),
                  size: 150,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey[200]),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                      ),
                      child: Text(
                        'Log activity',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllocateParking(licensePlateNo)));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                      ),
                      child: Text(
                        'Assign Parking',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: GestureDetector(
            onTap: () async {
              File file = await PickImage().showPicker(context);
              if (file != null) {
                String text = await FirebaseMLApi().recognizeText(file);
                if (text != "") {
                  showVisitorBottomSheet(text);
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 20),
                  Text(
                    "Vehicle Entry",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Card(
          child: GestureDetector(
            onTap: () async {
              File file = await PickImage().showPicker(context);
              if (file != null) {
                String text = await FirebaseMLApi().recognizeText(file);
                if (text != "") {
                  showResidentBottomSheet(text);
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 20),
                  Text(
                    "Vehicle Exit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
