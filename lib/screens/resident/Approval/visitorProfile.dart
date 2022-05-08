import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void initState() {
    super.initState();
    flatList = widget.visitorData['worksAt'];
  }

  void _callNumber(dynamic number) async {
    try {
      await launch('tel:$number');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.keyboard_backspace, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(widget.visitorData['imageUrl']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.visitorData['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '+91-${widget.visitorData['phoneNum']}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () {
                                    _callNumber(widget.visitorData['phoneNum']);
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  FlutterShare.share(
                                      title: "DailyHelper Number",
                                      text: widget.visitorData['name'] +
                                          " : " +
                                          widget.visitorData['phoneNum']);
                                },
                              )
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
                        Text(
                          "Works in flats",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: flatList
                            .map((e) => customOutlinedButton(
                                FlatDataOperations(
                                  hierarchy: g.hierarchy,
                                  flatNum: Map<String, String>.from(
                                    e,
                                  ),
                                ).returnStringFormOfFlatMap(),
                                Icons.call,
                                () => {
                                      Database()
                                          .getUserDetailsBasedOnFlatNumber(
                                              g.society, g.flat)
                                          .then((value) => _callNumber(
                                              value.docs[0].get('phoneNum')))
                                          .onError(
                                            (error, stackTrace) => showToast(
                                                context,
                                                "Urgent",
                                                "Error",
                                                error),
                                          )
                                    }))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            customOutlinedButton(
              "Add Helper",
              Icons.add,
              () async => {
                await Database().addDailyHelperForGivenFlat(
                    g.society, widget.visitorData.id, g.flat),
                showToast(context, 'success', 'Success!',
                    'Helper successfully added to flat!'),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget),
                )
              },
            ),
          ],
        ),
      ),
    );
  }
}
