import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/maintenance/recentPayments.dart';
import 'package:ease_it/screens/resident/maintenance/residentStatus.dart';
import 'package:ease_it/screens/resident/maintenance/transactionHistory.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/screens/resident/resident.dart';
import 'package:ease_it/screens/security/security.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

enum ButtonType { payBills, donate, receiptients, offers }
Globals g = Globals();

class SecretaryPOV extends StatelessWidget {
  final String title;
  final db = FirebaseFirestore.instance;
  SecretaryPOV({this.title});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 3,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Maintenance',
          style: GoogleFonts.sourceSansPro(
              fontSize: 25, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 15),
        TabBar(
            indicatorColor: Color(0xff1a73e8),
            labelColor: Colors.black,
            indicatorWeight: 2.5,
            labelStyle: GoogleFonts.sourceSansPro(
                fontSize: 16, fontWeight: FontWeight.w600),
            tabs: [
              Tab(
                text: 'Recent',
              ),
              Tab(
                text: 'Status',
              ),
              Tab(
                text: 'My History',
              )
            ]),
        Expanded(
          child: TabBarView(children: [
            RecentPayments(),
            ResidentStatus(),
            TransactionHistory(),              
          ]),
        ),
      ]),
    ));
  }
}

class PayeeContainer extends StatefulWidget {

  @override
  State<PayeeContainer> createState() => _PayeeContainerState();
}

class _PayeeContainerState extends State<PayeeContainer> {
  var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  String currentMonth;

  @override
  void initState(){
    super.initState();
    currentMonth = monthNames[monthNumber];
    monthNumber++;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg",
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$currentMonth",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Rs. 500",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}