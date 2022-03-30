import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';

class DailyHelperLog extends StatefulWidget {
  final String docId;
  DailyHelperLog(this.docId);
  @override
  _DailyHelperLogState createState() => _DailyHelperLogState();
}

class _DailyHelperLogState extends State<DailyHelperLog> {
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
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: Database().getDailyVisitorLog(g.society, widget.docId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else {
              return snapshot.data.docs.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        DateTime date = ds['timestamp'].toDate();
                        return Container(
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 7),
                                decoration: BoxDecoration(
                                  color: ds['activity'] == 'exit'
                                      ? Color(0xffbb121a).withOpacity(0.2)
                                      : Color(0xff107154).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  ds['activity'].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ds['activity'] == 'exit'
                                        ? Color(0xffbb121a)
                                        : Color(0xff107154),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                '${date.day} ${days[date.month]}, ${date.year}   ${date.hour}:${date.minute}:${date.second}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            ],
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
                            'No logs found',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
