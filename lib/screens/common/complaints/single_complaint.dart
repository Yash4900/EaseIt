import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/display/time_ago.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/image/multiple_image_viewer.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ease_it/screens/common/complaints/complaint_status_page.dart';

class SingleComplaint extends StatefulWidget {
  final String id;
  final String title;
  final String desc;
  final List<String> image;
  final Timestamp postedOn;
  final String postedBy;
  final String status;
  final int likedBy;
  final Map<String, dynamic> likes;
  final List<String> ids;
  final List progress;
  SingleComplaint(
      this.id,
      this.title,
      this.desc,
      this.image,
      this.postedOn,
      this.postedBy,
      this.status,
      this.likedBy,
      this.likes,
      this.ids,
      this.progress);
  @override
  _SingleComplaintState createState() => _SingleComplaintState();
}

class _SingleComplaintState extends State<SingleComplaint> {
  Globals g = Globals();
  DateTime date;

  String getInitials(String name) {
    List<String> words = name.split(" ");
    return words[0][0] + words[1][0];
  }

  List<Color> colors = [
    Color(0XFFD5573B),
    Color(0XFF274C77),
    Color(0XFF777DA7),
    Color(0XFFDC6BAD),
    Color(0XFF4C956C),
    Color(0XFFEF233C),
    Color(0XFFC1666B),
  ];

  bool loading = false;

  @override
  void initState() {
    date = widget.postedOn.toDate();
    super.initState();
  }

  Widget returnCarouselWidget(List<String> imgList) {
    List<Widget> imageSliders = createImageSlidingWidget(imgList);
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          initialPage: 2,
          autoPlay: true,
        ),
        items: imageSliders,
      ),
    );
  }

  List<Widget> createImageSlidingWidget(List<String> imgList) {
    List<Widget> temp = imgList
        .map((item) => Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultipleImageViewer(
                        imageFiles: imgList,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(item,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.9),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                'Image No. ${imgList.indexOf(item) + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ))
        .toList();
    // temp.add(
    //   Container(
    //     color: Colors.grey[200],
    //     child: GestureDetector(
    //       onTap: () async {
    //         imageFiles = await Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => MultipleImageEditor(
    //               imageFiles: imageFiles,
    //             ),
    //           ),
    //         );
    //         setState(() {});
    //       },
    //       child: Container(
    //         width: MediaQuery.of(context).size.width * 0.9,
    //         margin: EdgeInsets.all(5.0),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: temp.length == 5
    //                 ? [
    //                     Icon(
    //                       Icons.edit,
    //                       color: Colors.grey[500],
    //                       size: 25,
    //                     ),
    //                     Text(
    //                       "Edit Images",
    //                       style: TextStyle(
    //                         color: Colors.grey[500],
    //                         fontSize: 25,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ]
    //                 : [
    //                     Icon(
    //                       Icons.add,
    //                       color: Colors.grey[500],
    //                       size: 25,
    //                     ),
    //                     Text(
    //                       "Add Images",
    //                       style: TextStyle(
    //                         color: Colors.grey[500],
    //                         fontSize: 25,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return temp;
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
              Icon(Icons.arrow_back, color: Colors.black),
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
      body: loading
          ? Loading()
          : StreamBuilder<DocumentSnapshot>(
              stream: Database().streamOfAParticularComplaintFromSociety(
                g.society,
                widget.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.image == null || widget.image.isEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/dummy_image.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            )
                          : returnCarouselWidget(widget.image),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.title,
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.desc,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.postedBy,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              timeAgo(date),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: snapshot.data["status"] == "Resolved"
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.check_circle_outline_rounded,
                                      color: Color(0xff107154)),
                                  SizedBox(width: 10),
                                  Text(
                                    'Resolved',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ComplaintStatusPage(
                                              complaintID: widget.id,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.fact_check,
                                        size: 37.5,
                                        color: Color(0xff037dd6),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : g.role == "Secretary"
                                ? Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: TextButton(
                                          onPressed: () async {
                                            bool confirmation =
                                                await showConfirmationDialog(
                                                    context,
                                                    "Alert!",
                                                    "Are you sure you want to mark this issue as 'Resolved'?");
                                            if (confirmation) {
                                              String dayResolved =
                                                  DateTime.now().toString();
                                              List temp =
                                                  snapshot.data["progress"];
                                              temp.add({
                                                "content": "Complaint Resolved",
                                                "postedBy": g.uid,
                                                "time": dayResolved,
                                              });
                                              Database()
                                                  .markResolved(
                                                widget.id,
                                                g.society,
                                                temp,
                                              )
                                                  .then((value) {
                                                //ssetState(() => loading = false);
                                                showToast(
                                                    context,
                                                    "success",
                                                    "Success!",
                                                    "Complaint marked as Resolved!");
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(23),
                                                side: BorderSide(
                                                  color: Color(0xff037DD6),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ComplaintStatusPage(
                                                  complaintID: widget.id,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.fact_check,
                                            size: 37.5,
                                            color: Color(0xff037dd6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: Color(0xffbb121a),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Unresolved',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ComplaintStatusPage(
                                                  complaintID: widget.id,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.fact_check,
                                            size: 37.5,
                                            color: Color(0xff037dd6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Liked by',
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (int i = 0; i < widget.likedBy; i++)
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: colors[i],
                                      child: Text(
                                        getInitials(
                                            widget.likes[widget.ids[i]]),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      widget.likes[widget.ids[i]],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      )
                    ],
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
                          size: 25,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Could not load complaint data",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                }
              }),
    );
  }
}
