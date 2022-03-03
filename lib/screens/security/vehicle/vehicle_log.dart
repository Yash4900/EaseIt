import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VehicleLog extends StatefulWidget {
  @override
  _VehicleLogState createState() => _VehicleLogState();
}

class _VehicleLogState extends State<VehicleLog> {
  Globals g = Globals();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database().getvehicleLog(g.society),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          return snapshot.data.docs.length > 0
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    DateTime entryTime = ds['entryTime'].toDate();

                    DateTime exitTime;
                    try {
                      exitTime = ds['exitTime'].toDate();
                    } catch (e) {
                      exitTime = null;
                    }
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 3.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          ds['licensePlateNo'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                Text('  ${ds['wing']}-${ds['flatNo']}')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                Text(
                                    '  ${entryTime.hour}:${entryTime.minute}:${entryTime.second} - '),
                                exitTime != null
                                    ? Text(
                                        '${exitTime.hour}:${exitTime.minute}:${exitTime.second}')
                                    : Text('present'),
                              ],
                            )
                          ],
                        ),
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff037DD6).withOpacity(0.2),
                          ),
                          child: Text(
                            ds['purpose'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff037DD6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.search,
                        size: 50,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No Recent Approvals',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                );
        }
      },
    );
  }
}
