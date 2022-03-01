import 'package:ease_it/screens/security/add_vehicle.dart/add_vehicle.dart';
import 'package:ease_it/screens/security/parking/vehicle_bottom_sheet.dart';
import 'package:ease_it/utility/firebase_ml_api.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionList extends StatefulWidget {
  @override
  _ActionListState createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            onTap: () async {
              File file = await PickImage().showPicker(context);
              if (file != null) {
                String text = await FirebaseMLApi().recognizeText(file);
                if (text != "") {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) =>
                            VehicleBottomSheet(text, true)),
                  );
                }
              }
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.login, color: Colors.grey[700]),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 16,
            ),
            title: Text(
              "Vehicle Entry",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async {
              File file = await PickImage().showPicker(context);
              if (file != null) {
                String text = await FirebaseMLApi().recognizeText(file);
                if (text != "") {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) =>
                            VehicleBottomSheet(text, false)),
                  );
                }
              }
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.logout, color: Colors.grey[700]),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 16,
            ),
            title: Text(
              "Vehicle Exit",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddVehicle()));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(FontAwesomeIcons.car, color: Colors.grey[700]),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 16,
            ),
            title: Text(
              "Register Vehicle",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
