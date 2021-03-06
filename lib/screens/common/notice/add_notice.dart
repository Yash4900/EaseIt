import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';

class AddNotice extends StatefulWidget {
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  Globals g = Globals();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
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
          onPressed: () async {
            bool confirmation = await showAlertDialog(context, 'Alert',
                'Are you sure you want to leave? Your changes will be discarded');
            if (confirmation) {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            }
          },
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
                    'Make an announcement!!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Enter the notice details below',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HEADING',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter a heading'),
                          maxLines: null,
                          controller: _titleController,
                          validator: (value) =>
                              value.length == 0 ? 'Please enter a title' : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'BODY',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Enter body'),
                          maxLines: null,
                          controller: _bodyController,
                          validator: (value) =>
                              value.length == 0 ? 'Please enter a body' : null,
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                bool confirmation = await showConfirmationDialog(
                                    context,
                                    "Alert!",
                                    "Are you sure you want to publish the notice?");
                                if (confirmation) {
                                  setState(() => loading = true);
                                  bool status = await Database().addNotice(
                                    g.society,
                                    _titleController.text,
                                    _bodyController.text,
                                  );
                                  setState(() {
                                    loading = false;
                                  });
                                  if (status) {
                                    Navigator.pop(context);
                                    showToast(context, "success", "Success",
                                        "Notice published successfully");
                                  } else {
                                    showToast(context, "error", "Error",
                                        "There was an error publishing the notice");
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: Text(
                                'Publish',
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
