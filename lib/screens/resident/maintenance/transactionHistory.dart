import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({ Key key }) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return ListView(
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
                return TransactionBill(
                  name: doc["name"],
                  wing: doc["wing"],
                  flatNo: doc["flatNo"],
                  transactionAmount: doc["billAmount"],
                  transactionDate: doc["datePayed"],
                  status: doc["status"],
                );
              }).toList(),            
          );
        }
        else
        return Container();
        }),
                      ],
                    );
  }
}

enum TransactionType { received, pending }

class TransactionBill extends StatelessWidget {
  final String name, status, wing, flatNo, transactionAmount, transactionDate;
  const TransactionBill(
      {Key key,
      this.name,
      this.wing,
      this.flatNo,
      this.status,
      this.transactionAmount,
      this.transactionDate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String transactionName;
    IconData transactionIconData;
    Color color;
    switch (status) {
      case "Paid":
        transactionName = "Paid";
        transactionIconData = Icons.arrow_downward;
        color = Colors.green;
        break;
      case "Pending":
        transactionName = "Pending";
        transactionIconData = Icons.arrow_downward;
        color = Colors.orange;
        break;
    }
    return Container(
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
            flex: 1,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg",
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      child: Icon(
                        transactionIconData,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 5.0),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "$name",
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
                      "$wing-$flatNo       $transactionDate",
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