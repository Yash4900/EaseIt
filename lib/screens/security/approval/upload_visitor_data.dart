import 'package:ease_it/screens/security/security.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UploadToDatabase extends StatelessWidget {
  String name, flatNo, vehicleNo, phoneNo;
  UploadToDatabase(this.name, this.flatNo, this.vehicleNo, this.phoneNo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[        
        Text("Name: $name",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text("Flat Number: $flatNo",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text("Number Plate: $vehicleNo",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text("Phone Number: $phoneNo",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 30,
        ),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Security()),
              );
            },
            child: const Text('Home Page',                      
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),  
            ),
          ),
        ),
      ]           
    ),),
    ),),
    );
  }
}