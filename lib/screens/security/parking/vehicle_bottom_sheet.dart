import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'allocate_parking.dart';

class VehicleBottomSheet extends StatefulWidget {
  final String licensePlateNo;
  VehicleBottomSheet(this.licensePlateNo);
  @override
  _VehicleBottomSheetState createState() => _VehicleBottomSheetState();
}

class _VehicleBottomSheetState extends State<VehicleBottomSheet> {
  TextEditingController _licensePlateController = TextEditingController();
  bool loading = true;
  bool showSearch = false;
  QuerySnapshot qs;
  Globals g = Globals();

  getVehicleDetails() async {
    if (!loading) setState(() => loading = true);
    qs =
        await Database().searchVehicle(g.society, _licensePlateController.text);
    showSearch = false;
    setState(() => loading = false);
  }

  @override
  void initState() {
    _licensePlateController.text = widget.licensePlateNo;
    getVehicleDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: loading
                    ? Loading()
                    : Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundImage: qs.size == 0
                                  ? AssetImage('assets/dummy_image.jpg')
                                  : NetworkImage(qs.docs[0]['imageUrl']),
                            ),
                            title: Flexible(
                              child: TextField(
                                onChanged: (value) => showSearch = true,
                                controller: _licensePlateController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text(
                              qs.size == 0
                                  ? 'Visitor'
                                  : 'Owner . ${qs.docs[0]["wing"]}-${qs.docs[0]["flatNo"]}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: showSearch
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () => getVehicleDetails()),
                                  )
                                : SizedBox(),
                          ),
                          SizedBox(height: 15),
                          qs.size == 0
                              ? Icon(
                                  Icons.warning_amber_outlined,
                                  color: Color(0xffe68619),
                                  size: 150,
                                )
                              : Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Color(0xff107154),
                                  size: 150,
                                ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey[200]),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () async {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff037DD6)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Log activity',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              qs.size == 0
                                  ? TextButton(
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllocateParking(
                                                        _licensePlateController
                                                            .text)));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff037DD6)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          'Assign Parking',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
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
