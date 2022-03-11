// Pop-up which shows visitor's info when correct code is entered

import 'dart:ui';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeApproval extends StatefulWidget {
  final String id;
  final String name;
  final String purpose;
  final String type;
  final String imageUrl;
  CodeApproval(this.id, this.name, this.purpose, this.type, this.imageUrl);
  @override
  _CodeApprovalState createState() => _CodeApprovalState();
}

class _CodeApprovalState extends State<CodeApproval> {
  Globals g = Globals();
  bool loading = false;

  Future handleExit() async {
    if (widget.type == 'Daily Helper') {
      try {
        setState(() => loading = true);
        await Database().logDailyHelperVisit(g.society, widget.id, 'exit');
      } catch (e) {
        print(e.toString());
      }
      setState(() => loading = false);
    } else {
      try {
        setState(() => loading = true);
        await Database().logPreApproval(g.society, widget.id, 'exitTime');
        showToast(context, 'success', 'Success!', 'Log created successfully');
      } catch (e) {
        print(e.toString());
      }
      setState(() => loading = false);
    }
  }

  Future handleEntry() async {
    if (widget.type == 'Daily Helper') {
      try {
        setState(() => loading = true);
        await Database().logDailyHelperVisit(g.society, widget.id, 'entry');
      } catch (e) {
        print(e.toString());
      }
      setState(() => loading = false);
    } else {
      try {
        setState(() => loading = true);
        await Database().logPreApproval(g.society, widget.id, 'entryTime');
        showToast(context, 'success', 'Success!', 'Log created successfully');
      } catch (e) {
        print(e.toString());
      }
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: loading
                    ? Loading()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.name} . ${widget.purpose}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${widget.type}',
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () async {
                                    bool confirmation =
                                        await showConfirmationDialog(
                                            context,
                                            'Alert!',
                                            'Are you sure you want to make this entry?');
                                    if (confirmation) {
                                      await handleEntry();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.login,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Entry',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey[400],
                                width: 1,
                                height: 25,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () async {
                                    bool confirmation =
                                        await showConfirmationDialog(
                                            context,
                                            'Alert!',
                                            'Are you sure you want to make this entry?');
                                    if (confirmation) {
                                      await handleExit();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Exit',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey[400],
                                width: 1,
                                height: 25,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.3),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: MediaQuery.of(context).size.width * 0.2,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.imageUrl == ""
                        ? AssetImage('assets/dummy_image.jpg')
                        : NetworkImage(widget.imageUrl),
                    radius: (MediaQuery.of(context).size.width * 0.2) - 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
