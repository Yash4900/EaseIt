import 'package:flutter/material.dart';

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
  List<Approval> approvals = [
    Approval("Bunty", "A-101", 12, DateTime.now(), "PENDING"),
    Approval("Harsh", "B-101", 14, DateTime.now(), "APPROVED")
  ];

  Color getColor(String status) {
    if (status == "PENDING") return Color(0xff095aba);
    if (status == "APPROVED") return Color(0xff107154);
    return Color(0xffbb121a);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 6,
        child: ListView.builder(
          itemCount: approvals.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Card(
                child: ListTile(
                  title: Text(
                    approvals[index].name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flat No: ${approvals[index].flatNo}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500]),
                      ),
                      Text(
                        'Age: ${approvals[index].age}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500]),
                      ),
                      Text(
                        "Time: 22 Jan 2021, 13:45",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500]),
                      )
                    ],
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    color: getColor(approvals[index].status).withOpacity(0.3),
                    child: Text(
                      approvals[index].status,
                      style:
                          TextStyle(color: getColor(approvals[index].status)),
                    ),
                  ),
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
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
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
                              child: Column(
                                children: [
                                  Text(
                                    'Add details of child below',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Enter child\'s name'),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: 'Enter child\'s age'),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Flexible(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: 'Enter flat no'),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey[200]),
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () async {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xff1a73e8)),
                                        ),
                                        child: Text(
                                          'Send Request',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
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
              child: Text(
                'New Approval',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ))
    ]);
  }
}
