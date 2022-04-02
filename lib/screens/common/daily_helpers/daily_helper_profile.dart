import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'daily_helper_log.dart';

class DailyHelper extends StatefulWidget {
  final DocumentSnapshot ds;
  DailyHelper(this.ds);
  @override
  State<DailyHelper> createState() => _DailyHelperState();
}

class _DailyHelperState extends State<DailyHelper> {
  Globals g = Globals();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.ds['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: ListTile(
              title: Row(children: [
                Text(
                  widget.ds['name'],
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xffcb6f10).withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      widget.ds['purpose'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffcb6f10),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ]),
              subtitle: Text(
                '+91-${widget.ds['phoneNum']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              trailing: CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xff12805c),
                child: IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      await launch('tel:${widget.ds['phoneNum']}');
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailyHelperLog(widget.ds.id),
                  ),
                );
              },
              child: Text(
                'View Logs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff095aba),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Colors.black45,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Works in flats',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          for (int i = 0; i < widget.ds['worksAt'].length; i++)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                FlatDataOperations(
                        hierarchy: g.hierarchy,
                        flatNum:
                            Map<String, String>.from(widget.ds['worksAt'][i]))
                    .returnStringFormOfFlatMap(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
        ],
      ),
    );
  }
}
