import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database2.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Approval {
  String name;
  String flatNo;
  int age;
  DateTime date;

  String status;

  Approval(this.name, this.flatNo, this.age, this.date, this.status);
}

class RecentApproval extends StatefulWidget {
  @override
  _RecentApprovalState createState() => _RecentApprovalState();
}

class _RecentApprovalState extends State<RecentApproval> {
  Globals g = Globals();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _wingController = TextEditingController();
  TextEditingController _flatNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
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

  Color getColor(String status) {
    if (status == "PENDING") return Color(0xff037DD6);
    if (status == "APPROVED") return Color(0xff107154);
    return Color(0xffbb121a);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Column(
            children: [
              Expanded(
                flex: 6,
                child: StreamBuilder(
                  stream: Database2().getRecentChildApproval(g.society),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    } else {
                      return snapshot.data.docs.length > 0
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                DateTime date = ds['date'].toDate();
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 2),
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
                                  child: ListTile(
                                    title: Text(
                                      ds['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Flat No: ${ds['flatNo']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[500]),
                                        ),
                                        Text(
                                          'Age: ${ds['age']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[500]),
                                        ),
                                        Text(
                                          "Time: ${date.day} ${days[date.month - 1]} ${date.year}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[500]),
                                        )
                                      ],
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                          color: getColor(
                                                  ds['status'].toUpperCase())
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      child: Text(
                                        ds['status'].toUpperCase(),
                                        style: TextStyle(
                                            color: getColor(
                                                ds['status'].toUpperCase())),
                                      ),
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
                                    'No Recent Approvals',
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
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
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
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          builder: (context) {
                            return Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Add details of child below',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Enter child\'s name'),
                                                controller: _nameController,
                                                validator: (value) =>
                                                    value.length == 0
                                                        ? 'Please enter name'
                                                        : null,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Flexible(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Enter child\'s age'),
                                                controller: _ageController,
                                                validator: (value) =>
                                                    value.length == 0
                                                        ? 'Please enter age'
                                                        : null,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    hintText: 'Enter wing'),
                                                controller: _wingController,
                                                validator: (value) =>
                                                    value.length == 0
                                                        ? 'Please enter wing'
                                                        : null,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Flexible(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    hintText: 'Enter flat no'),
                                                controller: _flatNoController,
                                                validator: (value) => value
                                                            .length ==
                                                        0
                                                    ? 'Please enter flat number'
                                                    : null,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.grey[200]),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            23),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            TextButton(
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  bool confirmation =
                                                      await showConfirmationDialog(
                                                          context,
                                                          "Alert!",
                                                          "Are you sure you want to send this request?");
                                                  if (confirmation) {
                                                    setState(
                                                        () => loading = true);
                                                    Database2()
                                                        .sendChildApprovalRequest(
                                                            g.society,
                                                            _nameController
                                                                .text,
                                                            _ageController.text,
                                                            _wingController
                                                                .text,
                                                            _flatNoController
                                                                .text)
                                                        .then((value) {
                                                      setState(() =>
                                                          loading = false);
                                                      showToast(
                                                          context,
                                                          "success",
                                                          "Success!",
                                                          "Child approval request sent successfully");
                                                      Navigator.pop(context);
                                                    }).catchError(() {
                                                      setState(() =>
                                                          loading = false);
                                                    });
                                                  }
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Color(0xff1a73e8)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            23),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'Send Request',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xff037DD6)),
                          SizedBox(width: 10),
                          Text(
                            'New Approval',
                            style: TextStyle(
                                color: Color(0xff037DD6),
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              )
            ],
          );
  }
}
