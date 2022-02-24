import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';

class ResidentHome extends StatefulWidget {
  @override
  _ResidentHomeState createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  Globals g = Globals();
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
                    CircularImageIcon(
                      firstName: "Amol",
                      lastName: "Thopate",
                      imageLink:
                          'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg',
                      operation: () {
                        return showDialog(
                            barrierColor: Colors.red[50],
                            context: context,
                            builder: (context) => ApprovalAlert(
                                  message: "Approve the Visitor",
                                  operation: () {},
                                ));
                      },
                    ),
                    CircularImageIcon(
                        operation: () {
                          return showDialog(
                              barrierColor: Colors.red[50],
                              context: context,
                              builder: (context) => ApprovalAlert(
                                    message: "Approve the Visitor",
                                    operation: () {},
                                  ));
                        },
                        firstName: "Ramu",
                        lastName: "Thopate",
                        imageLink:
                            'https://lh3.googleusercontent.com/mT4DqgvnPFpzmHQrPV66ud9kUrdBd4wSjR90HyPxn2F5qYn2QuChVy1m_yKU_Awd5_tyqifHElUBh4YkbTZ1HsmT'),
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
                stream: Database().getPendingChildApproval(g.society, g.flatNo, g.wing),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();}
                  else
                  {if(snapshot.hasData && snapshot.data.docs.length>0){
                    print("Hello");
                    List<dynamic> list=snapshot.data.docs; 
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      
                     children: list.map((data)=>
                         CircularImageIcon(
                            operation: () {
                              print(data.id);
                              return showDialog(
                                  barrierColor: Color.fromRGBO(0, 0, 100, 0.5),
                                  context: context,
                                  builder: (context) => ApprovalAlert(
                                        message: "Approve the Child",
                                        operation: Database().updateChildApprovalStatus,
                                        data:data
                                      ));
                            },
                            firstName: data['name'],
                            lastName: "",
                            imageLink:
                                'https://cdn.cdnparenting.com/articles/2018/12/19195307/Featured-image1.jpg'),
                      ).toList(),
                    
                      
                    ),
                  );
                  }
                  else{
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
                }
              ),
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
  dynamic data;
  ApprovalAlert({this.message, this.operation,this.data});

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
                operation(g.society,data.id,true);
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
                operation(g.society,data.id,false);
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
