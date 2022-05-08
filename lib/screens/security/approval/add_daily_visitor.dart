// Add Daily Helper

import 'dart:math';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/display/qr_code.dart';
import 'package:ease_it/utility/flat_data.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/image/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/display/custom_dropdown_widget.dart';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:image_cropper/image_cropper.dart';

typedef void MapCallback(Map<String, String> val);

class AddDailyVisitor extends StatefulWidget {
  @override
  _AddDailyVisitorState createState() => _AddDailyVisitorState();
}

class _AddDailyVisitorState extends State<AddDailyVisitor> {
  List<String> dropDownItems = [
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

  Globals g = Globals();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _flatController = TextEditingController();
  TextEditingController _wingController = TextEditingController();
  Map<String, String> flat = {};
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = "Maid";
  String errorText = "";
  List<Map<String, String>> flatsNew = [];
  List<String> flats = [];
  File _profilePicture;

  bool alreadyPresent(
      List<Map<String, String>> flats, Map<String, String> flat) {
    for (Map<String, String> i in flats) {
      if (DeepCollectionEquality().equals(i, flat)) {
        return true;
      }
    }
    return false;
  }

  int generateCode() {
    var random = Random();
    int code = 0;
    for (int i = 0; i < 6; i++) {
      code = (code * 10 + random.nextInt(9) + 1);
    }
    return code;
  }

  // Dialog to select flat
  Future<Map<String, String>> showFlatDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Flat'),
        content: Container(
          child: DailyVisitorFlatAcceptance(
            callback: (val) => setState(() => flat = val),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(<String, String>{});
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey[200]),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.w600),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              print("Flat Value is: $flat");
              if (flat.isEmpty) {
                Navigator.of(context).pop("");
              } else {
                Navigator.of(context).pop(flat);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff037DD6)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Add',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
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
        padding: EdgeInsets.all(15),
        child: loading
            ? Loading()
            : ListView(
                children: [
                  Text(
                    'Add to Daily Visitor',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add visitor details below',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'IMAGE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _profilePicture =
                          await PickImage().showPicker(context, 50);
                      if (_profilePicture != null) {
                        _profilePicture = await ImageCropper.cropImage(
                          sourcePath: _profilePicture.path,
                          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                          androidUiSettings: AndroidUiSettings(
                            toolbarTitle: 'Crop Image',
                            toolbarColor: Colors.black,
                            activeControlsWidgetColor: Color(0xff037DD6),
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: true,
                          ),
                        );
                      }
                      setState(() {});
                    },
                    child: Container(
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _profilePicture == null
                              ? AssetImage('assets/profile_dummy.png')
                              : FileImage(_profilePicture),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'NAME',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter visitor\'s name'),
                          controller: _nameController,
                          validator: (value) => value.length == 0
                              ? 'Please enter visitor name'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'PHONE NUMBER',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter visitor\'s phone number'),
                          controller: _phoneController,
                          validator: (value) => value.length < 10
                              ? 'Please enter a phone number'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Row(children: [
                          Text(
                            'FLATS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () async {
                              Map<String, String> flatValueReceived =
                                  await showFlatDialog();
                              if (flatValueReceived.isNotEmpty) {
                                print("Flat Value received:$flatValueReceived");
                                if (!alreadyPresent(
                                    flatsNew, flatValueReceived))
                                  flatsNew.add(
                                      <String, String>{...flatValueReceived});
                                setState(() {});
                              }
                              print("FlatsNew: $flatsNew");
                              flat.clear();
                              _wingController.clear();
                              _flatController.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0xff1a73e8).withOpacity(0.2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.add,
                                      size: 16, color: Color(0xff1a73e8)),
                                  Icon(Icons.home_outlined,
                                      size: 16, color: Color(0xff1a73e8))
                                ],
                              ),
                            ),
                          )
                        ]),
                        SizedBox(height: 5),
                        Wrap(
                          children: flatsNew.map((flat) {
                            print("FlatsNew: $flatsNew");
                            print(flat);
                            return InkWell(
                              onTap: () {
                                flatsNew.remove(flat);
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                // constraints: BoxConstraints(
                                //   maxWidth: 300,
                                // ),
                                //width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 1,
                                      ),
                                      child: Text(FlatDataOperations(
                                              hierarchy: g.hierarchy,
                                              flatNum: flat)
                                          .returnStringFormOfFlatMap()),
                                    ),
                                    SizedBox(width: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 15),
                                      child: Icon(
                                        Icons.clear,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Text(
                          errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(width: 20),
                        Row(children: [
                          Text(
                            'PURPOSE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 15),
                          DropdownButton(
                            value: dropDownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            onChanged: (value) =>
                                setState(() => dropDownValue = value),
                            items: dropDownItems.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ]),
                        SizedBox(height: 40),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (flatsNew.isNotEmpty) {
                                  setState(() {
                                    errorText = "";
                                  });
                                  bool confirmation = await showConfirmationDialog(
                                      context,
                                      "Alert!",
                                      "Are you sure you want to add to daily helper?");
                                  if (confirmation) {
                                    setState(() => loading = true);
                                    String id = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    String imageUrl = _profilePicture == null
                                        ? ""
                                        : await Storage().storeImage(
                                            'dailyHelpers',
                                            id,
                                            _profilePicture);
                                    int code = generateCode();
                                    await Database()
                                        .addDailyHelper(
                                            g.society,
                                            _nameController.text,
                                            _phoneController.text,
                                            flatsNew,
                                            imageUrl,
                                            dropDownValue,
                                            code.toString())
                                        .then((value) {
                                      setState(() => loading = false);
                                      showQRDialog(context, code.toString());
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errorText = "Add Atleast 1 flat";
                                  });
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff037DD6)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class DailyVisitorFlatAcceptance extends StatefulWidget {
  final MapCallback callback;

  DailyVisitorFlatAcceptance({Key key, @required this.callback})
      : super(key: key);

  @override
  State<DailyVisitorFlatAcceptance> createState() =>
      _DailyVisitorFlatAcceptanceState();
}

class _DailyVisitorFlatAcceptanceState
    extends State<DailyVisitorFlatAcceptance> {
  FlatData flatVar = FlatData();
  Globals g = Globals();
  bool loading = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    getSocietyStructure(g.society);
  }

  void _update() {
    setState(() {});
    if (!flatVar.flatValue.contains(null)) {
      flatVar.createMapFromListForFlat();
      widget.callback(flatVar.flatNum);
    }
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            //physics: ClampingScrollPhysics(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(flatVar.flatWidgetForm.length, (i) {
              //return flatVar.flatWidgetForm[i];
              if ((i + 1) % 2 == 1) {
                if (i + 1 < flatVar.flatWidgetForm.length) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: flatVar.flatWidgetForm[i],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: flatVar.flatWidgetForm[i + 1],
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: flatVar.flatWidgetForm[i],
                      ),
                    ],
                  );
                }
              } else {
                return SizedBox();
              }
            }),
          ));
  }
}
