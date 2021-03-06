import 'package:ease_it/screens/common/events/add_event.dart';
import 'package:ease_it/screens/common/events/past_events.dart';
import 'package:ease_it/screens/common/events/upcoming_events.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsView extends StatefulWidget {
  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  List<Color> colors = [
    Color(0xff2680eb),
    Color(0xffe34850),
    Color(0xffe68619),
    Color(0xff2d9d78)
  ];
  Globals g = Globals();
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
              Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
              ),
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
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Events',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: Color(0xff037DD6),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black38,
                  indicatorWeight: 2.5,
                  labelStyle: GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: [
                    Tab(
                      text: 'Upcoming',
                    ),
                    Tab(
                      text: 'Past',
                    )
                  ]),
              Expanded(
                flex: 12,
                child: TabBarView(children: [
                  UpcomingEvents(),
                  PastEvents(),
                ]),
              ),
              g.role == "Secretary"
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEvent()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23),
                                side: BorderSide(
                                  color: Color(0xff037DD6),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Color(0xff037DD6)),
                              SizedBox(width: 10),
                              Text(
                                'Add Event',
                                style: TextStyle(
                                  color: Color(0xff037DD6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
