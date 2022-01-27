import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedStartTime)
      setState(() {
        selectedStartTime = pickedS;
      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedEndTime)
      setState(() {
        selectedEndTime = pickedS;
      });
  }

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
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              'Post a new Event!!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Specify the details of the event below',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter event name'),
                  maxLines: null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter event venue'),
                  maxLines: null,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    'Select Date',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[300]),
                  ),
                ),
                SizedBox(height: 20),
                Row(children: [
                  TextButton(
                    onPressed: () {
                      _selectStartTime(context);
                    },
                    child: Text(
                      'Select Start Time',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[300]),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      _selectEndTime(context);
                    },
                    child: Text(
                      'Select End Time',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[300]),
                    ),
                  ),
                ]),
                SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
