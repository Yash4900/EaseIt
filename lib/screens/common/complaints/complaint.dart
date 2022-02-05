import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/complaints/add_complaint.dart';
import 'package:ease_it/screens/common/complaints/single_complaint.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                                      ds['postedBy'],
                                      ds['status']),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(ds['imageUrl']),
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
                                    padding: EdgeInsets.all(10),
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
                                          ds['postedBy'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${date.day} ${days[date.month - 1]}, ${date.year}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      color: (ds['status'] == "Resolved")
                                          ? Color(0xff107154).withOpacity(0.2)
                                          : Colors.grey.withOpacity(0.2),
                                      child: Text(
                                        ds['status'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: (ds['status'] == "Resolved")
                                                ? Color(0xff107154)
                                                : Colors.grey,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.search,
                              size: 50,
                              color: Colors.grey[300],
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xff1a73e8).withOpacity(0.2)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 15))),
                child: Text(
                  '+ Add Complaint/Suggestion',
                  style: TextStyle(
                      color: Color(0xff1a73e8), fontWeight: FontWeight.w600),
                ),
              ),
            ))
      ],
    );
  }
}
