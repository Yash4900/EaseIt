// To display alert dialog

import 'package:flutter/material.dart';

Future<void> showMessageDialog(
    BuildContext context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      );
    },
  );
}

Future<bool> showConfirmationDialog(
    BuildContext context, String title, String message) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: Row(
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                  ),
                  child: Text(
                    'YES',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
                SizedBox(width: 10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[300]),
                  ),
                  child: Text(
                    'NO',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
