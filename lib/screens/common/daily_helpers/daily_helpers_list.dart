import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/daily_helpers/daily_helper_log.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyHelpersList extends StatefulWidget {
  @override
  _DailyHelpersListState createState() => _DailyHelpersListState();
}

class _DailyHelpersListState extends State<DailyHelpersList> {
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
                'Daily Helpers',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              flex: 9,
              child: StreamBuilder(
                stream: Database().getAllDailyHelperCategory(g.society, ""),
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
                                width: MediaQuery.of(context).size.width * 0.85,
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DailyHelperLog(ds.id)));
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: ds['imageUrl'] == ""
                                        ? AssetImage('assets/dummy_image.jpg')
                                        : NetworkImage(ds['imageUrl']),
                                  ),
                                  title: Text(
                                    ds['name'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    ds['purpose'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[500]),
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
                                  'No daily helpers found',
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
