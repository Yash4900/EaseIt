import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/complaints/single_complaint.dart';
import 'package:ease_it/screens/common/notice/single_notice.dart';
import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/display/time_ago.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/variables/helper.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_share/flutter_share.dart';

class ResidentHome extends StatefulWidget {
  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  Globals g = Globals();

  Future<void> share(String code) async {
    await FlutterShare.share(
        title: "EaseIt PreapprovalCode", text: "PreApproval Code : " + code);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/bg.jpg'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
          children: [
            Text(
              'Hello, ${g.fname}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            Text(
              FlatDataOperations(
                hierarchy: g.hierarchy,
                flatNum: Map<String, String>.from(
                  g.flat,
                ),
              ).returnStringFormOfFlatMap(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Approve Visitor',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                                lastName: "Visitors",
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
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Ftechnical-support.png?alt=media&token=4ca03201-fc97-4082-9461-fedd196aa757";
                            purposeToImage["Guest"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Fguest.png?alt=media&token=fc905aca-7189-442d-b3a2-5b3dee65d12e";
                            purposeToImage["Cab"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Ftaxi.png?alt=media&token=f73f031a-b1fc-4537-84ed-b8a67db4941b";
                            purposeToImage["Delivery"] =
                                "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Fdelivery-man.png?alt=media&token=470a51fa-b95a-44ef-a486-b1e297555c45";

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
                                                    Helper()
                                                        .convertToTime(
                                                            data['postedOn'])
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
                                                      Navigator.of(context)
                                                          .pop()
                                                    }),
                                            popup.button(
                                                label: 'Share Code ',
                                                onPressed: () => {
                                                      share(
                                                          data['generatedToken']
                                                              .toString()),
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
            Text(
              'Approve Child Exit',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                              lastName: "Approvals",
                              imageLink: "assets/child.png",
                            ),
                          ],
                        );
                      }
                    }
                  }),
            ),
            Text(
              'Shortcuts',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  color: Colors.grey.withOpacity(0.2)),
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
            ),
            // Show recent notices
            StreamBuilder(
              stream: Database().fetchNotices(g.society, true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  if (snapshot.data.docs.length > 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Notice Board',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'View All',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 180,
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleNotice(
                                          ds['title'],
                                          ds['body'],
                                          ds['postedOn']),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300],
                                        offset: const Offset(
                                          3,
                                          3,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  width: 200,
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        ds['body'],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        timeAgo(ds['postedOn'].toDate()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }
              },
            ),
            // Show recent complaints
            StreamBuilder(
              stream: Database().fetchComplaints(g.society, true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  if (snapshot.data.docs.length > 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Posts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'View All',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 170,
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              Map<String, dynamic> temp =
                                  Map<String, dynamic>.from(ds.data());
                              return InkWell(
                                onTap: () async {
                                  DocumentSnapshot userSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection(g.society)
                                          .doc('users')
                                          .collection('User')
                                          .doc(ds['postedBy'])
                                          .get();
                                  Map<String, dynamic> likes = ds['likes'];
                                  int likedBy = likes.length;
                                  List<String> ids = likes.keys.toList();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleComplaint(
                                          ds.id,
                                          ds['title'],
                                          ds['description'],
                                          List<String>.from(ds['imageUrl']),
                                          ds['postedOn'],
                                          userSnapshot['fname'] +
                                              " " +
                                              userSnapshot["lname"] +
                                              " - " +
                                              FlatDataOperations(
                                                      hierarchy: g.hierarchy,
                                                      flatNum: Map<String,
                                                              String>.from(
                                                          userSnapshot['flat']))
                                                  .returnStringFormOfFlatMap(),
                                          ds['status'],
                                          likedBy,
                                          likes,
                                          ids),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300],
                                        offset: const Offset(
                                          3,
                                          3,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  width: 200,
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 120,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: temp.containsKey(
                                                              "imageUrl") ||
                                                          ds["imageUrl"].isEmpty
                                                      ? AssetImage(
                                                          'assets/dummy_image.jpg')
                                                      : NetworkImage(
                                                          ds['imageUrl'][0]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0),
                                                      Colors.black
                                                          .withOpacity(0.6)
                                                    ]),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              left: 5,
                                              child: Text(
                                                ds['title'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              timeAgo(ds['postedOn'].toDate()),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ds['status'] == 'Resolved'
                                                          ? Color(0xff107154)
                                                              .withOpacity(0.2)
                                                          : Colors.grey
                                                              .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                ds['status'].toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: ds['status'] ==
                                                            'Resolved'
                                                        ? Color(0xff107154)
                                                        : Colors.grey[600]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }
              },
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
