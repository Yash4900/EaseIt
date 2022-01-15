import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import './approval/drop_down_list_model.dart';
import './approval/check_if_visitor.dart';
import './approval/file_select_drop_list.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter/material.dart';

// import 'details.dart';

String vehicleNumber = '';
PickedFile _image;
final picker = ImagePicker();
TextEditingController numberPlateController = TextEditingController();
DropListModel dropListModel = DropListModel([OptionItem(id: "1", title: "Entry"), OptionItem(id: "2", title: "Exit")]);
OptionItem optionItemSelected = OptionItem(id: "0", title: "Scan Number Plate");

class SecurityHome extends StatefulWidget {
  @override
  _SecurityHomeState createState() => _SecurityHomeState();
}

class _SecurityHomeState extends State<SecurityHome> {
  Globals g = Globals();
  
  @override
  void initState(){
    optionItemSelected = OptionItem(id: "0", title: "Scan Number Plate");
    // super.initState();
  }
  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('EaseIt - Security Guard'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 17),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ],
                        ),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.child_care_rounded, color: Color(0xFF307DF1),),
                            SizedBox(width: 10,),
                            Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: Text("Track Child", style: TextStyle(
                                      color: Color(0xFF307DF1),
                                      fontSize: 16),),
                                )
                            ),
                            Align(
                              alignment: Alignment(1, 0),
                            ),
                          ],
                        ),
                      ),         
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 17),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ],
                        ),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.card_giftcard, color: Color(0xFF307DF1),),
                            SizedBox(width: 10,),
                            Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: Text("Collect Parcel", style: TextStyle(
                                      color: Color(0xFF307DF1),
                                      fontSize: 16),),
                                )
                            ),
                            Align(
                              alignment: Alignment(1, 0),
                            ),
                          ],
                        ),
                      ),         
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 17),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ],
                        ),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.person, 
                            color: Color(0xFF307DF1),),
                            SizedBox(width: 10,),
                            Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: Text("Pre-Approved Visitors", style: TextStyle(
                                      color: Color(0xFF307DF1),
                                      fontSize: 16),),
                                )
                            ),
                            Align(
                              alignment: Alignment(1, 0),
                            ),
                          ],
                        ),
                      ),         
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              SelectDropList(
                optionItemSelected, 
                dropListModel, 
                (optionItem){
                  optionItemSelected = optionItem;
                      setState(() {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MyApp(optionItemSelected.title)),
                        // );
                        getImage();
                      });
                },
              )
            ]
            )
          )
        )
      )
    );    
  }

          

  Future scanText() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(),
        ));
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_image.path));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    vehicleNumber = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        vehicleNumber += line.text + '\n';
      }
    }
    vehicleNumber = vehicleNumber.replaceAll(' ', '');
    // Navigator.of(context).pop();
    setState(() {
      numberPlateController.text = vehicleNumber;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyApp()));
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
        _image = pickedFile;
    });
    scanText();
  }
  
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController numberPlateController = TextEditingController();
  @override
  void initState(){
    super.initState();
    numberPlateController.text = vehicleNumber;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      // backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          title: const Text('Automatic License Plate Recognition'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: getImage,
        //   child: const Icon(Icons.add_a_photo),
        // ),
        // floatingActionButton: SpeedDial(
        //   animatedIcon: AnimatedIcons.menu_close,
        //   // icon: Icon(Icons.add_a_photo),
        //   backgroundColor: Colors.black,
        //   overlayColor: Colors.black,
        //   overlayOpacity: 0.4,
        //   spacing: 12,
        //   spaceBetweenChildren: 12,
        //   openCloseDial: isDialOpen,
        //   onOpen: () => {
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       backgroundColor: Colors.blue,
        //       elevation: 10,
        //       padding: EdgeInsets.all(1),
        //       content: Text('Select if Entry or Exit', 
        //       style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold
        //       ))))
        //   },
        //   children: [
        //     SpeedDialChild(
        //       child: Icon(Icons.arrow_forward),
        //       label: 'Entry',
        //       onTap: () => getImage(),
        //     ),
        //     SpeedDialChild(
        //       child: Icon(Icons.arrow_back),
        //       label: 'Exit',
        //       onTap: () => getImage(),
        //     ),
        //   ],
        // ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 30
              ),
              _image != null
              ? Image.file(
                  File(_image.path),
                  fit: BoxFit.fitWidth,
                )
              : Container(),
              const SizedBox(
                height: 30
              ),
              vehicleNumber != ""
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    // Text("Number Plate: $vehicleNumber",
                    // style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      // autofocus: true,
                      controller: numberPlateController,
                      decoration: const InputDecoration(  
                        labelText: 'Vehicle Number',  
                      ),  
                    ),
                    const SizedBox(
                      height: 10
                    ),                    
                    Center(
                      child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () { 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CheckIfVisitor(
                            optionItemSelected.title,
                            numberPlateController.text,
                          )),
                        );
                      },
                      child: const Text('Confirm Vehicle Number',                      
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),  
                      ),
                    )
                    ),
                ]
              ):
              Container()
            ],
          ),          
          ),
        ),
        ),
  );
}}