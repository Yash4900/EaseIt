import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/screens/resident/maintenance/transactionHistory.dart';
import 'package:flutter/material.dart';

class ResidentStatus extends StatefulWidget {
  const ResidentStatus({ Key key }) : super(key: key);

  @override
  _ResidentStatusState createState() => _ResidentStatusState();
}

class _ResidentStatusState extends State<ResidentStatus> {
  bool visibilityPending = true;
  bool visibilityPaid = false;
  final db = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
      shrinkWrap: true, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [                  
          Text("Pending", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            icon: visibilityPending ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
            tooltip: 'Show/Hide Pending Bills',
            onPressed: () {
              setState(() {
                visibilityPending = !visibilityPending;
              });
            },
          ),
        ]),
        SizedBox(height: 5),
      visibilityPending ? StreamBuilder<QuerySnapshot>(
        stream: db.collection('Maintenance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(              
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data.docs.map((doc) {
                if(doc["status"] == "Pending"){                  
                  return TransactionBill(
                    name: doc["name"],
                    wing: doc["wing"],
                    flatNo: doc["flatNo"],
                    transactionAmount: doc["billAmount"],
                    transactionDate: "",
                    month: doc["month"],
                    status: doc["status"],
                    payable: false
                  );
                }
                else
                  return Container();
              }).toList(),            
          );
        }
        else
        return Container();
        }):Container(),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [                  
          Text("Paid", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            icon: visibilityPaid ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
            tooltip: 'Show/Hide Paid Bills',
            onPressed: () {
              setState(() {
                visibilityPaid = !visibilityPaid;
              });
            },
          ),
        ]),
        SizedBox(height: 5),
      visibilityPaid ? StreamBuilder<QuerySnapshot>(
        stream: db.collection('Maintenance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(              
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data.docs.map((doc) {
                if(doc["status"] == "Paid"){                  
                  return TransactionBill(
                    name: doc["name"],
                    wing: doc["wing"],
                    flatNo: doc["flatNo"],
                    transactionAmount: doc["billAmount"],
                    transactionDate: doc["datePayed"],
                    month: doc["month"],
                    status: doc["status"],
                    payable: false
                  );
                }
                else
                  return Container();
              }).toList(),           
          );
        }
        else
        return Container();
        }):Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}