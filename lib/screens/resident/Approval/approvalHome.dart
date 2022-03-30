// import 'dart:html';

// import 'dart:js';

import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/complaints/add_complaint.dart';
import 'package:ease_it/screens/resident/Approval/addHelper.dart';
import 'package:ease_it/screens/resident/Approval/allActivities.dart';
import 'package:ease_it/screens/resident/Approval/preapproval.dart';
import 'package:ease_it/screens/resident/Approval/visitorProfile.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter/rendering.dart';

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(children: [
                  Text('Recent Visitor', style: Helper().headingStyle)
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // NewWidget(),
                          CircularButtonIcon(
                              firstName: "Pre",
                              lastName: "Approve",
                              imageLink: 'assets/add-user.png',
                              type: 'preApprove'),

                          StreamBuilder(
                              stream: Database().getTodaysVisitorForGivenFlat(
                                g.society,
                                Map<String, String>.from(g.flat),
                                //g.wing,
                              ),
                              builder: (context, snapshot) {
                                // print(snapshot.data.docs.length);
                                if (snapshot.hasData &&
                                    snapshot.data.docs.length > 0) {
                                  List<dynamic> list = snapshot.data.docs;
                                  return Row(
                                    children: list
                                        .map(
                                          (data) => CircularImageIcon(
                                              operation: () {
                                                final popup = BeautifulPopup(
                                                  context: context,
                                                  template:
                                                      TemplateAuthentication,
                                                );
                                                // DateTime approvalDate = DateTime.parse(data['exitTime'].toDate().toString());
                                                popup.show(
                                                  title: data['name'],
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "EntryDate : ",
                                                              style: Helper()
                                                                  .mediumBoldStyle,
                                                            ),
                                                            Text(
                                                              data['entryTime'] !=
                                                                      null
                                                                  ? Helper()
                                                                      .convertToDate(
                                                                          data[
                                                                              'entryTime'])
                                                                  : "Empty",
                                                              style: Helper()
                                                                  .mediumStyle,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "EntryTime : ",
                                                              style: Helper()
                                                                  .mediumBoldStyle,
                                                            ),
                                                            Text(
                                                              data['entryTime'] !=
                                                                      null
                                                                  ? Helper()
                                                                      .convertToTime(
                                                                          data[
                                                                              'entryTime'])
                                                                  : "Empty",
                                                              style: Helper()
                                                                  .mediumStyle,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "ExitDate : ",
                                                              style: Helper()
                                                                  .mediumBoldStyle,
                                                            ),
                                                            Text(
                                                              data['exitTime'] !=
                                                                      null
                                                                  ? Helper()
                                                                      .convertToDate(
                                                                          data[
                                                                              'exitTime'])
                                                                  : "Empty",
                                                              style: Helper()
                                                                  .mediumStyle,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "ExitTime : ",
                                                              style: Helper()
                                                                  .mediumBoldStyle,
                                                            ),
                                                            Text(
                                                              data['exitTime'] !=
                                                                      null
                                                                  ? Helper()
                                                                      .convertToTime(
                                                                          data[
                                                                              'exitTime'])
                                                                  : "Empty",
                                                              style: Helper()
                                                                  .mediumStyle,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Status : ",
                                                              style: Helper()
                                                                  .mediumBoldStyle,
                                                            ),
                                                            Text(
                                                              data['status']
                                                                  .toString(),
                                                              style: Helper()
                                                                  .mediumStyle,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                  child: Text(
                                                                "Note : Kindly Contact the watchman if any discrepancy is found",
                                                                maxLines: 4,
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                style: Helper()
                                                                    .mediumStyle,
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    popup.button(
                                                      label: 'Close',
                                                      onPressed:
                                                          Navigator.of(context)
                                                              .pop,
                                                    ),
                                                  ],
                                                  // bool barrierDismissible = false,
                                                  // Widget close,
                                                );
                                              },
                                              firstName:
                                                  data['name'].split(' ')[0],
                                              lastName: data['name']
                                                          .split(' ')
                                                          .length >
                                                      1
                                                  ? data['name'].split(' ')[1]
                                                  : "",
                                              imageLink: data['imageUrl']),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Daily Helper",
                      style: Helper().headingStyle,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NewWidget(),
                          CircularButtonIcon(
                              firstName: "Add",
                              lastName: "Helper",
                              imageLink: 'assets/add-user.png',
                              type: "addHelper"),
                          StreamBuilder(
                              stream: Database().getAllDailyHelperForGivenFlat(
                                g.society,
                                Map<String, String>.from(g.flat),
                                //g.wing,
                              ),
                              builder: (context, snapshot) {
                                // print(snapshot.data.docs.length);
                                if (snapshot.hasData &&
                                    snapshot.data.docs.length > 0) {
                                  List<dynamic> list = snapshot.data.docs;
                                  return Row(
                                    children: list
                                        .map(
                                          (data) => CircularImageIcon(
                                              operation: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VisitorProfile(
                                                      visitorData: data,
                                                    ),
                                                  ),
                                                );
                                              },
                                              firstName:
                                                  data['name'].split(' ')[0],
                                              lastName: data['name']
                                                          .split(' ')
                                                          .length >
                                                      1
                                                  ? data['name'].split(' ')[1]
                                                  : "",
                                              imageLink: data['imageUrl']),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text("Child Approval", style: Helper().headingStyle),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: Database().getAllChildApproval(
                        g.society,
                        Map<String, String>.from(g.flat),
                        //g.wing,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.docs.length > 0) {
                          List<dynamic> list = snapshot.data.docs;

                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    // NewWidget(),
                                    list
                                        .map((data) => CircularImageIcon(
                                            operation: () {
                                              final popup = BeautifulPopup(
                                                context: context,
                                                template:
                                                    TemplateAuthentication,
                                              );
                                              DateTime approvalDate =
                                                  DateTime.parse(data['date']
                                                      .toDate()
                                                      .toString());
                                              popup.show(
                                                title: data['name'],
                                                content: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Date : ",
                                                          style: Helper()
                                                              .headingStyle,
                                                        ),
                                                        Text(
                                                          approvalDate.day
                                                                  .toString() +
                                                              "-" +
                                                              approvalDate.month
                                                                  .toString() +
                                                              "-" +
                                                              approvalDate.year
                                                                  .toString(),
                                                          style: Helper()
                                                              .headingStyle,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Time : ",
                                                          style: Helper()
                                                              .headingStyle,
                                                        ),
                                                        Text(
                                                          approvalDate.hour
                                                                  .toString() +
                                                              ":" +
                                                              approvalDate
                                                                  .minute
                                                                  .toString() +
                                                              ":" +
                                                              approvalDate
                                                                  .second
                                                                  .toString(),
                                                          style: Helper()
                                                              .headingStyle,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Status : ",
                                                          style: Helper()
                                                              .headingStyle,
                                                        ),
                                                        Text(
                                                          data['status']
                                                              .toString(),
                                                          style: Helper()
                                                              .headingStyle,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                              child: Text(
                                                            "Note : Kindly Contact the watchman if any discrepancy is found",
                                                            maxLines: 4,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style: Helper()
                                                                .mediumStyle,
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  popup.button(
                                                    label: 'Close',
                                                    onPressed:
                                                        Navigator.of(context)
                                                            .pop,
                                                  ),
                                                ],
                                                // bool barrierDismissible = false,
                                                // Widget close,
                                              );
                                            },
                                            firstName: data['name'],
                                            lastName: "",
                                            imageLink:
                                                'https://cdn.cdnparenting.com/articles/2018/12/19195307/Featured-image1.jpg'))
                                        .toList(),
                              ),
                            ),
                          );
                        } else {
                          return Row(
                            children: [
                              CircularButtonIcon(
                                  firstName: "Child",
                                  lastName: "Approve",
                                  imageLink: 'assets/child.png',
                                  type: "approveChild"),
                            ],
                          );
                        }
                      }),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customOutlinedButton(
                          "View All Activites",
                          Icons.access_time,
                          () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivityLog(),
                                  ),
                                )
                              }),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class CircularButtonIcon extends StatelessWidget {
  final String firstName, lastName, type, imageLink;

  CircularButtonIcon(
      {this.firstName, this.lastName, this.imageLink, this.type});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case "preApprove":
            {
              return showDialog(
                  context: context, builder: (context) => PreApproval());
            }
            break;
          case "addHelper":
            {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHelper(),
                ),
              );
            }
            break;
          case "complaint":
            {
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddComplaint()));
            }
            break;
          case "approveChild":
            {
              TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text("Allow my child to Exit",
                          style: Helper().headingStyle),
                      content: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFFFFFF),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(32.0)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              controller: nameController,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter hrs',
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              keyboardType: TextInputType.number,
                              controller: phoneController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () async {
                                print(phoneController.text);
                                print(nameController.text);

                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff1a73e8)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                                child: Text(
                                  'Generate Token',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )));
            }
        }
      },
      child: Container(
        // width: 45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(imageLink), fit: BoxFit.fill),
                ),
              ),
            ),
            Text(firstName, style: Helper().normalStyle),
            Text(lastName, style: Helper().normalStyle)
          ],
        ),
      ),
    );
  }
}

class CircularImageIcon extends StatelessWidget {
  final String firstName, lastName, imageLink;
  final Function operation;

  CircularImageIcon(
      {this.firstName, this.lastName, this.imageLink, this.operation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: operation,
        child: Container(
          width: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(imageLink), fit: BoxFit.fill),
                ),
              ),
              Text(firstName, style: Helper().normalStyle),
              Text(lastName, style: Helper().normalStyle)
            ],
          ),
        ),
      ),
    );
  }
}

Widget customOutlinedButton(String name, IconData icon, Function operation) {
  return OutlinedButton.icon(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (!states.contains(MaterialState.pressed))
            return Helper().button.withOpacity(1);
          return null; // Use the component's default.
        },
      ),
    ),
    onPressed: operation,
    label: Text(name, style: Helper().buttonTextStyle),
    icon: Icon(
      icon,
      size: 15,
      color: Colors.blue,
    ),
  );
}
