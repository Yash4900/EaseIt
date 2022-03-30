// Shows all past approvals

import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/flat_data_operations.dart';

class ApprovalsList extends StatefulWidget {
  @override
  _ApprovalsListState createState() => _ApprovalsListState();
}

class _ApprovalsListState extends State<ApprovalsList> {
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

  bool showCurrentlyInside = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Checkbox(
              value: showCurrentlyInside,
              activeColor: Color(0xff037DD6),
              checkColor: Colors.white,
              onChanged: (value) {
                setState(() => showCurrentlyInside = value);
              },
            ),
            Text(
              'Visitors Currently Inside',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: showCurrentlyInside ? Colors.black : Colors.black38,
              ),
            )
          ],
        ),
      ),
      Expanded(
        flex: 11,
        child: StreamBuilder(
          stream: Database().getPastVisitorApproval(g.society),
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
                        if (ds['exitTime'] != null) {
                          exitTime = ds['exitTime'].toDate();
                        }
                        if (!showCurrentlyInside ||
                            (showCurrentlyInside && exitTime == null)) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 2),
                            padding: EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[300]),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(5),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: ds['imageUrl'] == ""
                                    ? AssetImage('assets/dummy_image.jpg')
                                    : NetworkImage(ds['imageUrl']),
                              ),
                              title: Container(
                                child: Row(children: [
                                  InkWell(
                                    onTap: () async {
                                      try {
                                        await launch('tel:${ds['phoneNum']}');
                                      } catch (e) {
                                        showToast(context, 'error', 'Oops!',
                                            'Something went wrong!');
                                      }
                                    },
                                    child: Text(
                                      ds['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          getColor(ds['status'].toUpperCase())
                                              .withOpacity(0.2),
                                    ),
                                    child: Text(
                                      ds['status'].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: getColor(
                                            ds['status'].toUpperCase()),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    '${ds['purpose']} . ${FlatDataOperations(hierarchy: g.hierarchy, flatNum: Map<String, String>.from(ds['flat'])).returnStringFormOfFlatMap()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                      fontSize: 10,
                                    ),
                                  ),
                                  Row(children: [
                                    Icon(
                                      Icons.login,
                                      color: Colors.grey,
                                      size: 17,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${formatValue(entryTime.hour)}:${formatValue(entryTime.minute)}, ${entryTime.day} ${days[entryTime.month]} ${entryTime.year}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ]),
                                  ds['exitTime'] == null
                                      ? SizedBox()
                                      : Row(children: [
                                          Icon(
                                            Icons.logout,
                                            color: Colors.grey,
                                            size: 17,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${formatValue(exitTime.hour)}:${formatValue(exitTime.minute)}, ${exitTime.day} ${days[exitTime.month]} ${exitTime.year}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ]),
                                ],
                              ),
                              trailing: ds['exitTime'] == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      radius: 20,
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () async {
                                            bool confirmation =
                                                await showConfirmationDialog(
                                                    context,
                                                    'Alert!',
                                                    'Are you sure you want to log visitor exit?');
                                            if (confirmation) {
                                              try {
                                                await Database()
                                                    .markVisitorExit(
                                                        g.society, ds.id);
                                                showToast(
                                                    context,
                                                    'success',
                                                    'Success!',
                                                    'Log made successfully');
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.directions_run,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
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
        ),
      ),
    ]);
  }
}
