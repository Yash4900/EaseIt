import 'package:ease_it/screens/resident/resident.dart';
import 'package:ease_it/screens/resident/residentHome.dart';
import 'package:ease_it/screens/security/approval/custom_dialog.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/rendering.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/size_config.dart';
import 'package:ease_it/utility/vehicleCardConstants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class MyVehicle extends StatefulWidget {
  const MyVehicle({Key key}) : super(key: key);

  @override
  _MyVehicleState createState() => _MyVehicleState();
}

class _MyVehicleState extends State<MyVehicle> {
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  List<Map<String, String>> dropDownItems = [
    {"name": "Car", "imageLink": "assets/taxi.png"},
    {"name": "Bike", "imageLink": "assets/bycicle.png"},
    {"name": "Truck", "imageLink": "assets/delivery.png"},
    {"name": "AutoRicksaw", "imageLink": "assets/rickshaw.png"},
  ];
  String dropDownValue = "Car";
  final db = FirebaseFirestore.instance;
  Globals g = Globals();
  String fn = "", wg = "";
  bool foundVehicle = false;
  var document;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.findVehicle();
      setState(() {});
    });
    findVehicle();
    // new Future.delayed(const Duration(seconds: 3));
    // status();
  }

  // void status(dynamic doc){
  //   vehicleNoController.text = doc["vehicleNo"];
  //   vehicleModelController.text = doc["model"];
  //   vehicleColorController.text = doc["color"];
  //   vehicleTypeController.text = doc["type"];
  //   fn = doc["flatNo"];
  //   wg = doc["wing"];
  // }

  Future<void> findVehicle() async {
    await db
        .collection('Vehicle_Info')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["flatNo"] == Globals().flatNo &&
            doc["wing"] == Globals().wing) {
          foundVehicle = true;
          document = doc;
          vehicleNoController.text = doc["vehicleNo"];
          vehicleModelController.text = doc["model"];
          vehicleColorController.text = doc["color"];
          vehicleTypeController.text = doc["type"];
          fn = doc["flatNo"];
          wg = doc["wing"];
        }
      });
    });
    // status(document);
    print(wg + fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            document != null
                ?
                // Container(child: Text("h"),):
                CardDetailPage(
                    vehicleNo: vehicleNoController.text,
                    wing: g.wing,
                    flatNo: g.flatNo,
                    model: vehicleModelController.text,
                    color: vehicleColorController.text,
                    type: vehicleTypeController.text,
                  )
                : Material(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Center(
                              child: Image(
                            image: AssetImage('assets/book.png'),
                            width: MediaQuery.of(context).size.width * 5 / 10,
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                                "Hello ${g.fname}, enter below details to register your vehicle !",
                                style: GoogleFonts.montserrat(
                                    textStyle: Helper().mediumStyle)),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image(
                                  image: AssetImage('assets/license-plate.png'),
                                  width: 50,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  controller: vehicleNoController,
                                  decoration: const InputDecoration(
                                    labelText: 'Vehicle No',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Vehicle Type is ',
                                  style: GoogleFonts.montserrat(
                                      textStyle: Helper().mediumStyle)),
                              SizedBox(width: 20),
                              DropdownButton(
                                value: dropDownValue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: dropDownItems.map((items) {
                                  return DropdownMenuItem(
                                    value: items["name"],
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image(
                                          image: AssetImage(items["imageLink"]),
                                          width: 30,
                                        ),
                                        // SizedBox(),
                                        Text(
                                          items["name"],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => {
                                        dropDownValue = value,
                                        vehicleTypeController.text = value
                                      });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: vehicleModelController,
                            decoration: InputDecoration(
                              labelText: 'Model',
                              labelStyle: Helper().mediumStyle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: vehicleColorController,
                            decoration: const InputDecoration(
                              labelText: 'Color',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                onPressed: () {
                                  uploadVehicleData(
                                      vehicleNoController.text,
                                      vehicleModelController.text,
                                      vehicleColorController.text,
                                      vehicleTypeController.text);
                                },
                                child: Image(
                                  image: AssetImage('assets/verify.png'),
                                  width: 30,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  final vehicleLog = FirebaseFirestore.instance.collection('Vehicle_Info');
  Future<void> uploadVehicleData(
      String vehicleNo, String model, String color, String type) {
    Navigator.pop(context);
    showMessageDialog(context, "Vehicle Successfully Registered",
        "Kindly contact the security guard for updation of vehicle details");
    return vehicleLog.add({
      "vehicleNo": vehicleNo,
      "model": model,
      "color": color,
      "type": type,
      "flatNo": g.flatNo,
      "wing": g.wing
    });
  }
}

class CardDetailPage extends StatefulWidget {
  final String vehicleNo, type, model, color, wing, flatNo;
  const CardDetailPage({
    Key key,
    this.vehicleNo,
    this.type,
    this.model,
    this.color,
    this.wing,
    this.flatNo,
  }) : super(key: key);

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  String img = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.findPicture();
      setState(() {});
    });
    findPicture();
  }

  Future<void> findPicture() async {
    if (widget.type == "Car")
      img = "assets/taxi.png";
    else if (widget.type == "Bike")
      img = "assets/bycicle.png";
    else if (widget.type == "Truck")
      img = "assets/delivery.jpg";
    else if (widget.type == "Auto-Rickshaw") img = "assets/ricksaw.jpg";
  }

  List<Map<String, String>> visitorsLog = [
    {
      "name": "Maruti Suzuki",
      "type": "Car",
      "vehicleNumber": "MH12AE2323",
      "imageLink": "assets/taxi.png",
    },
    {
      "name": "Acitva",
      "type": "Bike",
      "vehicleNumber": "MH12RE2398",
      "imageLink": "assets/bycicle.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
                child: Image(
              image: AssetImage('assets/book.png'),
              width: MediaQuery.of(context).size.width * 5 / 10,
            )),
            SizedBox(
              height: 10,
            ),
            Column(
              children: visitorsLog
                  .map(
                    (e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(e["imageLink"]),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e["name"],
                                    style: GoogleFonts.montserrat(
                                      textStyle: Helper().mediumStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(e["type"],
                                      style: GoogleFonts.montserrat(
                                          textStyle: Helper().normalStyle)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e["vehicleNumber"],
                                        style: GoogleFonts.montserrat(
                                            textStyle: Helper().headingStyle),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
