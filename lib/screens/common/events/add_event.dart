import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  Globals g = Globals();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 11, minute: 0);
  TextEditingController _nameController = TextEditingController();
  TextEditingController _venueController = TextEditingController();
  List<String> days = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

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
      body: loading
          ? Loading()
          : Padding(
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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter event name'),
                          maxLines: null,
                          controller: _nameController,
                          validator: (value) => value.length == 0
                              ? 'Please enter event name'
                              : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter event venue'),
                          maxLines: null,
                          controller: _venueController,
                          validator: (value) => value.length == 0
                              ? 'Please enter venue name'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Row(children: [
                          Text(
                            'Date ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.grey[200],
                            child: Text(
                              '${selectedDate.day} ${days[selectedDate.month - 1]} ${selectedDate.year}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey[700],
                            ),
                            onPressed: () => _selectDate(context),
                          )
                        ]),
                        SizedBox(height: 20),
                        Row(children: [
                          Text(
                            'from ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.grey[200],
                            child: Text(
                              '${selectedStartTime.hour.toString()}:${selectedStartTime.minute.toString()}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey[700],
                            ),
                            onPressed: () => _selectStartTime(context),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'to ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.grey[200],
                            child: Text(
                              '${selectedEndTime.hour.toString()}:${selectedEndTime.minute.toString()}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey[700],
                            ),
                            onPressed: () => _selectEndTime(context),
                          )
                        ]),
                        SizedBox(height: 20),
                        Row(children: []),
                        SizedBox(height: 40),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                bool confirmation = await showConfirmationDialog(
                                    context,
                                    "Alert!",
                                    "Are you sure you want to add this event?");
                                if (confirmation) {
                                  setState(() => loading = true);
                                  Database()
                                      .addEvent(
                                          g.society,
                                          _nameController.text,
                                          _venueController.text,
                                          selectedDate,
                                          '${selectedStartTime.hour.toString()}:${selectedStartTime.minute.toString()}',
                                          '${selectedEndTime.hour.toString()}:${selectedEndTime.minute.toString()}')
                                      .then((value) {
                                    setState(() => loading = false);
                                    showToast(context, "success", "Success!",
                                        "Event added successfully");
                                    Navigator.pop(context);
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff1a73e8)),
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
