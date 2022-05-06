// Shows all pre approvals

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ease_it/utility/flat_data_operations.dart';

class PreApprovals extends StatefulWidget {
  @override
  _PreApprovalsState createState() => _PreApprovalsState();
}

class _PreApprovalsState extends State<PreApprovals> {
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
          stream: Database().getAllPreApprovals(g.society),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else {
              return snapshot.data.docs.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        DateTime entryTime;
                        if (ds['entryTime'] != null) {
                          entryTime = ds['entryTime'].toDate();
                        }
                        DateTime exitTime;
                        if (ds['exitTime'] != null) {
                          exitTime = ds['exitTime'].toDate();
                        }
                        if (!showCurrentlyInside ||
                            (showCurrentlyInside &&
                                exitTime == null &&
                                entryTime != null)) {
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
                            child: Column(children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(5),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 30,
                                  backgroundImage: ds['imageUrl'] == ""
                                      ? AssetImage('assets/dummy_image.jpg')
                                      : NetworkImage(ds['imageUrl']),
                                ),
                                title: Container(
                                  child: Wrap(children: [
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
                                        fontSize: 16,
                                      ),
                                    ),
                                    ds['entryTime'] == null
                                        ? SizedBox()
                                        : Row(children: [
                                            Icon(
                                              Icons.login,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "${formatValue(entryTime.hour)}:${formatValue(entryTime.minute)}, ${entryTime.day} ${days[entryTime.month - 1]} ${entryTime.year}",
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
                                              "${formatValue(exitTime.hour)}:${formatValue(exitTime.minute)}, ${exitTime.day} ${days[exitTime.month - 1]} ${exitTime.year}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ]),
                                  ],
                                ),
                              ),
                              ds['exitTime'] == null
                                  ? Container(
                                      width: double.infinity,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Color(0xffe34850),
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool confirmation =
                                              await showConfirmationDialog(
                                                  context,
                                                  'Alert!',
                                                  'Are you sure you want to log visitor exit?');
                                          if (confirmation) {
                                            try {
                                              await Database().logPreApproval(
                                                  g.society, ds.id, 'exitTime');
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
                                        child: Text(
                                          'MARK EXIT',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                            ]),
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
                            'No pre approvals',
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
