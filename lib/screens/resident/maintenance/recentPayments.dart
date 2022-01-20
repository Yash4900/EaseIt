import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/screens/resident/maintenance/transactionHistory.dart';
import 'package:flutter/material.dart';

class RecentPayments extends StatefulWidget {
  const RecentPayments({ Key key }) : super(key: key);

  @override
  _RecentPaymentsState createState() => _RecentPaymentsState();
}

class _RecentPaymentsState extends State<RecentPayments> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Expanded(
              child: Container(
                padding: EdgeInsets.all(21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListView(
                      scrollDirection: Axis.vertical,
              shrinkWrap: true, children: [
      StreamBuilder<QuerySnapshot>(
        stream: db.collection('Maintenance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(              
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data.docs.map((doc) {
                print(doc["name"]);
                if(doc["status"] == "Paid"){                  
                  return TransactionBill(
                    name: doc["name"],
                    wing: doc["wing"],
                    flatNo: doc["flatNo"],
                    transactionAmount: doc["billAmount"],
                    transactionDate: doc["datePayed"],
                    status: doc["status"],
                  );
                }
                else
                  return Container();
              }).toList(),          
          );
        }
        else
        return Container();
        }),
                      ],
                    ),
                  ],
                ),
              ),
            );
  }
}