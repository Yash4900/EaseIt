import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/Approval/visitorProfile.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/variables/helper.dart';
import 'package:flutter/material.dart';

class DailyHelpers extends StatefulWidget {
  final String dailyHelperType;
  DailyHelpers({this.dailyHelperType});
  @override
  _DailyHelpersState createState() => _DailyHelpersState();
}

class _DailyHelpersState extends State<DailyHelpers> {
  // Map<String,String> totalHelper={};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dailyHelperType, style: Helper().headingStyle),
        backgroundColor: Colors.white,
        shadowColor: Colors.white24,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
              stream: Database()
                  .getAllDailyHelperCategory(g.society, widget.dailyHelperType),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.docs.length > 0) {
                  List<dynamic> list = snapshot.data.docs;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: list
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // width: 45,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VisitorProfile(
                                          visitorData: e,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 10, 8, 10),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(e["imageUrl"]),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e["name"],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '+91-${e['phoneNum']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.start,
                                          //   children: [
                                          //     Text("Rating ",
                                          //         style: Helper().mediumStyle),
                                          //     Text("5",
                                          //         style: Helper().mediumStyle),
                                          //     Image(
                                          //       image: AssetImage(
                                          //           'assets/star.png'),
                                          //       width: 20,
                                          //       height: 20,
                                          //     )
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                } else {
                  return Container(
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
                              'No daily helpers found',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ));
                }
              }),
        ),
      ),
    );
  }
}
