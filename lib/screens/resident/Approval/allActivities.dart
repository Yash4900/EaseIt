import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    // fetch();
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
                          children: visitorLog.length>0?
                              visitorLog.map(
                                (e) => ResidentialLogCard(
                                  e: e,
                                ),
                              )
                              .toList():[Container(
                    // width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/no_data.png',
                            width: 300,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No activities found',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  )],
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
  const ResidentialLogCard({this.e});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage(e["imageUrl"]), fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e["name"], style: Helper().mediumStyle),
                  SizedBox(
                    height: 5,
                  ),
                  Text(e["phoneNum"], style: Helper().mediumBoldStyle),
                  SizedBox(
                    height: 5,
                  ),
                  // Row(
                  //   children: [
                  //     Icon(Icons.call),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Icon(Icons.share)
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Row(
                    children: [
                      Text("Purpose ", style: Helper().mediumBoldStyle),
                      Text(e["purpose"], style: Helper().mediumStyle),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text("Status ", style: Helper().mediumBoldStyle),
                      Text(e["status"], style: Helper().successMediumBoldStyle),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text("Entry: ", style: Helper().mediumBoldStyle),
                      Text(Helper().convertToDateTime(e['entryTime']),
                          style: Helper().mediumBoldStyle),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text("Exit: ", style: Helper().mediumBoldStyle),
                      Text(
                          e['exitTime'] != null
                              ? Helper().convertToDateTime(e['exitTime'])
                              : "Empty",
                          style: Helper().mediumBoldStyle),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
