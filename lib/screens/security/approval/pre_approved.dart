import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';

class PreApproved extends StatefulWidget {
  const PreApproved({Key key}) : super(key: key);

  @override
  _PreApprovedState createState() => _PreApprovedState();
}

class _PreApprovedState extends State<PreApproved> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Text("  Pre-Approved Visitors",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          visitorCard("assets/discount.png", "Nishant",
              {"Flat": "101", "Wing": "A"}, "17-01-2022", "2:00", "3:00 pm"),
          visitorCard("assets/users.png", "Prashant",
              {"Flat": "102", "Wing": "B"}, "18-01-2022", "6:00", "9:00 pm"),
          visitorCard("assets/receipt.png", "Sushant",
              {"Flat": "103", "Wing": "C"}, "19-01-2022", "9:00", "11:00 pm")
        ],
      ),
    );
  }
}

Widget visitorCard(
  String img,
  String name,
  Map<String, String> flat,
  //String flatNo,
  //String wing,
  String expectedDate,
  String expectedTimeStart,
  String expectedTimeEnd,
) {
  Globals g = Globals();
  return Card(
    elevation: 1,
    shadowColor: Colors.green,
    color: Colors.lightGreen,
    margin: EdgeInsets.all(20),
    child: Container(
      height: 120,
      color: Colors.white,
      child: Row(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Expanded(
                child: Image.asset(img),
              ),
            ),
          ),
          Expanded(
            child: Container(
                child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text("$name"),
                        subtitle: Text(
                            "${FlatDataOperations(hierarchy: g.hierarchy, flatNum: flat).returnStringFormOfFlatMap()}"),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("$expectedDate"),
                          Text("$expectedTimeStart-$expectedTimeEnd"),
                        ],
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text("Mark As Entered"),
                  onPressed: () {},
                ),
              ],
            )),
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
    ),
  );
}
