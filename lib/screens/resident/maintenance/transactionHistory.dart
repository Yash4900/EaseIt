import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/maintenance/razorpay.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  bool visibilityPending = true;
  bool visibilityPaid = false;
  Globals g = Globals();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 4,
        // child: SingleChildScrollView(
        //         physics: ClampingScrollPhysics(),
        //         scrollDirection: Axis.vertical,
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Pending",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: visibilityPending
                    ? Icon(Icons.arrow_drop_up)
                    : Icon(Icons.arrow_drop_down),
                tooltip: 'Show/Hide Pending Bills',
                onPressed: () {
                  setState(() {
                    visibilityPending = !visibilityPending;
                  });
                },
              ),
            ]),
            SizedBox(height: 5),
            visibilityPending
                ? StreamBuilder<QuerySnapshot>(
                    stream: Database().fetchMaintenance(g.society),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          // scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          children: snapshot.data.docs.map((doc) {
                            var flatNoMap =
                                new Map<String, dynamic>.from(doc["flat"]);
                            if (doc["status"] == "Pending" &&
                                flatNoMap["Flat"].toString() ==
                                    g.flat["Flat"].toString() &&
                                flatNoMap["Wing"].toString() ==
                                    g.flat["Wing"].toString()) {
                              return TransactionBill(
                                  name: doc["name"],
                                  flat: flatNoMap,
                                  transactionAmount: doc["billAmount"],
                                  transactionDate: "",
                                  month: doc["month"],
                                  status: doc["status"],
                                  payable: true);
                            } else
                              return Container();
                          }).toList(),
                        );
                      } else
                        return Container();
                    })
                : Container(),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Paid",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: visibilityPaid
                    ? Icon(Icons.arrow_drop_up)
                    : Icon(Icons.arrow_drop_down),
                tooltip: 'Show/Hide Paid Bills',
                onPressed: () {
                  setState(() {
                    visibilityPaid = !visibilityPaid;
                  });
                },
              ),
            ]),
            SizedBox(height: 5),
            visibilityPaid
                ? StreamBuilder<QuerySnapshot>(
                    stream: Database().fetchMaintenance(g.society),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          // scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          children: snapshot.data.docs.map((doc) {
                            var flatNoMap =
                                new Map<String, dynamic>.from(doc["flat"]);
                            if (doc["status"] == "Paid" &&
                                flatNoMap["Flat"].toString() ==
                                    g.flat["Flat"].toString() &&
                                flatNoMap["Wing"].toString() ==
                                    g.flat["Wing"].toString()) {
                              return TransactionBill(
                                  name: doc["name"],
                                  flat: flatNoMap,
                                  transactionAmount: doc["billAmount"],
                                  transactionDate: doc["datePaid"],
                                  month: doc["month"],
                                  status: doc["status"],
                                  payable: false);
                            } else
                              return Container();
                          }).toList(),
                        );
                      } else
                        return Container();
                    })
                : Container(),
          ],
        ),
      )
    ]);
  }
}

enum TransactionType { received, pending }

class TransactionBill extends StatelessWidget {
  final bool payable;
  final String name, status, month, transactionAmount, transactionDate;
  final Map<String, dynamic> flat;
  TransactionBill(
      {Key key,
      this.name,
      this.flat,
      this.status,
      this.transactionAmount,
      this.transactionDate,
      this.month,
      this.payable})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String transactionName;
    Color color;
    Globals g = Globals();
    switch (status) {
      case "Paid":
        transactionName = "Paid";
        color = Colors.green;
        break;
      case "Pending":
        transactionName = "Pending";
        color = Colors.orange;
        break;
    }
    return Container(
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        color: Colors.white54,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[350],
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      // "$name",
                      mapEquals(g.flat, flat) ? "${g.fname}" : "$name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Month: $month",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\Rs. $transactionAmount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      FlatDataOperations(
                              hierarchy: g.hierarchy,
                              flatNum: Map<String, String>.from(flat))
                          .returnStringFormOfFlatMap(),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    if (transactionName == "Paid")
                      Text(
                        "Paid: $transactionDate",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    Text(
                      "$transactionName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                if (payable)
                  Center(
                    child: SizedBox(
                      width: 100.0,
                      height: 25.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 15)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RazorPay(
                                    month: month,
                                    billAmount: transactionAmount)),
                          );
                        },
                        child: const Text('Pay Now'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int monthNumber = 0;

class SendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay Maintenance Bill"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Select Month",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
