import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/flat_data.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'allocate_parking.dart';
import 'package:ease_it/utility/display/custom_dropdown_widget.dart';

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
  // TextEditingController _wingController = TextEditingController();
  // TextEditingController _flatController = TextEditingController();
  TextEditingController _purposeController = TextEditingController();

  bool loading = true;
  bool showSearch = false;
  QuerySnapshot qs;
  Globals g = Globals();
  String errorText = "";
  FlatData flatVar = FlatData();

  void _update() {
    setState(() {});
  }

  void getSocietyStructure(String societyValue) async {
    setState(() => loading = true);
    //print(List<String>.from(societyStructureWidget[societyStructureWidget["Hierarchy"][0]]));
    //Empty all previous data and set new data
    //print(
    //    "%%%%%%%%%%%%%%%%%%%%% getSocietyStructure is called %%%%%%%%%%%%%%%%%%%%%");
    //print("Set error text to null");
    errorText = "";
    //print("Clearing the Widget form that I have created");
    flatVar.clearFlatWidgetForm();
    //print("Clearing the flat values map");
    flatVar.clearFlatNum();
    //print("Clearing the flat value list");
    flatVar.clearFlatValue();
    //print("Setting current level");
    flatVar.setCurrentLevel = 1;
    //print("Setting widget flat form to empty");
    flatVar.setFlatWidgetForm = [];
    //print("Setting all update functions to null");
    flatVar.setAllUpdateFunctions = [];

    //get society info
    Map<dynamic, dynamic> tempSnapData =
        await Database().getSocietyInfo(societyValue);
    //print("The data: $tempSnapData");

    //set structure
    //print("Setting the structure to incoming data");
    flatVar.setStructure = Map<String, dynamic>.from(tempSnapData);
    //print("Setting the total levels of hierarchy");
    flatVar.setTotalLevels =
        tempSnapData["Hierarchy"].length; // set total levels
    //print("Flat value list to null");
    flatVar.setFlatValue =
        List<String>.filled(flatVar.totalLevels, null, growable: true);
    //print("Adding initial dropdown to the flatWidgetForm that is the list");
    flatVar.addInFlatWidgetForm(CustomDropDown(
      options: flatVar.getILevelInHierarchy(flatVar.currentLevel),
      typeText: flatVar.getTypeText(flatVar.currentLevel),
      flatVariable: flatVar,
      update: _update,
    ));
    //print(
    //    "%%%%%%%%%%%%%%%%%%%%% getSocietyStructure is called %%%%%%%%%%%%%%%%%%%%%");
    //print(societyStructureWidget);
    setState(() => loading = false);
  }

  getVehicleDetails() async {
    if (!loading) setState(() => loading = true);
    qs =
        await Database().searchVehicle(g.society, _licensePlateController.text);
    showSearch = false;
    setState(() => loading = false);
  }

  Future logActivity() async {
    if (qs.size == 0) {
      // Visitor
      if (widget.isEntry) {
        setState(() => loading = true);
        try {
          if (!flatVar.flatValue.contains(null)) {
            setState(() {
              errorText = "";
            });
            flatVar.createMapFromListForFlat();
            await Database().logVisitorVehicleEntry(
                g.society,
                _licensePlateController.text,
                flatVar.flatNum,
                //_flatController.text,
                //_wingController.text,
                _purposeController.text);
            showToast(
                context, 'success', 'Success!', 'Activity logged successfully');
          } else {
            setState(() {
              errorText = "Please fill all the flat fields";
            });
          }
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
          await API().vehicleEntry(
              g.society.replaceAll(" ", ""), _licensePlateController.text);
          showToast(
              context, "success", "Success!", "Log generated successfully");
        } catch (e) {
          showToast(context, "error", "Oops!", e.toString());
        }
        setState(() => loading = false);
      } else {
        setState(() => loading = true);
        try {
          await API().vehicleExit(
              g.society.replaceAll(" ", ""), _licensePlateController.text);
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
    getSocietyStructure(g.society);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                                            ? AssetImage(
                                                'assets/dummy_image.jpg')
                                            : NetworkImage(
                                                qs.docs[0]['imageUrl']),
                                      ),
                                      title: Container(
                                        child: TextField(
                                          onChanged: (value) =>
                                              showSearch = true,
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
                                            : 'Owner . ${FlatDataOperations(hierarchy: g.hierarchy, flatNum: qs.docs[0]['flat']).returnStringFormOfFlatMap()}', //${qs.docs[0]["wing"]}-${qs.docs[0]["flatNo"]}',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey[200]),
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
                                            if (qs.size == 0 &&
                                                widget.isEntry) {
                                              _pageController.animateToPage(1,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.decelerate);
                                            } else {
                                              await logActivity();
                                              Navigator.pop(context);
                                            }
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
                                                              Color>(
                                                          Color(0xff037DD6)),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22),
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
                                                        fontWeight:
                                                            FontWeight.w600),
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
                                    SizedBox(height: 10),
                                    Text(
                                      'Visit Information',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'FLAT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Column(
                                      //physics: ClampingScrollPhysics(),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          flatVar.flatWidgetForm.length, (i) {
                                        //return flatVar.flatWidgetForm[i];
                                        if ((i + 1) % 2 == 1) {
                                          if (i + 1 <
                                              flatVar.flatWidgetForm.length) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      flatVar.flatWidgetForm[i],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: flatVar
                                                      .flatWidgetForm[i + 1],
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      flatVar.flatWidgetForm[i],
                                                ),
                                              ],
                                            );
                                          }
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                    ),
                                    Text(
                                      errorText,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'PURPOSE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          hintText: 'Enter purpose'),
                                      controller: _purposeController,
                                      validator: (value) => value.length == 0
                                          ? 'Enter purpose'
                                          : null,
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _pageController.animateToPage(0,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.decelerate);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey[200]),
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
