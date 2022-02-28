import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeApproval extends StatefulWidget {
  final String name;
  final String purpose;
  final String type;
  final String imageUrl;
  CodeApproval(this.name, this.purpose, this.type, this.imageUrl);
  @override
  _CodeApprovalState createState() => _CodeApprovalState();
}

class _CodeApprovalState extends State<CodeApproval> {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.name} . ${widget.purpose}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.type}',
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {},
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
                                      fontWeight: FontWeight.bold),
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
                            onPressed: () {},
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
                                      fontWeight: FontWeight.bold),
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
                                      fontWeight: FontWeight.bold),
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
