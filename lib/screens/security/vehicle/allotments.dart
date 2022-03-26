// Displays list of currently parked visitor vehicles in society

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'parking_status.dart';

class Allotments extends StatefulWidget {
  @override
  _AllotmentsState createState() => _AllotmentsState();
}

class _AllotmentsState extends State<Allotments> {
  Globals g = Globals();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database().getParkingStatus(g.society),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          return snapshot.data.docs.length > 0
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    print(ds);
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]),
                        ),
                      ),
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParkingStatus(
                                  ds.id,
                                  ds['owner'],
                                  ds['phoneNum'],
                                  ds['licensePlateNo'],
                                  ds['parkingSpace'],
                                  ds['timestamp'].toDate(),
                                ),
                              ),
                            );
                          },
                          title: Row(children: [
                            Text(
                              ds['licensePlateNo'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff037DD6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                ds['parkingSpace'],
                                style: TextStyle(
                                  color: Color(0xff037DD6),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds['owner'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '+91-${ds['phoneNum']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          trailing: DateTime.now().isAfter(ds['timestamp']
                                  .toDate()
                                  .add(Duration(hours: ds['stayTime'])))
                              ? Icon(
                                  Icons.warning,
                                  color: Color(0xffcb6f10).withOpacity(0.7),
                                )
                              : null),
                    );
                  })
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/no_data.png',
                        width: 300,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No parking allotments',
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
