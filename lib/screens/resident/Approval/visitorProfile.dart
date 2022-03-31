import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ease_it/utility/globals.dart';

class VisitorProfile extends StatefulWidget {
  final dynamic visitorData;
  VisitorProfile({this.visitorData});
  @override
  _VisitorProfileState createState() => _VisitorProfileState();
}

class _VisitorProfileState extends State<VisitorProfile> {
  List<dynamic> flatList;
  Globals g = Globals();

  @override
  Widget build(BuildContext context) {
    flatList = widget.visitorData['worksAt'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.montserrat(textStyle: Helper().headingStyle),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
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
                            image: NetworkImage(widget.visitorData['imageUrl']),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.visitorData['name'],
                            style: GoogleFonts.montserrat(
                              textStyle: Helper().mediumStyle,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.visitorData['phoneNum'],
                              style: GoogleFonts.montserrat(
                                  textStyle: Helper().normalStyle)),
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
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.home),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("WORK IN BELOW HOUSES",
                            style: GoogleFonts.montserrat(
                                textStyle: Helper().mediumStyle)),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: flatList
                            .map((e) => customOutlinedButton(
                                FlatDataOperations(
                                  hierarchy: g.hierarchy,
                                  flatNum: Map<String, String>.from(
                                    e,
                                  ),
                                ).returnStringFormOfFlatMap(),
                                Icons.call,
                                () => {}))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
