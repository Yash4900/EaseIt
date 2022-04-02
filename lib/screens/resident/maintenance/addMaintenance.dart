import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';

class AddMaintenance extends StatefulWidget {
  @override
  _AddMaintenanceState createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  Globals g = Globals();
  TextEditingController _billAmountController = TextEditingController();
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String monthValue = "January";
  List<String> years = ["2022", "2023", "2024", "2025"];
  String yearValue = "2022";
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.keyboard_backspace, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Text(
                    'Add Maintenance For All Residents of ${g.society}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Enter the details below',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Select Month',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: <Widget>[
                            DropdownButton(
                              value: monthValue,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items: months.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String value) {
                                setState(() => monthValue = value);
                              },
                            ),
                            DropdownButton(
                              value: yearValue,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items: years.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String value) {
                                setState(() => yearValue = value);
                              },
                            ),
                          ],
                        ),
                        // SizedBox(height: 20),
                        // Text(
                        //   'Month',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 12),
                        // ),
                        // TextFormField(
                        //   decoration:
                        //       InputDecoration(hintText: 'February 2022'),
                        //   maxLines: null,
                        //   controller: _monthController,
                        //   validator: (value) =>
                        //       value.length == 0 ? 'Please enter a valid month' : null,
                        // ),
                        SizedBox(height: 20),
                        Text(
                          'Bill Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter Bill Amount'),
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          controller: _billAmountController,
                          validator: (value) =>
                              value.length == 0 ? 'Please enter a body' : null,
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                String monthOfMaintenance =
                                    monthValue + " " + yearValue;
                                setState(() => loading = true);
                                Database()
                                    .addMaintenance(
                                        g.society,
                                        _billAmountController.text,
                                        monthOfMaintenance)
                                    .then((value) {
                                  setState(() => loading = false);
                                  showToast(context, "success", "Success!",
                                      "Maintenance for $monthOfMaintenance has been added successfully!");
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: Text(
                                'Add Maintenance',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff037DD6)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
