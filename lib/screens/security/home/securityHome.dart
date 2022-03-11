import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/security/approval/code_approval.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityHome extends StatefulWidget {
  @override
  _SecurityHomeState createState() => _SecurityHomeState();
}

class _SecurityHomeState extends State<SecurityHome> {
  Globals g = Globals();
  TextEditingController _codeController = TextEditingController();

  void onClick() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: _codeController.text == ""
                  ? Text('Enter code', style: TextStyle(fontSize: 25))
                  : Text(
                      _codeController.text,
                      style:
                          GoogleFonts.urbanist(fontSize: 30, letterSpacing: 2),
                    ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Button(1, _codeController, onClick),
                      Button(2, _codeController, onClick),
                      Button(3, _codeController, onClick)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Button(4, _codeController, onClick),
                      Button(5, _codeController, onClick),
                      Button(6, _codeController, onClick)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Button(7, _codeController, onClick),
                      Button(8, _codeController, onClick),
                      Button(9, _codeController, onClick)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Color(0xff037DD6),
                          onTap: () {
                            if (_codeController.text.length > 0) {
                              _codeController.text = _codeController.text
                                  .substring(
                                      0, _codeController.text.length - 1);
                              setState(() {});
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(3),
                            child:
                                Center(child: Icon(Icons.backspace_outlined)),
                          ),
                        ),
                      ),
                      Button(0, _codeController, onClick),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      QueryDocumentSnapshot qds = await Database().verifyByCode(
                          g.society, int.parse(_codeController.text));
                      if (qds == null) {
                        showMessageDialog(context, 'Invalid Code!', '', [
                          Center(
                            child: Image.asset(
                              'assets/error.png',
                              width: 230,
                            ),
                          ),
                          Center(
                            child: Text(
                              'The code provided by visitor does not exists or is expired!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ]);
                      } else {
                        String imageUrl = null;
                        try {
                          imageUrl = qds['imageUrl'];
                        } catch (e) {
                          print(e.toString());
                        }
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) => CodeApproval(
                              qds.id,
                              qds['name'],
                              qds['purpose'],
                              imageUrl != null
                                  ? 'Daily Helper'
                                  : 'Pre Approved Visitor',
                              imageUrl ?? '',
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Verify Visitor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final int value;
  final TextEditingController controller;
  final Function onClick;
  Button(this.value, this.controller, this.onClick);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        highlightColor: Color(0xff037DD6),
        onTap: () {
          if (controller.text.length < 6) {
            controller.text = controller.text + value.toString();
            onClick();
          }
        },
        child: Container(
          margin: EdgeInsets.all(3),
          child: Center(
            child: Text(
              value.toString(),
              style: GoogleFonts.urbanist(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:ease_it/screens/security/approval/approve_visitor.dart';
// import 'package:ease_it/utility/globals.dart';
// import 'package:flutter/material.dart';

// class SecurityHome extends StatefulWidget {
//   @override
//   _SecurityHomeState createState() => _SecurityHomeState();
// }

// class _SecurityHomeState extends State<SecurityHome> {
//   Globals g = Globals();
//   TextEditingController _codeController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
//       child: ListView(
//         children: [
//           Text(
//             'Hello, ${g.fname}',
//             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.grey[200],
//               ),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(8),
//               ),
//               image: DecorationImage(
//                   image: AssetImage('assets/approval_by_code.png'),
//                   fit: BoxFit.fill),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Approve visitor by Code",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 20),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Container(
//                           width: 100,
//                           child: TextField(
//                             controller: _codeController,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             obscureText: true,
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 6,
//                             ),
//                             autocorrect: false,
//                             decoration: InputDecoration(
//                               hintText: "......",
//                               hintStyle: TextStyle(
//                                   color: Colors.grey[400],
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 30,
//                                   letterSpacing: 6),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         TextButton(
//                           onPressed: () {},
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Color(0xff1a73e8)),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
//                             child: Text(
//                               'VERIFY',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         )
//                       ])
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.grey[200],
//               ),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(8),
//               ),
//               image: DecorationImage(
//                   image: AssetImage('assets/visitor_approval.png'),
//                   fit: BoxFit.cover),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Approve new visitor",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ApproveVisitor()));
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               Color(0xff1a73e8)),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
//                           child: Text(
//                             'PROCEED',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'package:ease_it/screens/security/approval/pre_approved.dart';
// import 'package:ease_it/utility/globals.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import './approval/drop_down_list_model.dart';
// import './approval/check_if_visitor.dart';
// import './approval/file_select_drop_list.dart';

// // ignore: import_of_legacy_library_into_null_safe
// import 'package:image_picker/image_picker.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

// // import 'details.dart';

// String vehicleNumber = '';
// PickedFile _image;
// final picker = ImagePicker();
// TextEditingController numberPlateController = TextEditingController();
// DropListModel dropListModel = DropListModel(
//     [OptionItem(id: "1", title: "Entry"), OptionItem(id: "2", title: "Exit")]);
// OptionItem optionItemSelected = OptionItem(id: "0", title: "Scan Number Plate");

// class SecurityHome extends StatefulWidget {
//   @override
//   _SecurityHomeState createState() => _SecurityHomeState();
// }

// class _SecurityHomeState extends State<SecurityHome> {
//   Globals g = Globals();

//   @override
//   void initState() {
//     optionItemSelected = OptionItem(id: "0", title: "Scan Number Plate");
//     // super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // backgroundColor: Colors.amber.shade50,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text('EaseIt - Security Guard'),
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: SizedBox(
//                 height: double.infinity,
//                 width: double.infinity,
//                 child: SingleChildScrollView(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                       Center(
//                           child: Container(
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 17),
//                               decoration: new BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                       blurRadius: 10,
//                                       color: Colors.black26,
//                                       offset: Offset(0, 2))
//                                 ],
//                               ),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     Icons.child_care_rounded,
//                                     color: Color(0xFF307DF1),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Expanded(
//                                       child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {});
//                                     },
//                                     child: Text(
//                                       "Track Child",
//                                       style: TextStyle(
//                                           color: Color(0xFF307DF1),
//                                           fontSize: 16),
//                                     ),
//                                   )),
//                                   Align(
//                                     alignment: Alignment(1, 0),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Center(
//                           child: Container(
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 17),
//                               decoration: new BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                       blurRadius: 10,
//                                       color: Colors.black26,
//                                       offset: Offset(0, 2))
//                                 ],
//                               ),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     Icons.card_giftcard,
//                                     color: Color(0xFF307DF1),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Expanded(
//                                       child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {});
//                                     },
//                                     child: Text(
//                                       "Collect Parcel",
//                                       style: TextStyle(
//                                           color: Color(0xFF307DF1),
//                                           fontSize: 16),
//                                     ),
//                                   )),
//                                   Align(
//                                     alignment: Alignment(1, 0),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Center(
//                           child: Container(
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 17),
//                               decoration: new BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                       blurRadius: 10,
//                                       color: Colors.black26,
//                                       offset: Offset(0, 2))
//                                 ],
//                               ),
//                               child: new Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     Icons.person,
//                                     color: Color(0xFF307DF1),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Expanded(
//                                       child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   PreApproved()),
//                                         );
//                                       });
//                                     },
//                                     child: Text(
//                                       "Pre-Approved Visitors",
//                                       style: TextStyle(
//                                           color: Color(0xFF307DF1),
//                                           fontSize: 16),
//                                     ),
//                                   )),
//                                   Align(
//                                     alignment: Alignment(1, 0),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       SelectDropList(
//                         optionItemSelected,
//                         dropListModel,
//                         (optionItem) {
//                           optionItemSelected = optionItem;
//                           setState(() {
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(builder: (context) => MyApp(optionItemSelected.title)),
//                             // );
//                             getImage();
//                           });
//                         },
//                       )
//                     ])))));
//   }

//   Future scanText() async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => const Center(
//               child: CircularProgressIndicator(),
//             ));
//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(File(_image.path));
//     final TextRecognizer textRecognizer =
//         FirebaseVision.instance.textRecognizer();
//     final VisionText visionText =
//         await textRecognizer.processImage(visionImage);
//     vehicleNumber = "";
//     for (TextBlock block in visionText.blocks) {
//       for (TextLine line in block.lines) {
//         vehicleNumber += line.text + '\n';
//       }
//     }
//     vehicleNumber = vehicleNumber.replaceAll(' ', '');
//     // Navigator.of(context).pop();
//     setState(() {
//       numberPlateController.text = vehicleNumber;
//     });
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => MyApp()));
//   }

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     setState(() {
//       _image = pickedFile;
//     });
//     scanText();
//   }
// }

// class MyApp extends StatefulWidget {
//   MyApp({Key key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   TextEditingController numberPlateController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     numberPlateController.text = vehicleNumber;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.amber.shade50,
//       appBar: AppBar(
//         title: const Text('Automatic License Plate Recognition'),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: getImage,
//       //   child: const Icon(Icons.add_a_photo),
//       // ),
//       // floatingActionButton: SpeedDial(
//       //   animatedIcon: AnimatedIcons.menu_close,
//       //   // icon: Icon(Icons.add_a_photo),
//       //   backgroundColor: Colors.black,
//       //   overlayColor: Colors.black,
//       //   overlayOpacity: 0.4,
//       //   spacing: 12,
//       //   spaceBetweenChildren: 12,
//       //   openCloseDial: isDialOpen,
//       //   onOpen: () => {
//       //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //       backgroundColor: Colors.blue,
//       //       elevation: 10,
//       //       padding: EdgeInsets.all(1),
//       //       content: Text('Select if Entry or Exit',
//       //       style: TextStyle(
//       //         fontSize: 20,
//       //         fontWeight: FontWeight.bold
//       //       ))))
//       //   },
//       //   children: [
//       //     SpeedDialChild(
//       //       child: Icon(Icons.arrow_forward),
//       //       label: 'Entry',
//       //       onTap: () => getImage(),
//       //     ),
//       //     SpeedDialChild(
//       //       child: Icon(Icons.arrow_back),
//       //       label: 'Exit',
//       //       onTap: () => getImage(),
//       //     ),
//       //   ],
//       // ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 const SizedBox(height: 30),
//                 _image != null
//                     ? Image.file(
//                         File(_image.path),
//                         fit: BoxFit.fitWidth,
//                       )
//                     : Container(),
//                 const SizedBox(height: 30),
//                 vehicleNumber != ""
//                     ? Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                             // Text("Number Plate: $vehicleNumber",
//                             // style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                             TextField(
//                               // autofocus: true,
//                               controller: numberPlateController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Vehicle Number',
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Center(
//                                 child: ElevatedButton(
//                               style: ButtonStyle(
//                                 foregroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.blue),
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CheckIfVisitor(
//                                             optionItemSelected.title,
//                                             numberPlateController.text,
//                                           )),
//                                 );
//                               },
//                               child: const Text(
//                                 'Confirm Vehicle Number',
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             )),
//                           ])
//                     : Container()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
