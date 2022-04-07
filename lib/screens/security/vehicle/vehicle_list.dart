import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleList extends StatefulWidget {
  @override
  _VehicleListState createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  Globals g = Globals();

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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Vehicle List',
                style: GoogleFonts.sourceSansPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              flex: 11,
              child: StreamBuilder(
                stream: Database().getAllVehicles(g.society),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else {
                    return snapshot.data.docs.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[300]),
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(ds['imageUrl']),
                                    backgroundColor: Colors.grey[300],
                                    radius: 25,
                                  ),
                                  title: Text(
                                    ds['model'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds['licensePlateNo'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.home_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            FlatDataOperations(
                                                    hierarchy: g.hierarchy,
                                                    flatNum: Map<String,
                                                            String>.from(
                                                        ds['flat']))
                                                .returnStringFormOfFlatMap(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffcb6f10).withOpacity(0.2),
                                    ),
                                    child: Text(
                                      ds['parkingSpaceNo'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xffcb6f10),
                                        fontWeight: FontWeight.w700,
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
                                  'No vehicles found',
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
