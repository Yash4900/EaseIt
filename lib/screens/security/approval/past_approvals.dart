import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Approval {
  String name;
  String flatNo;
  String purpose;
  DateTime date;
  Timestamp time;
  String status;

  Approval(
      this.name, this.flatNo, this.purpose, this.date, this.time, this.status);
}

class PastApproval extends StatefulWidget {
  @override
  _PastApprovalState createState() => _PastApprovalState();
}

class _PastApprovalState extends State<PastApproval> {
  List<Approval> approvals = [
    Approval(
        "Pinto", "A-101", "Maid", DateTime.now(), Timestamp.now(), "APPROVED"),
    Approval("Subhash", "B-101", "Salesman", DateTime.now(), Timestamp.now(),
        "DECLINED")
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
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
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
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/profile_dummy.png'),
              ),
              title: Text(
                approvals[index].name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    approvals[index].purpose,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[500]),
                  ),
                  Text(
                    approvals[index].flatNo,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[500]),
                  ),
                  Text(
                    "22 Jan 2021, 13:45",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey[500]),
                  )
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getColor(approvals[index].status).withOpacity(0.2),
                ),
                child: Text(
                  approvals[index].status,
                  style: TextStyle(color: getColor(approvals[index].status)),
                ),
              ),
            ),
          );
        });
  }
}
