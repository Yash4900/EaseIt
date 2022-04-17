import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/daily_helpers/rating_form.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            height: MediaQuery.of(context).size.height * 0.4,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Color(0xff037DD6),
                      unselectedLabelColor: Colors.black38,
                      labelColor: Colors.black,
                      indicatorWeight: 2.5,
                      labelStyle: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: [
                        Tab(
                          text: 'Flats',
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Ratings'),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xffe68619),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.ds['overallRating'].toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FlatList(
                              flats: List<Map<String, dynamic>>.from(
                                  widget.ds['worksAt'])),
                          RatingList(
                            ratings: Map<String, Map<String, dynamic>>.from(
                                widget.ds['ratings']),
                            id: widget.ds.id,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FlatList extends StatelessWidget {
  final List<Map<String, dynamic>> flats;
  FlatList({Key key, @required this.flats}) : super(key: key);
  final Globals g = Globals();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: flats.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            FlatDataOperations(
                    hierarchy: g.hierarchy,
                    flatNum: Map<String, String>.from(flats[index]))
                .returnStringFormOfFlatMap(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class RatingList extends StatefulWidget {
  final String id;
  final Map<String, Map<String, dynamic>> ratings;

  RatingList({Key key, @required this.ratings, @required this.id})
      : super(key: key);

  @override
  State<RatingList> createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  Globals g = Globals();
  void handleClick(String value) async {
    switch (value) {
      case 'Delete':
        {
          await Database().deleteRating(g.society, widget.id, uid);
          Navigator.pop(context);
          break;
        }
      case 'Update':
        {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => RatingForm(
                rating: widget.ratings[uid]['rating'],
                comment: widget.ratings[uid]['comment'],
                id: widget.id,
              ),
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.ratings.containsKey(uid) && widget.ratings[uid] != null)
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]))),
            child: ListTile(
              contentPadding: EdgeInsets.all(2),
              title: Row(
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      Icons.star,
                      color: widget.ratings[uid]['rating'] > i
                          ? Colors.amber
                          : Colors.black12,
                    )
                ],
              ),
              subtitle: Text(
                widget.ratings[uid]['comment'],
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold),
              ),
              trailing: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black38,
                ),
                color: Colors.white,
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Delete', 'Update'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, _, __) =>
                          RatingForm(rating: 0, comment: '', id: widget.id),
                    ),
                  );
                },
                child: Text(
                  'Add Rating',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        for (String key in widget.ratings.keys)
          if (key != uid && widget.ratings['key'] != null)
            ListTile(
              contentPadding: EdgeInsets.all(2),
              title: Row(
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      Icons.star,
                      color: widget.ratings[key]['rating'] > i
                          ? Colors.amber
                          : Colors.black12,
                    )
                ],
              ),
              subtitle: Text(
                widget.ratings[key]['comment'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      ],
    );
  }
}
