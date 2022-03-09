import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';

class VehicleLog extends StatefulWidget {
  @override
  _VehicleLogState createState() => _VehicleLogState();
}

class _VehicleLogState extends State<VehicleLog> {
  Globals g = Globals();

  String formatValue(int num) {
    if (num < 10) {
      return '0' + num.toString();
    } else
      return num.toString();
  }

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
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          ds['licensePlateNo'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                                Text(
                                  '  ${ds['wing']}-${ds['flatNo']}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
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
                                  '  ${formatValue(entryTime.hour)}:${formatValue(entryTime.minute)} - ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                exitTime != null
                                    ? Text(
                                        '${formatValue(exitTime.hour)}:${formatValue(exitTime.minute)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Text(
                                        'present',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
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
                      Image.asset(
                        'assets/no_data.png',
                        width: 300,
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
