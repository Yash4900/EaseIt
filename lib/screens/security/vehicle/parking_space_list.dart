import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParkingSpaceList extends StatefulWidget {
  @override
  State<ParkingSpaceList> createState() => _ParkingSpaceListState();
}

class _ParkingSpaceListState extends State<ParkingSpaceList> {
  Globals g = Globals();
  String category = "All";
  List<String> dropDownItems = ["All", "Resident", "Guest"];

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
              Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Parking Spaces',
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10),
                        DropdownButton(
                          value: category,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                          onChanged: (value) =>
                              setState(() => category = value),
                          items: dropDownItems.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ]),
            ),
            Expanded(
              flex: 12,
              child: StreamBuilder(
                stream: Database().getAllParkingSpace(g.society),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else {
                    if (snapshot.data.docs.length == 0) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/no_data.png',
                            width: 300,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No Parking Spaces',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          if (category == 'All' ||
                              ds['type'] == category.toUpperCase()) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  ds.id,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Row(children: [
                                  Text(
                                    'TYPE: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ds['type'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ]),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ds['occupied']
                                        ? Color(0xffda7b11).withOpacity(0.2)
                                        : Color(0xff268e6c).withOpacity(0.2),
                                  ),
                                  child: Text(
                                    ds['occupied'] ? 'Occupied' : 'Available',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: ds['occupied']
                                          ? Color(0xffda7b11)
                                          : Color(0xff268e6c),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      );
                    }
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
