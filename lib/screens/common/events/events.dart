import 'package:ease_it/screens/common/events/add_event.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Event {
  String name;
  String venue;
  DateTime date;
  String startsAt;
  String endsAt;
  Event(this.name, this.venue, this.date, this.startsAt, this.endsAt);
}

class EventsView extends StatefulWidget {
  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
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
  List<Event> events = [
    Event("Society Meeting", "Multipurpose Hall",
        DateTime.now().add(Duration(days: 3)), "9:00", "11:00"),
    Event("Fire Safety and Evacuation Demo", "Society Compound",
        DateTime.now().add(Duration(days: 9)), "8:00", "12:00")
  ];
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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Events',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              flex: 9,
              child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${events[index].date.day} ${days[events[index].date.month - 1]} ${events[index].date.year}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors[index % 4].withOpacity(0.2),
                                border: Border(
                                  left: BorderSide(
                                      color: colors[index % 4], width: 2),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      events[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colors[index % 4],
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      events[index].venue,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      events[index].startsAt +
                                          " - " +
                                          events[index].endsAt,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff1a73e8).withOpacity(0.2)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(horizontal: 15))),
                          child: Text(
                            '+ Add Event',
                            style: TextStyle(
                                color: Color(0xff1a73e8),
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
