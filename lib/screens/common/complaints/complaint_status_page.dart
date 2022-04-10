import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/complaints/update_progress.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';

class ComplaintStatusPage extends StatefulWidget {
  String complaintID;

  ComplaintStatusPage({
    Key key,
    @required this.complaintID,
  }) : super(key: key);

  @override
  State<ComplaintStatusPage> createState() => _ComplaintStatusPageState();
}

class _ComplaintStatusPageState extends State<ComplaintStatusPage> {
  Globals g = Globals();

  LineStyle lineStyleConst = LineStyle(
    color: Color(0xff037dd6),
    thickness: 3,
  );

  Padding widgetToReturn(
    Widget childWidget, {
    bool isSingle = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    if (isSingle) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
        child: TimelineTile(
          endChild: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 25,
            ),
            child: childWidget,
          ),
          isFirst: true,
          isLast: true,
          alignment: TimelineAlign.start,
          indicatorStyle: IndicatorStyle(
            drawGap: true,
            indicator: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Color(
                    0xff037dd6,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (isFirst) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
        child: TimelineTile(
          endChild: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 25,
            ),
            child: childWidget,
          ),
          isFirst: true,
          isLast: false,
          afterLineStyle: lineStyleConst,
          alignment: TimelineAlign.start,
          indicatorStyle: IndicatorStyle(
            indicator: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Color(
                    0xff037dd6,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (isLast) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
        child: TimelineTile(
          endChild: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 25,
            ),
            child: childWidget,
          ),
          isFirst: false,
          isLast: true,
          beforeLineStyle: lineStyleConst,
          alignment: TimelineAlign.start,
          indicatorStyle: IndicatorStyle(
            indicator: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Color(
                    0xff037dd6,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
        child: TimelineTile(
          endChild: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 25,
            ),
            child: childWidget,
          ),
          isFirst: false,
          isLast: false,
          afterLineStyle: lineStyleConst,
          beforeLineStyle: lineStyleConst,
          alignment: TimelineAlign.start,
          indicatorStyle: IndicatorStyle(
            indicator: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Color(
                    0xff037dd6,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 25,
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Complaint Progress",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: StreamBuilder<DocumentSnapshot>(
                stream: Database().streamOfAParticularComplaintFromSociety(
                  g.society,
                  widget.complaintID,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    return ListView.builder(
                      itemCount: snapshot.data["progress"].length,
                      itemBuilder: (context, index) {
                        if (snapshot.data["progress"].length == 1) {
                          return widgetToReturn(
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: CustomPaint(
                                        painter: Triangle(Color(0x77ffbcd9))),
                                  ),
                                  Expanded(
                                    child: Map<String, String>.from(snapshot
                                                .data["progress"][index])
                                            .containsKey("imageUrl")
                                        ? ChatBubbleWidget(
                                            content: snapshot.data["progress"]
                                                [index]["content"],
                                            userId: snapshot.data["progress"]
                                                [index]["postedBy"],
                                            time: snapshot.data["progress"]
                                                [index]["time"],
                                            imageUrl: snapshot.data["progress"]
                                                [index]["imageUrl"],
                                          )
                                        : ChatBubbleWidget(
                                            content: snapshot.data["progress"]
                                                [index]["content"],
                                            userId: snapshot.data["progress"]
                                                [index]["postedBy"],
                                            time: snapshot.data["progress"]
                                                [index]["time"],
                                          ),
                                  ),
                                ],
                              ),
                              isSingle: true);
                        } else {
                          return index == 0
                              ? widgetToReturn(
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: CustomPaint(
                                            painter:
                                                Triangle(Color(0x77ffbcd9))),
                                      ),
                                      Expanded(
                                        child: Map<String, String>.from(snapshot
                                                    .data["progress"][index])
                                                .containsKey("imageUrl")
                                            ? ChatBubbleWidget(
                                                content:
                                                    snapshot.data["progress"]
                                                        [index]["content"],
                                                userId:
                                                    snapshot.data["progress"]
                                                        [index]["postedBy"],
                                                time: snapshot.data["progress"]
                                                    [index]["time"],
                                                imageUrl:
                                                    snapshot.data["progress"]
                                                        [index]["imageUrl"],
                                              )
                                            : ChatBubbleWidget(
                                                content:
                                                    snapshot.data["progress"]
                                                        [index]["content"],
                                                userId:
                                                    snapshot.data["progress"]
                                                        [index]["postedBy"],
                                                time: snapshot.data["progress"]
                                                    [index]["time"],
                                              ),
                                      ),
                                    ],
                                  ),
                                  isFirst: true)
                              : index == snapshot.data["progress"].length - 1
                                  ? widgetToReturn(
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: CustomPaint(
                                                painter: Triangle(
                                                    Color(0x77ffbcd9))),
                                          ),
                                          Expanded(
                                            child: Map<String, String>.from(
                                                        snapshot.data[
                                                            "progress"][index])
                                                    .containsKey("imageUrl")
                                                ? ChatBubbleWidget(
                                                    content: snapshot
                                                            .data["progress"]
                                                        [index]["content"],
                                                    userId: snapshot
                                                            .data["progress"]
                                                        [index]["postedBy"],
                                                    time: snapshot
                                                            .data["progress"]
                                                        [index]["time"],
                                                    imageUrl: snapshot
                                                            .data["progress"]
                                                        [index]["imageUrl"],
                                                  )
                                                : ChatBubbleWidget(
                                                    content: snapshot
                                                            .data["progress"]
                                                        [index]["content"],
                                                    userId: snapshot
                                                            .data["progress"]
                                                        [index]["postedBy"],
                                                    time: snapshot
                                                            .data["progress"]
                                                        [index]["time"],
                                                  ),
                                          ),
                                        ],
                                      ),
                                      isLast: true)
                                  : widgetToReturn(
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: CustomPaint(
                                                painter: Triangle(
                                                    Color(0x77ffbcd9))),
                                          ),
                                          Expanded(
                                            child: Map<String, String>.from(
                                                        snapshot.data[
                                                            "progress"][index])
                                                    .containsKey("imageUrl")
                                                ? ChatBubbleWidget(
                                                    content: snapshot
                                                            .data["progress"]
                                                        [index]["content"],
                                                    userId: snapshot
                                                            .data["progress"]
                                                        [index]["postedBy"],
                                                    time: snapshot
                                                            .data["progress"]
                                                        [index]["time"],
                                                    imageUrl: snapshot
                                                            .data["progress"]
                                                        [index]["imageUrl"],
                                                  )
                                                : ChatBubbleWidget(
                                                    content: snapshot
                                                            .data["progress"]
                                                        [index]["content"],
                                                    userId: snapshot
                                                            .data["progress"]
                                                        [index]["postedBy"],
                                                    time: snapshot
                                                            .data["progress"]
                                                        [index]["time"],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    );
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.highlight_off_outlined,
                            color: Colors.redAccent,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Could not load complaint progress data",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            g.role == "Secretary"
                ? StreamBuilder<DocumentSnapshot>(
                    stream: Database().streamOfAParticularComplaintFromSociety(
                      g.society,
                      widget.complaintID,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loading();
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        if (snapshot.data["status"] == "Unresolved") {
                          return Expanded(
                            flex: 1,
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateProgress(
                                              complaintId: widget.complaintID,
                                              progress:
                                                  snapshot.data["progress"],
                                            )),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
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
                                    Icon(Icons.mode_outlined,
                                        color: Color(0xff037DD6)),
                                    SizedBox(width: 10),
                                    Text(
                                      'Update Progress',
                                      style: TextStyle(
                                        color: Color(0xff037DD6),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            flex: 0,
                            child: SizedBox(),
                          );
                        }
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                : Expanded(
                    flex: 0,
                    child: SizedBox(),
                  ),
            g.role == "Secretary"
                ? StreamBuilder<DocumentSnapshot>(
                    stream: Database().streamOfAParticularComplaintFromSociety(
                      g.society,
                      widget.complaintID,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loading();
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        if (snapshot.data["status"] == "Unresolved") {
                          return Expanded(
                            flex: 0,
                            child: TextButton(
                              onPressed: () async {
                                bool confirmation = await showConfirmationDialog(
                                    context,
                                    "Alert!",
                                    "Are you sure you want to mark this issue as 'Resolved'?");
                                if (confirmation) {
                                  String time = DateTime.now().toString();
                                  List temp = snapshot.data["progress"];
                                  temp.add({
                                    "content": "Complaint Resolved",
                                    "postedBy": g.uid,
                                    "time": time,
                                  });
                                  print(temp);
                                  Database()
                                      .markResolved(
                                    widget.complaintID,
                                    g.society,
                                    temp,
                                  )
                                      .then((value) {
                                    showToast(context, "success", "Success!",
                                        "Complaint marked as Resolved!");
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
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
                                  Icon(
                                    Icons.check,
                                    color: Color(0xff037DD6),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Mark as Resolved',
                                    style: TextStyle(
                                      color: Color(0xff037DD6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            flex: 0,
                            child: SizedBox(),
                          );
                        }
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                : Expanded(
                    flex: 0,
                    child: SizedBox(),
                  ),
          ],
        ),
      ),
    );
  }
}

class ChatBubbleWidget extends StatefulWidget {
  String content, userId, time, imageUrl = "";

  ChatBubbleWidget({
    Key key,
    @required this.content,
    @required this.userId,
    @required this.time,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  bool loading = false;
  String date;
  Globals g = Globals();

  Map<int, String> months = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  @override
  void initState() {
    super.initState();
    DateTime timeObject = DateTime.parse(widget.time);
    date = months[timeObject.month] +
        " " +
        timeObject.day.toString() +
        ", " +
        timeObject.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x77ffbcd9),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 1,
                          bottom: 1,
                        ),
                        child: Text(
                          widget.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    widget.imageUrl != null
                        ? Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 8,
                                right: 8,
                                top: 1,
                                bottom: 1,
                              ),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(widget.imageUrl),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: StreamBuilder(
                          stream: Database().userStream(
                            g.society,
                            widget.userId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox();
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              return Text(
                                snapshot.data["fname"] +
                                    " " +
                                    snapshot.data["lname"] +
                                    "  " +
                                    "(" +
                                    date +
                                    ")",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else {
                              return Text(
                                "Could not load user data",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bgColor
      ..strokeWidth = 7;

    var path = Path();
    //path.moveTo((size.width / 2), (size.height / 2));
    path.lineTo(15, -10);
    path.lineTo(15, 10);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
