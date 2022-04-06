import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/common/daily_helpers/daily_helper_profile.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyHelpersList extends StatefulWidget {
  @override
  _DailyHelpersListState createState() => _DailyHelpersListState();
}

class _DailyHelpersListState extends State<DailyHelpersList> {
  Globals g = Globals();
  String category = 'All';
  List<String> dropDownItems = [
    "All",
    "Maid",
    "Cook",
    "Driver",
    "Milkman",
    "Newspaper",
    "Laundry",
    "Car Cleaner",
    "Gym Instructor",
    "Tution Teacher",
    "Mechanic",
    "Plumber",
    "Delivery",
    "Technician",
    "Nanny",
    "Salesman",
    "Electrician",
    "Water Supplier"
  ];

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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Helpers',
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10),
                        DropdownButton(
                          value: category,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                          onChanged: (value) =>
                              setState(() => category = value),
                          items: dropDownItems.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ]),
            ),
            Expanded(
              flex: 11,
              child: StreamBuilder(
                stream: Database().getAllDailyHelperCategory(g.society, ""),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else {
                    return snapshot.data.docs.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              if (category == 'All' ||
                                  ds['purpose'] == category) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DailyHelper(ds),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 30,
                                      backgroundImage: ds['imageUrl'] == ""
                                          ? AssetImage('assets/dummy_image.jpg')
                                          : NetworkImage(ds['imageUrl']),
                                    ),
                                    title: Wrap(children: [
                                      Text(
                                        ds['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Color(0xffcb6f10)
                                              .withOpacity(0.2),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 7),
                                          child: Text(
                                            ds['purpose'],
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
                                      '+91-${ds['phoneNum']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey[200],
                                      child: IconButton(
                                        onPressed: () async {
                                          try {
                                            await launch(
                                                'tel:${ds['phoneNum']}');
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        },
                                        icon: Icon(
                                          Icons.phone,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/no_data.png',
                                  width: 300,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No daily helpers found',
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
