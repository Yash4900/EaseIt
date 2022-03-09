import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';

class UpcomingEvents extends StatefulWidget {
  @override
  _UpcomingEventsState createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  Globals g = Globals();
  List<String> days = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<Color> colors = [
    Color(0xffe34850),
    Color(0xffe68619),
    Color(0xff2680eb),
    Color(0xff2d9d78)
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Database().fetchUpcomingEvents(g.society),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return snapshot.data.docs.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      DateTime date = ds['date'].toDate();
                      return Container(
                        margin:
                            EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${date.day} ${days[date.month - 1]} ${date.year}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors[index % 4].withOpacity(0.2),
                                  border: Border(
                                    left: BorderSide(
                                        color:
                                            colors[index % 4].withOpacity(0.6),
                                        width: 3),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colors[index % 4],
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 15),
                                      Row(children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 18),
                                        SizedBox(width: 10),
                                        Text(
                                          ds['venue'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ]),
                                      SizedBox(height: 5),
                                      Row(children: [
                                        Icon(Icons.access_time, size: 18),
                                        SizedBox(width: 10),
                                        Text(
                                          ds['isFullDay']
                                              ? 'All day'
                                              : ds['from'] + " - " + ds['to'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
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
                          'No Events found',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  );
          }
        });
  }
}
