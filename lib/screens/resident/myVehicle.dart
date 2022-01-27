import 'package:ease_it/screens/resident/resident.dart';
import 'package:ease_it/screens/resident/residentHome.dart';
import 'package:ease_it/screens/security/approval/custom_dialog.dart';
import 'package:flutter/rendering.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/size_config.dart';
import 'package:ease_it/utility/vehicleCardConstants.dart ';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

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
  List<String> dropDownItems = [
    "Car",
    "Bike",
    "Truck",
    "Tempo",
    "Auto-Rickshaw",
    "Taxi"
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        Center(
                          child: Text(
                            "Hello ${g.fname}, enter below details to register your vehicle !",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                // backgroundColor: Colors.blue,
                                color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: vehicleNoController,
                          decoration: const InputDecoration(
                            labelText: 'Vehicle No',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Vehicle Type is ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 20),
                            DropdownButton(
                              value: dropDownValue,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items: dropDownItems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String value) {
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
                          decoration: const InputDecoration(
                            labelText: 'Model',
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
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              uploadVehicleData(
                                  vehicleNoController.text,
                                  vehicleModelController.text,
                                  vehicleColorController.text,
                                  vehicleTypeController.text);
                            },
                            child: const Text(
                              'Register Vehicle',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  final vehicleLog = FirebaseFirestore.instance.collection('Vehicle_Info');
  Future<void> uploadVehicleData(
      String vehicleNo, String model, String color, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Vehicle Registered Successfully",
        description: "$vehicleNo registered at ${g.wing}-${g.flatNo}",
        buttonText: "Home Page",
        homePage: Resident(),
      ),
    );
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
      img = "assets/car.jpeg";
    else if (widget.type == "Bike")
      img = "assets/bike.png";
    else if (widget.type == "Truck")
      img = "assets/truck.jpg";
    else if (widget.type == "Tempo")
      img = "assets/tempo.jpg";
    else if (widget.type == "Auto-Rickshaw")
      img = "assets/auto.jpg";
    else
      img = "assets/taxi.jpg";
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Material(
      type: MaterialType.transparency,
      child: new Container(
        height: height * 0.8,
        width: width * 0.8,
        child: Column(
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
                color: Color(0xFF363f93),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    left: 0,
                    child: Container(
                      height: 100,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 115,
                    left: 20,
                    child: Text(
                      "Your Vehicle",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF363f93),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height * 0.05),
            Container(
                height: 230,
                child: Stack(
                  children: [
                    Positioned(
                        top: 35,
                        left: 20,
                        child: Material(
                          child: Container(
                            height: 180,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0.0),
                              // new BoxShadow(
                              //   color: Colors.grey.withOpacity(0.3),
                              //   offset: new Offset(-10, 10),
                              //   blurRadius: 20,
                              //   spreadRadius: 4),
                              // ),
                            ),
                          ),
                        )),
                    Positioned(
                      top: 30,
                      left: 30,
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.fill, image: AssetImage(img))),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 200,
                      child: Container(
                        height: 150,
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vehicleNo,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF363f93),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.type,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Flexible(
                              child: Text(
                                widget.color,
                                // overflow: TextOverflow,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF363f93),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                widget.model,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF363f93),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.25,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF363f93))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Resident()),
                      );
                    },
                    child: const Text('Home Page',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
