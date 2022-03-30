import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_share/flutter_share.dart';


class ResidentHome extends StatefulWidget {
  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  Globals g = Globals();


  Future<void> share(String code) async{
    await FlutterShare.share(title: "EaseIt PreapprovalCode",text: "PreApproval Code : "+code);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
          children: [
            Text(
              'Hello, ${g.fname}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Row(children: [
              Text('Approve Visitor', style: Helper().headingStyle)
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    StreamBuilder(
                        stream: Database().getAllPendingVisitorForGivenFlat(
                          g.society,
                          Map<String, String>.from(g.flat),
                          //g.wing,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data.docs.length > 0) {
                            List<dynamic> pendingApproval = snapshot.data.docs;
                            return Row(
                              children: pendingApproval
                                  .map(
                                    (data) => CircularImageIcon(
                                      firstName: data['name'].split(' ')[0],
                                      lastName:
                                          data['name'].split(' ').length > 1
                                              ? data['name'].split(' ')[1]
                                              : "",
                                      imageLink: data['imageUrl'],
                                      operation: () {
                                        return showDialog(
                                            barrierColor:
                                                Color.fromRGBO(0, 0, 100, 0.5),
                                            context: context,
                                            builder: (context) => ApprovalAlert(
                                                  message:
                                                      "Approve the Visitor",
                                                  operation: Database()
                                                      .updateVisitorApproval,
                                                  data: data,
                                                ));
                                      },
                                    ),
                                  )
                                  .toList(),
                            );
                          } else {
                            return CircularButtonIcon(
                                firstName: "No",
                                lastName: "Visitor",
                                imageLink: 'assets/guest.png');
                          }
                        }),
                    StreamBuilder(
                        stream: Database().getAllPendingPreApprovalForGivenFlat(
                          g.society,
                          Map<String, String>.from(g.flat),
                          //g.wing,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data.docs.length > 0) {
                            List<dynamic> pendingApproval = snapshot.data.docs;
                            Map<String, String> purposeToImage = {};
                            purposeToImage["VisitingHelp"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/UtilityImage%2Ftechnical-support.png?alt=media&token=c4112d24-bb2e-4d4c-8906-c32804845794";
                            purposeToImage["Guest"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/UtilityImage%2Fguest.png?alt=media&token=47e030f6-4c04-49b6-a3e7-90b440776351";
                            purposeToImage["Cab"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/UtilityImage%2Ftaxi.png?alt=media&token=1c15e15e-9c02-48a9-bf96-cfdaf71b043f";
                            purposeToImage["Delivery"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/UtilityImage%2Fdelivery-man.png?alt=media&token=f0678091-2a3e-4958-a289-3c44e5b39880";

                            return Row(
                              children: pendingApproval
                                  .map(
                                    (data) => CircularImageIcon(
                                      operation: () {
                                        final popup = BeautifulPopup(
                                          context: context,
                                          template: TemplateAuthentication,
                                        );
                                        DateTime approvalDate = DateTime.parse(
                                            data['postedOn']
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
                                                    style:
                                                        Helper().headingStyle,
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
                                                    style:
                                                        Helper().headingStyle,
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
                                                    style:
                                                        Helper().headingStyle,
                                                  ),
                                                  Text(
                                                    Helper().convertToTime(data['postedOn'])
                                                            .toString(),
                                                    style:
                                                        Helper().headingStyle,
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
                                                    style:
                                                        Helper().headingStyle,
                                                  ),
                                                  Text(
                                                    data['status'].toString(),
                                                    style:
                                                        Helper().headingStyle,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Code : ",
                                                    style:
                                                        Helper().headingStyle,
                                                  ),
                                                  Text(
                                                    data['generatedToken']
                                                        .toString(),
                                                    style:
                                                        Helper().headingStyle,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
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
                                                          TextOverflow.visible,
                                                      style:
                                                          Helper().mediumStyle,
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            popup.button(
                                                label: 'Cancel PreApproval ',
                                                onPressed: () => {
                                                      Database()
                                                          .updatePendingApproval(
                                                              g.society,
                                                              data.id,
                                                              false),
                                                      Navigator.of(context).pop()
                                                    }),
                                                    popup.button(
                                                label: 'Share Code ',
                                                onPressed: () => {
                                                      share(data['generatedToken'].toString()),
                                                    }),
                                          ],
                                          // bool barrierDismissible = false,
                                          // Widget close,
                                        );
                                      },
                                      firstName: data['name'].split(' ')[0],
                                      lastName:
                                          data['name'].split(' ').length > 1
                                              ? data['name'].split(' ')[1]
                                              : "",
                                      imageLink:
                                          purposeToImage[data['purpose']],
                                    ),
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
            Row(children: [
              Text('Approve Child Exit', style: Helper().headingStyle)
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: Database().getPendingChildApproval(
                    g.society,
                    Map<String, String>.from(g.flat),
                    //g.wing,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    } else {
                      if (snapshot.hasData && snapshot.data.docs.length > 0) {
                        print("Hello");
                        List<dynamic> list = snapshot.data.docs;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: list
                                .map(
                                  (data) => CircularImageIcon(
                                      operation: () {
                                        print(data.id);
                                        return showDialog(
                                            barrierColor:
                                                Color.fromRGBO(0, 0, 100, 0.5),
                                            context: context,
                                            builder: (context) => ApprovalAlert(
                                                message: "Approve the Child",
                                                operation: Database()
                                                    .updateChildApprovalStatus,
                                                data: data));
                                      },
                                      firstName: data['name'],
                                      lastName: "",
                                      imageLink:
                                          'https://cdn.cdnparenting.com/articles/2018/12/19195307/Featured-image1.jpg'),
                                )
                                .toList(),
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            CircularButtonIcon(
                              firstName: "No",
                              lastName: "Approval",
                              imageLink: "assets/child.png",
                            ),
                          ],
                        );
                      }
                    }
                  }),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: Color.fromRGBO(255, 255, 255, 0.7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularButtonIcon(
                    firstName: "Add",
                    lastName: "Complaint",
                    imageLink: "assets/complaint.png",
                    type: "complaint",
                  ),
                  CircularButtonIcon(
                    firstName: "Pre",
                    lastName: "Approval",
                    imageLink: "assets/add-user.png",
                    type: "preApprove",
                  ),
                  CircularButtonIcon(
                    firstName: "Add",
                    lastName: "Helper",
                    imageLink: "assets/001-maid.png",
                    type: "addHelper",
                  ),
                  // CircularButtonIcon(firstName: "Add",lastName: "Complaint",imageLink: "assets/complaint.png",type: "complaint",),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ApprovalAlert extends StatelessWidget {
  final String message;
  final Function operation;
  final dynamic data;
  ApprovalAlert({this.message, this.operation, this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, style: Helper().headingStyle),
      content: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () async {
                operation(g.society, data.id, true);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green[50]),
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Image(
                    image: AssetImage('assets/approval.png'),
                    width: 30,
                  )),
            ),
            TextButton(
              onPressed: () async {
                operation(g.society, data.id, false);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[50]),
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Image(
                    image: AssetImage('assets/not-approved.png'),
                    width: 30,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
