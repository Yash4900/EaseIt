// import 'dart:html';

import 'package:ease_it/screens/resident/Approval/addHelper.dart';
import 'package:ease_it/screens/resident/Approval/allActivities.dart';
import 'package:ease_it/screens/resident/Approval/preapproval.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  @override
  void initState() {
    // TODO: implement initState
    print('In');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(children: [
                Text('Recent Visitor',
                    style: GoogleFonts.montserrat(
                        textStyle: Helper().headingStyle))
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
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

                      CircularImageIcon(
                          firstName: "Amol",
                          lastName: "Thopate",
                          imageLink:
                              'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                      CircularImageIcon(
                          firstName: "Ramu",
                          lastName: "Thopate",
                          imageLink:
                              'https://lh3.googleusercontent.com/mT4DqgvnPFpzmHQrPV66ud9kUrdBd4wSjR90HyPxn2F5qYn2QuChVy1m_yKU_Awd5_tyqifHElUBh4YkbTZ1HsmT'),
                      CircularImageIcon(
                          firstName: "Himesh",
                          lastName: "Thopate",
                          imageLink:
                              'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l'),
                      CircularImageIcon(
                          firstName: "Salman",
                          lastName: "Thopate",
                          imageLink:
                              'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTOj2HVmgtYgoxxh9hcakq_c_SmfqtFeciy7QJRGA0bfkPeHkAU'),
                      CircularImageIcon(
                          firstName: "Akshay",
                          lastName: "Thopate",
                          imageLink:
                              'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                      CircularImageIcon(
                          firstName: "Amol",
                          lastName: "Thopate",
                          imageLink:
                              'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg')
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Daily Helper",
                    style: GoogleFonts.montserrat(
                        textStyle: Helper().headingStyle),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // NewWidget(),
                      CircularButtonIcon(
                          firstName: "Add",
                          lastName: "Helper",
                          imageLink: 'assets/add-user.png',
                          type: "addHelper"),

                      CircularImageIcon(
                          firstName: "Amol",
                          lastName: "Thopate",
                          imageLink:
                              'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                      CircularImageIcon(
                          firstName: "Ramu",
                          lastName: "Thopate",
                          imageLink:
                              'https://lh3.googleusercontent.com/mT4DqgvnPFpzmHQrPV66ud9kUrdBd4wSjR90HyPxn2F5qYn2QuChVy1m_yKU_Awd5_tyqifHElUBh4YkbTZ1HsmT'),
                      CircularImageIcon(
                          firstName: "Himesh",
                          lastName: "Thopate",
                          imageLink:
                              'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l'),
                      CircularImageIcon(
                          firstName: "Salman",
                          lastName: "Thopate",
                          imageLink:
                              'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTOj2HVmgtYgoxxh9hcakq_c_SmfqtFeciy7QJRGA0bfkPeHkAU'),
                      CircularImageIcon(
                          firstName: "Akshay",
                          lastName: "Thopate",
                          imageLink:
                              'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                      CircularImageIcon(
                          firstName: "Amol",
                          lastName: "Thopate",
                          imageLink:
                              'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg')
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Outline_button("View All Activites", Icons.access_time,()=>{
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityLog(),
                              ),
                            )
                    }),
                    // SizedBox(width: 10,),
                    Outline_button("Manage Household", Icons.people,()=>{}),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class CircularButtonIcon extends StatelessWidget {
  String firstName, lastName, type;

  String imageLink;
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
            Text(firstName,
                style: GoogleFonts.montserrat(textStyle: Helper().normalStyle)),
            Text(lastName,
                style: GoogleFonts.montserrat(textStyle: Helper().normalStyle)),
          ],
        ),
      ),
    );
  }
}

class CircularImageIcon extends StatelessWidget {
  String firstName, lastName;

  String imageLink;
  CircularImageIcon({this.firstName, this.lastName, this.imageLink});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            Text(firstName,
                style: GoogleFonts.montserrat(textStyle: Helper().normalStyle)),
            Text(lastName,
                style: GoogleFonts.montserrat(textStyle: Helper().normalStyle)),
          ],
        ),
      ),
    );
  }
}

Widget Outline_button(String name, IconData icon, Function operation) {
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
    label: Text(name,
        style: GoogleFonts.montserrat(textStyle: Helper().buttonTextStyle)),
    icon: Icon(
      icon,
      size: 15,
      color: Colors.blue,
    ),
  );
}
