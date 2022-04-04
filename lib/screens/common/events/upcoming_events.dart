import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';

class UpcomingEvents extends StatefulWidget {
  @override
  _UpcomingEventsState createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  Globals g = Globals();
  List<String> days = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
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
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${date.day} ${days[date.month - 1]} ${date.year}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ds['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: colors[index % 4],
                                                  fontSize: 16),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final Event event = Event(
                                                  title: ds['name'],
                                                  description: 'Society event',
                                                  location: ds['venue'],
                                                  allDay: ds['isFullDay'],
                                                  startDate: ds['isFullDay']
                                                      ? date
                                                      : DateTime(
                                                          date.year,
                                                          date.month,
                                                          date.day,
                                                          int.parse(ds['from']
                                                              .split(':')[0]),
                                                          int.parse(ds['from']
                                                              .split(':')[1])),
                                                  endDate: ds['isFullDay']
                                                      ? date
                                                      : DateTime(
                                                          date.year,
                                                          date.month,
                                                          date.day,
                                                          int.parse(ds['to']
                                                              .split(':')[0]),
                                                          int.parse(ds['to']
                                                              .split(':')[1])),
                                                );
                                                Add2Calendar.addEvent2Cal(
                                                    event);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3, horizontal: 5),
                                                decoration: BoxDecoration(
                                                  color: colors[index % 4]
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.event,
                                                  color: colors[index % 4],
                                                ),
                                              ),
                                            )
                                          ]),
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
