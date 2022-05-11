import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/flat_data.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/image/pick_image.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ease_it/utility/display/custom_dropdown_widget.dart';
import 'package:image_cropper/image_cropper.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  File _profilePicture;
  TextEditingController _licensePlateController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _parkingNumberController = TextEditingController();

  String dropDownValue = "Four Wheeler";
  List<String> dropDownItems = ["Four Wheeler", "Two Wheeler"];
  final _formKey = GlobalKey<FormState>();
  Globals g = Globals();
  bool loading = false;
  String errorText = "";
  FlatData flatVar = FlatData();

  @override
  void initState() {
    super.initState();
    getSocietyStructure(g.society);
  }

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
              Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
              ),
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
          : Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Text(
                    'Add Vehicle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add details of vehicle below',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'IMAGE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
                              ? AssetImage('assets/dummy_image.jpg')
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
                          'LICENSE PLATE NO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter license plate number'),
                          controller: _licensePlateController,
                          validator: (value) => value.length == 0
                              ? 'Please enter license plate number'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'MODEL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Enter model'),
                          controller: _modelController,
                          validator: (value) => value.length == 0
                              ? 'Please enter vehicle number'
                              : null,
                        ),
                        SizedBox(width: 20),
                        Row(children: [
                          Text(
                            'VEHICLE TYPE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 15),
                          DropdownButton(
                            value: dropDownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            onChanged: (value) =>
                                setState(() => dropDownValue = value),
                            items: dropDownItems.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Row(children: [
                                  item == "Two Wheeler"
                                      ? Image.asset('assets/motor-bike.png',
                                          height: 20)
                                      : Image.asset('assets/parking.png',
                                          height: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    item,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ]),
                              );
                            }).toList(),
                          ),
                        ]),
                        SizedBox(height: 10),
                        Text(
                          'PARKING SPACE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Parking space number'),
                          controller: _parkingNumberController,
                          validator: (value) => value.length == 0
                              ? 'Please enter parking space number'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Owner",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'FLAT DETAILS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(flatVar.flatWidgetForm.length, (i) {
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
                        ),
                        Text(
                          errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                //print(flatVar.flatValue);
                                if (!flatVar.flatValue.contains(null)) {
                                  setState(() {
                                    errorText = "";
                                  });
                                  flatVar.createMapFromListForFlat();
                                  bool confirmation = await showConfirmationDialog(
                                      context,
                                      "Alert!",
                                      "Are you sure you want to register this vehicle?");
                                  if (confirmation) {
                                    setState(() => loading = true);
                                    String id = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    String imageUrl = _profilePicture == null
                                        ? ""
                                        : await Storage().storeImage(
                                            'vehicles', id, _profilePicture);
                                    await API().addVehicle(
                                        g.society
                                            .replaceAll(" ", "")
                                            .toLowerCase(),
                                        _licensePlateController.text,
                                        _parkingNumberController.text);
                                    Database()
                                        .addVehicle(
                                      g.society,
                                      imageUrl,
                                      _licensePlateController.text,
                                      _modelController.text,
                                      _parkingNumberController.text,
                                      dropDownValue,
                                      flatVar.flatNum,
                                    )
                                        .then((value) {
                                      setState(() => loading = false);
                                      Navigator.pop(context);
                                      showToast(context, "success", "Success!",
                                          "Vehicle added successfully in the database.");
                                    }).catchError(() {
                                      setState(() => loading = false);
                                      showToast(context, "error", "Oops!",
                                          "Something went wrong");
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errorText =
                                        "Please fill all the flat fields";
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
                                'Add Vehicle',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
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
