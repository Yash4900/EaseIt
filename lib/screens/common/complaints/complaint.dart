import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/complaints/add_complaint.dart';
import 'package:ease_it/screens/common/complaints/single_complaint.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplaintView extends StatefulWidget {
  @override
  _ComplaintViewState createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintView> {
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

  String getInitials(String name) {
    List<String> words = name.split(" ");
    return words[0][0] + words[1][0];
  }

  List<Color> colors = [
    Color(0XFFD5573B),
    Color(0XFF274C77),
    Color(0XFF777DA7),
    Color(0XFFDC6BAD),
    Color(0XFF4C956C),
    Color(0XFFEF233C),
    Color(0XFFC1666B),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: StreamBuilder(
            stream: Database().fetchComplaints(g.society),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else {
                return snapshot.data.docs.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          DateTime date = ds['postedOn'].toDate();
                          Map<String, dynamic> likes = ds['likes'];
                          int likedBy = likes.length;
                          List<String> ids = likes.keys.toList();
                          return StreamBuilder(
                            stream: Database().userStream(
                                g.society, ds['postedBy'].toString()),
                            builder: (context, snapshotUser) {
                              if (snapshotUser.connectionState ==
                                  ConnectionState.active) {
                                DocumentSnapshot userSnapshot =
                                    snapshotUser.data;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleComplaint(
                                            ds.id,
                                            ds['title'],
                                            ds['description'],
                                            ds['imageUrl'],
                                            ds['postedOn'],
                                            userSnapshot['fname'] +
                                                " " +
                                                userSnapshot["lname"] +
                                                " - " +
                                                FlatDataOperations(
                                                        hierarchy: g.hierarchy,
                                                        flatNum: Map<String,
                                                                String>.from(
                                                            userSnapshot[
                                                                'flat']))
                                                    .returnStringFormOfFlatMap(),
                                            ds['status'],
                                            likedBy,
                                            likes,
                                            ids),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
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
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: ds['imageUrl'] == ""
                                                      ? AssetImage(
                                                          'assets/dummy_image.jpg')
                                                      : NetworkImage(
                                                          ds['imageUrl']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            ds['title'],
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Text(
                                            ds['description'].length > 100
                                                ? ds['description']
                                                        .substring(0, 100) +
                                                    " ..."
                                                : ds['description'],
                                            style: TextStyle(
                                              fontSize: 14.5,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                userSnapshot['fname'] +
                                                    " " +
                                                    userSnapshot["lname"] +
                                                    " - " +
                                                    FlatDataOperations(
                                                      hierarchy: g.hierarchy,
                                                      flatNum: Map<String,
                                                          String>.from(
                                                        userSnapshot['flat'],
                                                      ),
                                                    ).returnStringFormOfFlatMap(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "${date.day} ${days[date.month - 1]}, ${date.year}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Row(
                                                  children: [
                                                    ds['likes'].containsKey(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid)
                                                        ? InkWell(
                                                            onTap: () {
                                                              likes.remove(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid);
                                                              Database()
                                                                  .updateLikes(
                                                                      ds.id,
                                                                      g.society,
                                                                      likes);
                                                            },
                                                            child: Icon(
                                                              Icons.thumb_up,
                                                              color: Colors
                                                                  .blue[600],
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () async {
                                                              likes[FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid] = g
                                                                      .fname +
                                                                  ' ' +
                                                                  g.lname;
                                                              await Database()
                                                                  .updateLikes(
                                                                      ds.id,
                                                                      g.society,
                                                                      likes);
                                                            },
                                                            child: Icon(
                                                              Icons.thumb_up,
                                                              color: Colors
                                                                  .grey[400],
                                                            )),
                                                    likedBy > 0
                                                        ? Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  'liked by ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 120,
                                                                  height: 30,
                                                                  child: Stack(
                                                                    children: [
                                                                      for (int i =
                                                                              0;
                                                                          i < 3 &&
                                                                              i < likedBy;
                                                                          i++)
                                                                        Positioned(
                                                                          left: i *
                                                                              20.0,
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            radius:
                                                                                15,
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundColor: colors[i],
                                                                              radius: 13,
                                                                              child: Text(
                                                                                getInitials(likes[ids[i]]),
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      likedBy >
                                                                              3
                                                                          ? Positioned(
                                                                              left: 60.0,
                                                                              child: CircleAvatar(
                                                                                backgroundColor: Colors.white,
                                                                                radius: 15,
                                                                                child: CircleAvatar(
                                                                                  backgroundColor: Colors.grey[200],
                                                                                  radius: 13,
                                                                                  child: Text(
                                                                                    '+${likedBy - 3}',
                                                                                    style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : SizedBox()
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 10),
                                                  color: (ds['status'] ==
                                                          "Resolved")
                                                      ? Color(0xff107154)
                                                          .withOpacity(0.2)
                                                      : Colors.grey
                                                          .withOpacity(0.2),
                                                  child: Text(
                                                    ds['status'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: (ds['status'] ==
                                                                "Resolved")
                                                            ? Color(0xff107154)
                                                            : Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else if (snapshotUser.connectionState ==
                                  ConnectionState.waiting) {
                                return Loading();
                              } else {
                                return Text(
                                  "Unable to load data",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      )
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
                              'No complaints found',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      );
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddComplaint()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                    side: BorderSide(
                      color: Color(0xff037DD6),
                      width: 2,
                    ),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Color(0xff037DD6)),
                  SizedBox(width: 10),
                  Text(
                    'Add Complaint/Suggestion',
                    style: TextStyle(
                        color: Color(0xff037DD6), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
