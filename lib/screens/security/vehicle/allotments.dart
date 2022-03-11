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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 3.0,
                            spreadRadius: 1.0,
                          ),
                        ],
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
                        title: Text(
                          ds['licensePlateNo'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Owner',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Text(
                              '${ds['owner']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Color(0xff037DD6).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
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
                      ),
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
