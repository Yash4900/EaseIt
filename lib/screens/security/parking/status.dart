import 'package:flutter/material.dart';
import 'parking_status.dart';

class CarDetail {
  String owner;
  String phoneNum;
  String flatNo;
  String vehicleNo;
  String model;
  String parkedAt;
  DateTime inTime;
  CarDetail(this.owner, this.phoneNum, this.flatNo, this.vehicleNo, this.model,
      this.parkedAt, this.inTime);
}

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<CarDetail> carDetails = [
    CarDetail("Yash Satra", "8879317366", "B-101", "MH01AE1231",
        "Vitara Brezza", "A-103", DateTime.now()),
    CarDetail("Peter Fernandes", "8574357366", "C-101", "MH01AE5434",
        "Honda City", "B-103", DateTime.now())
  ];

  Color getColor(String status) {
    if (status == "PENDING") return Color(0xff095aba);
    if (status == "APPROVED") return Color(0xff107154);
    return Color(0xffbb121a);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: carDetails.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 3.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParkingStatus(
                            carDetails[index].owner,
                            carDetails[index].phoneNum,
                            carDetails[index].flatNo,
                            carDetails[index].vehicleNo,
                            carDetails[index].model,
                            carDetails[index].parkedAt,
                            carDetails[index].inTime)));
              },
              title: Text(
                carDetails[index].vehicleNo,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carDetails[index].owner,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                        fontSize: 15),
                  ),
                  Text(
                    carDetails[index].model,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                        fontSize: 15),
                  ),
                  Text(
                    carDetails[index].inTime.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                        fontSize: 15),
                  )
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                    color: Color(0xff037DD6).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  carDetails[index].parkedAt,
                  style: TextStyle(
                      color: Color(0xff037DD6),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            ),
          );
        });
  }
}
