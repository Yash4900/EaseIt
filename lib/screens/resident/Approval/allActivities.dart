import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';

class ActivityLog extends StatefulWidget {
  @override
  _ActivityLogState createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  List<Map<String, String>> visitorsLog = [
    {
      "name": "Amol Thopate",
      "type": "milkman",
      "entryTime": "09:30",
      "exitTime": "09:45",
      "number": "9898989890",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l"
    },
    {
      "name": "Salim Thopate",
      "type": "Delivery",
      "entryTime": "09:30",
      "exitTime": "09:45",
      "number": "9898989890",
      "imageLink":
          "https://lh3.googleusercontent.com/mT4DqgvnPFpzmHQrPV66ud9kUrdBd4wSjR90HyPxn2F5qYn2QuChVy1m_yKU_Awd5_tyqifHElUBh4YkbTZ1HsmT"
    },
  ];

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
      body: Column(
        children: visitorsLog
            .map(
              (e) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(e["imageLink"]),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e["name"], style: Helper().mediumStyle),
                            SizedBox(
                              height: 10,
                            ),
                            Text(e["number"], style: Helper().normalStyle),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(Icons.call),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.share)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Entry Time ",
                                    style: Helper().mediumStyle),
                                Text(e["entryTime"],
                                    style: Helper().mediumStyle),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Exit Time ", style: Helper().mediumStyle),
                                Text(e["exitTime"],
                                    style: Helper().mediumStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
