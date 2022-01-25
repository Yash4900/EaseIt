import 'package:flutter/material.dart';

class Approval {
  String name;
  String flatNo;
  int age;
  DateTime date;

  String status;

  Approval(this.name, this.flatNo, this.age, this.date, this.status);
}

class PastApproval extends StatefulWidget {
  @override
  _PastApprovalState createState() => _PastApprovalState();
}

class _PastApprovalState extends State<PastApproval> {
  List<Approval> approvals = [
    Approval("Bunty", "A-101", 12, DateTime.now(), "APPROVED"),
    Approval("Monty", "B-101", 8, DateTime.now(), "DECLINED")
  ];

  Color getColor(String status) {
    if (status == "PENDING") return Color(0xff095aba);
    if (status == "APPROVED") return Color(0xff107154);
    return Color(0xffbb121a);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                          fontWeight: FontWeight.w600, color: Colors.grey[500]),
                    ),
                    Text(
                      'Age: ${approvals[index].age}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.grey[500]),
                    ),
                    Text(
                      "Time: 22 Jan 2021, 13:45",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.grey[500]),
                    )
                  ],
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  color: getColor(approvals[index].status).withOpacity(0.3),
                  child: Text(
                    approvals[index].status,
                    style: TextStyle(color: getColor(approvals[index].status)),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
