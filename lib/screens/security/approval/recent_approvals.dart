import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';

class RecentApproval extends StatefulWidget {
  @override
  _RecentApprovalState createState() => _RecentApprovalState();
}

class _RecentApprovalState extends State<RecentApproval> {
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

  Color getColor(String status) {
    if (status == "PENDING") return Color(0xff095aba);
    if (status == "APPROVED") return Color(0xff107154);
    return Color(0xffbb121a);
  }

  String formatValue(int num) {
    return num < 10 ? '0' + num.toString() : num.toString();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database().getRecentVisitorApproval(g.society),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          return snapshot.data.docs.length > 0
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    DateTime date = ds['postedOn'].toDate();
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      padding: EdgeInsets.only(bottom: 7),
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
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: ds['imageUrl'] == ""
                              ? AssetImage('assets/dummy_image.jpg')
                              : NetworkImage(ds['imageUrl']),
                        ),
                        title: Text(
                          ds['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              '${ds['purpose']} . ${ds['wing']}-${ds['flatNo']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500]),
                            ),
                            Text(
                              "${formatValue(date.hour)}:${formatValue(date.minute)}, ${date.day} ${days[date.month]} ${date.year}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500]),
                            )
                          ],
                        ),
                        trailing: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: getColor(ds['status'].toUpperCase())
                                .withOpacity(0.2),
                          ),
                          child: Text(
                            ds['status'].toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                color: getColor(ds['status'].toUpperCase()),
                                fontWeight: FontWeight.w600),
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
