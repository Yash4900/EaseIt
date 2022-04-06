import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
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
  bool isFullDayEvent = false;

  List<String> days = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
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

  String getTime(TimeOfDay time) {
    String str = '${time.hour.toString()}:${time.minute.toString()}';
    String min = str.split(":")[1];
    if (min.length == 1) {
      str = str + "0";
    }
    return str;
  }

  String formatValue(int num) {
    return num < 10 ? '0' + num.toString() : num.toString();
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
                        Text(
                          'EVENT NAME',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
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
                        Text(
                          'EVENT VENUE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
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
                        Text(
                          'DATE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${selectedDate.day} ${days[selectedDate.month - 1]} ${selectedDate.year}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Color(0xff037DD6),
                              checkColor: Colors.white,
                              value: isFullDayEvent,
                              onChanged: (value) =>
                                  setState(() => isFullDayEvent = value),
                            ),
                            Text(
                              'Full day event',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        (!isFullDayEvent)
                            ? Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FROM',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(height: 5),
                                    InkWell(
                                      onTap: () => _selectStartTime(context),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[400]),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTime(selectedStartTime),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.access_time,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(height: 5),
                                    InkWell(
                                      onTap: () => _selectEndTime(context),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[400]),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTime(selectedEndTime),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.access_time,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ])
                            : SizedBox(),
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
                                    isFullDayEvent,
                                    '${formatValue(selectedStartTime.hour)}:${formatValue(selectedStartTime.minute)}',
                                    '${formatValue(selectedEndTime.hour)}:${formatValue(selectedEndTime.minute)}',
                                  )
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
                                Color(0xff037DD6),
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
