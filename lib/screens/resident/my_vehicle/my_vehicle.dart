import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyVehicle extends StatefulWidget {
  @override
  _MyVehicleState createState() => _MyVehicleState();
}

class _MyVehicleState extends State<MyVehicle> {
  Globals g = Globals();

  void showBottomSheeet(String imageUrl, String licensePlateNo, String model,
      String type, String owner, String parkinSpaceNo) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 90,
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            licensePlateNo,
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '$owner . Owner',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          Usage(23),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xff1a73e8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STATUS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Parked in premises',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: EdgeInsets.only(left: 10, top: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'MODEL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  model,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'VEHICLE TYPE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  type,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'PARKING SPOT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  parkinSpaceNo,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ]),
                        ),
                      ]),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'My Vehicles',
                style: GoogleFonts.sourceSansPro(
                    fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              flex: 8,
              child: FutureBuilder(
                future: Database().getMyVehicle(g.society, g.wing, g.flatNo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else {
                    return snapshot.data.docs.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return Card(
                                child: ListTile(
                                  onTap: () => showBottomSheeet(
                                      ds['imageUrl'],
                                      ds['licensePlateNo'],
                                      ds['model'],
                                      ds['vehicleType'],
                                      ds['wing'] + ' - ' + ds['flatNo'],
                                      ds['parkingSpaceNo']),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(ds['imageUrl']),
                                    radius: 25,
                                  ),
                                  title: Text(
                                    ds['model'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(ds['licensePlateNo']),
                                  trailing: ds['vehicleType'] == 'Four Wheeler'
                                      ? Icon(FontAwesomeIcons.car)
                                      : Icon(FontAwesomeIcons.motorcycle),
                                ),
                              );
                            })
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.car,
                                  size: 50,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No Events found',
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

class Usage extends StatefulWidget {
  final int usage;
  Usage(this.usage);
  @override
  _UsageState createState() => _UsageState();
}

class _UsageState extends State<Usage> {
  int usage = 0;
  Color getColor(int usage) {
    if (usage <= 10) return Colors.red;
    if (usage <= 18) return Colors.orange[700];
    if (usage <= 23) return Colors.yellow[700];
    return Colors.green[600];
  }

  void animate() async {
    while (true) {
      usage = usage + 2;
      if (usage >= widget.usage) {
        usage = widget.usage;
        break;
      }
      await Future.delayed(Duration(milliseconds: 100), () {
        setState(() {});
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) => animate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(
              backgroundColor: getColor(usage).withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                getColor(usage),
              ),
              value: usage / 30,
              strokeWidth: 13,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                '${(usage * 100 / 30).round().toString()} %',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
              ),
              Text(
                'USAGE',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }
}
