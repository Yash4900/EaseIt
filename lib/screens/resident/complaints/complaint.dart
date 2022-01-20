import 'package:ease_it/screens/resident/complaints/add_complaint.dart';
import 'package:ease_it/screens/resident/complaints/single_complaint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Complaint {
  String title;
  String desc;
  String image;
  DateTime date;
  String postedBy;
  String status;
  Complaint(
      this.title, this.desc, this.image, this.date, this.postedBy, this.status);
}

class ComplaintView extends StatefulWidget {
  @override
  _ComplaintViewState createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintView> {
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
  List<Complaint> complaints = [
    Complaint(
        "Disturbance caused by children playing during night",
        "From last few weeks some childrens are observed playing in the society after 10 A.M which is causing disturbance to many people. Playing after 10 A.M must should not be allowed",
        "https://outdooralways.com/wp-content/uploads/2020/01/night-games-for-whole-family.jpg",
        DateTime.now(),
        "Yash Satra",
        "Resolved"),
    Complaint(
        "Children playing during night",
        "From last few weeks some childrens are observed playing in the society after 10 A.M which is causing disturbance to many people. Playing after 10 A.M must should not be allowed",
        "https://outdooralways.com/wp-content/uploads/2020/01/night-games-for-whole-family.jpg",
        DateTime.now(),
        "Yash Satra",
        "Unresolved")
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleComplaint(
                            complaints[index].title,
                            complaints[index].desc,
                            complaints[index].image,
                            complaints[index].date,
                            complaints[index].postedBy,
                            complaints[index].status)),
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
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(complaints[index].image),
                                fit: BoxFit.cover)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          complaints[index].title,
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          complaints[index].desc.substring(0, 100) + " ...",
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              complaints[index].postedBy,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${complaints[index].date.day} ${days[complaints[index].date.month - 1]}, ${complaints[index].date.year}",
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
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          color: (complaints[index].status == "Resolved")
                              ? Color(0xff107154).withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          child: Text(
                            complaints[index].status,
                            style: TextStyle(
                                fontSize: 12,
                                color: (complaints[index].status == "Resolved")
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
