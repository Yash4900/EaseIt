import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/screens/resident/maintenance/credit_card_page.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({ Key key }) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
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
                        if(doc["status"] == "Pending" && doc["flatNo"] == Globals().flatNo && doc["wing"] == Globals().wing){                  
                          return TransactionBill(
                            name: doc["name"],
                            wing: doc["wing"],
                            flatNo: doc["flatNo"],
                            transactionAmount: doc["billAmount"],
                            transactionDate: "",
                            month: doc["month"],
                            status: doc["status"],
                            payable: true
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
                        if(doc["status"] == "Paid"  && doc["flatNo"] == Globals().flatNo && doc["wing"] == Globals().wing){                  
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
enum TransactionType { received, pending }

class TransactionBill extends StatelessWidget {
  final bool payable;
  final String name, status, wing, flatNo, month, transactionAmount, transactionDate;
  const TransactionBill(
      {Key key,
      this.name,
      this.wing,
      this.flatNo,
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
                      flatNo == g.flatNo && wing == g.wing ? "${g.fname}" : "$name",
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
                      "$wing-$flatNo",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    if(transactionName == "Paid")
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
                if(payable)
                Center(child: SizedBox(
                  width: 100.0,
                  height: 25.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 15)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreditCardPage()),
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