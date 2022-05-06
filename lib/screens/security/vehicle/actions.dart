import 'package:ease_it/screens/security/add_vehicle.dart/add_vehicle.dart';
import 'package:ease_it/screens/security/vehicle/parking_space_list.dart';
import 'package:ease_it/screens/security/vehicle/vehicle_bottom_sheet.dart';
import 'package:ease_it/screens/security/vehicle/vehicle_list.dart';
import 'package:ease_it/utility/image/firebase_ml_api.dart';
import 'package:ease_it/utility/image/pick_image.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ActionList extends StatefulWidget {
  @override
  _ActionListState createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  bool scanningInProgress = false;
  @override
  Widget build(BuildContext context) {
    return scanningInProgress
        ? ScanningInProgress()
        : Column(
            children: [
              Card(
                child: ListTile(
                  onTap: () async {
                    File file = await PickImage().showPicker(context, 50);
                    if (file != null) {
                      setState(() => scanningInProgress = true);
                      String text = await FirebaseMLApi().recognizeText(file);
                      setState(() => scanningInProgress = false);
                      if (text != "") {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) =>
                                VehicleBottomSheet(text, true),
                          ),
                        );
                      } else {
                        showToast(context, 'error', 'Oops!',
                            'License plate not found!');
                      }
                    }
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.login,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  title: Text(
                    "Vehicle Entry",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () async {
                    File file = await PickImage().showPicker(context, 50);
                    if (file != null) {
                      setState(() => scanningInProgress = true);
                      String text = await FirebaseMLApi().recognizeText(file);
                      setState(() => scanningInProgress = false);
                      if (text != "") {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) =>
                                VehicleBottomSheet(text, false),
                          ),
                        );
                      } else {
                        showToast(context, 'error', 'Oops!',
                            'License plate not found!');
                      }
                    }
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.logout,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  title: Text(
                    "Vehicle Exit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddVehicle(),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Image.asset('assets/parking.png', height: 20),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  title: Text(
                    "Register Vehicle",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleList(),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.emoji_transportation,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  title: Text(
                    "Vehicle List",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParkingSpaceList(),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.local_parking,
                      color: Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  title: Text(
                    "Parking Spaces",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}

class ScanningInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pageview_outlined,
            color: Colors.black12,
          ),
          Text(
            'Scanning Image',
            style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
