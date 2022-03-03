import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'allocate_parking.dart';

class VehicleBottomSheet extends StatefulWidget {
  final String licensePlateNo;
  final bool isEntry;
  VehicleBottomSheet(this.licensePlateNo, this.isEntry);
  @override
  _VehicleBottomSheetState createState() => _VehicleBottomSheetState();
}

class _VehicleBottomSheetState extends State<VehicleBottomSheet> {
  TextEditingController _licensePlateController = TextEditingController();
  PageController _pageController = PageController();
  TextEditingController _wingController = TextEditingController();
  TextEditingController _flatController = TextEditingController();
  TextEditingController _purposeController = TextEditingController();

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

  Future logActivity() async {
    if (qs.size == 0) {
      if (widget.isEntry) {
        setState(() => loading = true);
        try {
          await Database().logVisitorVehicleEntry(
              g.society,
              _licensePlateController.text,
              _flatController.text,
              _wingController.text,
              _purposeController.text);
          showToast(
              context, 'success', 'Success!', 'Activity logged successfully');
        } catch (e) {
          print(e.toString());
        }
      } else {
        try {
          await Database().logVisitorVehicleExit(
            g.society,
            _licensePlateController.text,
          );
          showToast(
              context, 'success', 'Success!', 'Activity logged successfully');
        } catch (e) {
          print(e.toString());
        }
      }
    } else {
      // Resident
      if (widget.isEntry) {
        setState(() => loading = true);
        try {
          await API().vehicleEntry(g.society.replaceAll(" ", ""), "MH01AE2222");
          showToast(
              context, "success", "Success!", "Log generated successfully");
        } catch (e) {
          showToast(context, "error", "Oops!", e.toString());
        }
        setState(() => loading = false);
      } else {
        setState(() => loading = true);
        try {
          await API().vehicleExit(g.society.replaceAll(" ", ""), "MH01AE2222");
          showToast(
              context, "success", "Success!", "Log generated successfully");
        } catch (e) {
          showToast(context, "error", "Oops!", e.toString());
        }
        setState(() => loading = false);
      }
    }
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
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.43,
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
                    : PageView(
                        controller: _pageController,
                        children: [
                          Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: qs.size == 0
                                      ? AssetImage('assets/dummy_image.jpg')
                                      : NetworkImage(qs.docs[0]['imageUrl']),
                                ),
                                title: Container(
                                  child: TextField(
                                    onChanged: (value) => showSearch = true,
                                    controller: _licensePlateController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(
                                  qs.size == 0
                                      ? 'Visitor'
                                      : 'Owner . ${qs.docs[0]["wing"]}-${qs.docs[0]["flatNo"]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: showSearch
                                    ? CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.search,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: () =>
                                                getVehicleDetails()),
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
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
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
                                    onPressed: () async {
                                      if (qs.size == 0 && widget.isEntry) {
                                        _pageController.animateToPage(1,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.decelerate);
                                      } else {
                                        await logActivity();
                                        Navigator.pop(context);
                                      }
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
                                        'Log activity',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  qs.size == 0 && widget.isEntry
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
                                                MaterialStateProperty.all<
                                                    Color>(Color(0xff037DD6)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Visit Information',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'FLAT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: 'Enter wing'),
                                      controller: _wingController,
                                      validator: (value) => value.length == 0
                                          ? 'Enter wing'
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: 'Enter flat no'),
                                      controller: _flatController,
                                      validator: (value) => value.length == 0
                                          ? 'Enter flat number'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'PURPOSE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Enter purpose'),
                                controller: _purposeController,
                                validator: (value) =>
                                    value.length == 0 ? 'Enter purpose' : null,
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _pageController.animateToPage(0,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.decelerate);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey[200]),
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
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () async {
                                      await logActivity();
                                      Navigator.pop(context);
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
                                        'Log activity',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
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
