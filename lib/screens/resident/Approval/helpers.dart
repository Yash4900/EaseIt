import 'package:ease_it/screens/common/profile.dart';
import 'package:ease_it/screens/resident/Approval/visitorProfile.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyHelpers extends StatefulWidget {
  @override
  _DailyHelpersState createState() => _DailyHelpersState();
}

class _DailyHelpersState extends State<DailyHelpers> {
  List<Map<String, String>> totalHelper = [
    {
      "name": "Sarika Kamble",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l",
      "rating": "5"
    },
    {
      "name": "Sarika Kamble",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l",
      "rating": "5"
    },
    {
      "name": "Sarika Kamble",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l",
      "rating": "5"
    },
    {
      "name": "Sarika Kamble",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l",
      "rating": "5"
    },
    {
      "name": "Sarika Kamble",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l",
      "rating": "5"
    },
    {
      "name": "Sarika Kamble",
      "imageLink":
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l",
      "rating": "5"
    },
  ];
  // Map<String,String> totalHelper={};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Add Helper",
            style: GoogleFonts.montserrat(textStyle: Helper().headingStyle),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.white24,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: totalHelper
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
                                builder: (context) => VisitorProfile(),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(e["imageLink"]),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(e["name"],
                                          style: GoogleFonts.montserrat(
                                              textStyle: Helper().mediumStyle)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Rating ",
                                          style: GoogleFonts.montserrat(
                                              textStyle: Helper().mediumStyle)),
                                      Text(e["rating"],
                                          style: GoogleFonts.montserrat(
                                              textStyle: Helper().mediumStyle)),
                                      Image(
                                        image: AssetImage('assets/star.png'),
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
