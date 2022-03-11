import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/flask/api.dart';
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

  void showBottomSheeet(
      String imageUrl,
      String licensePlateNo,
      String model,
      String type,
      String owner,
      String parkinSpaceNo,
      List<dynamic> exitTime,
      List<dynamic> entryTime,
      List<dynamic> days,
      dynamic usage,
      dynamic inUse) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: 530,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                            title: Text(
                              licensePlateNo,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Owner . $owner',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 5),
                          Usage(usage),
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
                            color: Color(0xff037DD6),
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
                                inUse ? 'In Use' : 'Parked in premises',
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Usage Pattern',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 2),
                            height: 180,
                            width: 25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('23:59', style: TextStyle(fontSize: 10)),
                                Text('21:00', style: TextStyle(fontSize: 10)),
                                Text('18:00', style: TextStyle(fontSize: 10)),
                                Text('15:00', style: TextStyle(fontSize: 10)),
                                Text('12:00', style: TextStyle(fontSize: 10)),
                                Text('09:00', style: TextStyle(fontSize: 10)),
                                Text('06:00', style: TextStyle(fontSize: 10)),
                                Text('03:00', style: TextStyle(fontSize: 10)),
                                Text('00:00', style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                          for (int i = 0; i < days.length; i++)
                            Expanded(
                              child: exitTime[i] == 0
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1),
                                      height: 180,
                                      color: Colors.red.withOpacity(0.4),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1),
                                          height:
                                              ((entryTime[i] - exitTime[i]) >= 0
                                                      ? 86400 - entryTime[i]
                                                      : 0) *
                                                  180 /
                                                  86400,
                                          color: Colors.green.withOpacity(0.2),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1),
                                          height:
                                              ((entryTime[i] - exitTime[i]) >= 0
                                                      ? (entryTime[i] -
                                                          exitTime[i])
                                                      : (86400 - exitTime[i])) *
                                                  180 /
                                                  86400,
                                          color: Colors.green,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1),
                                          height: exitTime[i] * 180 / 86400,
                                          color: Colors.green.withOpacity(0.2),
                                        )
                                      ],
                                    ),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 25,
                          ),
                          for (int i = 0; i < days.length; i++)
                            Expanded(
                              child: Center(
                                child: Text(
                                  days[i],
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.grey[600]),
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                )
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
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 3.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: ListTile(
                                  onTap: () async {
                                    var response = await API().getUsage(
                                        g.society
                                            .replaceAll(" ", "")
                                            .toLowerCase(),
                                        ds['licensePlateNo']);
                                    Map<String, dynamic> map =
                                        jsonDecode(response);
                                    showBottomSheeet(
                                        ds['imageUrl'],
                                        ds['licensePlateNo'],
                                        ds['model'],
                                        ds['vehicleType'],
                                        ds['wing'] + ' - ' + ds['flatNo'],
                                        ds['parkingSpaceNo'],
                                        map['exit_time'],
                                        map['entry_time'],
                                        map['day'],
                                        map['usage'],
                                        map['in_use']);
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(ds['imageUrl']),
                                    backgroundColor: Colors.grey[300],
                                    radius: 25,
                                  ),
                                  title: Text(
                                    ds['model'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    ds['licensePlateNo'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
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
                                  'No vehicles found',
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
