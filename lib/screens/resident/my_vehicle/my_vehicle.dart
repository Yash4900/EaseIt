import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:io';

class MyVehicle extends StatefulWidget {
  @override
  _MyVehicleState createState() => _MyVehicleState();
}

class _MyVehicleState extends State<MyVehicle> {
  Globals g = Globals();

  void showBottomSheeet(String imageUrl, String licensePlateNo, String model) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 90,
                ),
                SizedBox(height: 10),
                Text(
                  model,
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 25, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 5),
                Text(
                  licensePlateNo,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Text(
                  'Monthly usage',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '23',
                      style:
                          TextStyle(fontSize: 70, fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        'times',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'My Vehicles',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              flex: 8,
              child: FutureBuilder(
                future: Database().getMyVehicle(g.society, g.wing, g.flatNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else {
                    return snapshot.data.docs.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return Card(
                                child: ListTile(
                                  onTap: () => showBottomSheeet(ds['imageUrl'],
                                      ds['licensePlateNo'], ds['model']),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(ds['imageUrl']),
                                    radius: 25,
                                  ),
                                  title: Text(
                                    ds['model'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(ds['licensePlateNo']),
                                  trailing: ds['vehicleType'] == 'Four Wheeler'
                                      ? Icon(FontAwesomeIcons.car)
                                      : Icon(FontAwesomeIcons.motorcycle),
                                ),
                              );
                            })
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.car,
                                  size: 50,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No Events found',
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
