import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/helper.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityLog extends StatefulWidget {
  @override
  _ActivityLogState createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  void fetch() async {
    print(g.society);
    dynamic visitorLog = Database().getAllVisitorForGivenFlat(
      g.society,
      Map<String, String>.from(g.flat),
      //g.wing,
    );
    // visitorLog=visitorLog.value();
    // for(int i=0;i<visitorLog.length();i++)
    // {
    print(visitorLog);

    // }
  }

  // Two stream builder
  // 1-> Fetch data from visitor
  // 2-> Fetch data from preAPproval
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Activities",
            style: Helper().headingStyle,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.white24,
          iconTheme: IconThemeData(color: Colors.black)),
      body: StreamBuilder(
          stream: Database().getAllVisitorForGivenFlat(
            g.society,
            Map<String, String>.from(g.flat),
            //g.wing,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder(
                  stream: Database().getAllApprovedPreApprovalForGivenFlat(
                    g.society,
                    Map<String, String>.from(g.flat),
                    //g.wing,
                  ),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      List<dynamic> visitorLog = snapshot2.data.docs;
                      List<dynamic> visitorLog2 = snapshot.data.docs;
                      for (int i = 0; i < visitorLog2.length; i++) {
                        visitorLog.add(visitorLog2[i]);
                      }
                      visitorLog.sort((a, b) {
                        if (a['entryTime'].millisecondsSinceEpoch <
                            b['entryTime'].millisecondsSinceEpoch) {
                          return 1;
                        } else if (a['entryTime'].millisecondsSinceEpoch >
                            b['entryTime'].millisecondsSinceEpoch) {
                          return -1;
                        } else {
                          return 0;
                        }
                        // return .compare(b['entryTime'].millisecondsSinceEpoch);
                      });

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: ListView(
                          children: visitorLog.length > 0
                              ? visitorLog
                                  .map(
                                    (e) => ResidentialLogCard(
                                      e: e,
                                    ),
                                  )
                                  .toList()
                              : [
                                  Container(
                                      // width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/no_data.png',
                                              width: 300,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'No activities found',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Loading();
            }
          }),
    );
  }
}

class ResidentialLogCard extends StatelessWidget {
  final dynamic e;
  ResidentialLogCard({this.e});

  String formatValue(int num) {
    return num < 10 ? '0' + num.toString() : num.toString();
  }

  final List<String> days = [
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

  @override
  Widget build(BuildContext context) {
    DateTime entryTime = e['entryTime'].toDate();
    DateTime exitTime;
    if (e['exitTime'] != null) {
      exitTime = e['exitTime'].toDate();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: e['imageUrl'] == ""
              ? AssetImage('assets/dummy_image.jpg')
              : NetworkImage(e['imageUrl']),
        ),
        title: Container(
          child: Row(children: [
            InkWell(
              onTap: () async {
                try {
                  await launch('tel:${e['phoneNum']}');
                } catch (e) {
                  showToast(context, 'error', 'Oops!', 'Something went wrong!');
                }
              },
              child: Text(
                e['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: getColor(e['status'].toUpperCase()).withOpacity(0.2),
              ),
              child: Text(
                e['status'].toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: getColor(e['status'].toUpperCase()),
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
              '${e['purpose']} . ${FlatDataOperations(hierarchy: g.hierarchy, flatNum: Map<String, String>.from(e['flat'])).returnStringFormOfFlatMap()}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                fontSize: 15,
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
                "${formatValue(entryTime.hour)}:${formatValue(entryTime.minute)}, ${entryTime.day} ${days[entryTime.month - 1]} ${entryTime.year}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
            ]),
            e['exitTime'] == null
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
    );
    // return Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(30.0),
    //   ),
    //   color: Colors.blue[50],
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Row(
    //       children: [
    //         Container(
    //           width: 50,
    //           height: 50,
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             // borderRadius: BorderRadius.circular(20),
    //             image: DecorationImage(
    //                 image: NetworkImage(e["imageUrl"]), fit: BoxFit.fill),
    //           ),
    //         ),
    //         SizedBox(
    //           width: 10,
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(e["name"], style: Helper().mediumStyle),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Text(e["phoneNum"], style: Helper().mediumBoldStyle),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               // Row(
    //               //   children: [
    //               //     Icon(Icons.call),
    //               //     SizedBox(
    //               //       width: 10,
    //               //     ),
    //               //     Icon(Icons.share)
    //               //   ],
    //               // ),
    //               // SizedBox(
    //               //   height: 10,
    //               // ),
    //               Row(
    //                 children: [
    //                   Text("Purpose ", style: Helper().mediumBoldStyle),
    //                   Text(e["purpose"], style: Helper().mediumStyle),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Row(
    //                 children: [
    //                   Text("Status ", style: Helper().mediumBoldStyle),
    //                   Text(e["status"], style: Helper().successMediumBoldStyle),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Row(
    //                 children: [
    //                   Text("Entry: ", style: Helper().mediumBoldStyle),
    //                   Text(Helper().convertToDateTime(e['entryTime']),
    //                       style: Helper().mediumBoldStyle),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Row(
    //                 children: [
    //                   Text("Exit: ", style: Helper().mediumBoldStyle),
    //                   Text(
    //                       e['exitTime'] != null
    //                           ? Helper().convertToDateTime(e['exitTime'])
    //                           : "Empty",
    //                       style: Helper().mediumBoldStyle),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
