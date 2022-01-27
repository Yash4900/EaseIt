import 'package:flutter/material.dart';

class SecurityGuardInfo extends StatelessWidget {
  const SecurityGuardInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Security Guards",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ListView(
            children: <Widget>[
              Text(
                "Guards",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff707070),
                  fontSize: 17,
                ),
              ),
              Divider(
                color: Color(0xffc7c3c3),
              ),
              SecurityGuardCard(
                userName: "Himmat Singh",
                societyDesignation: "Guard",
                phoneNumber: "+91-1234567890",
                email: "",
              ),
              SecurityGuardCard(
                userName: "Shewaar",
                societyDesignation: "Guard",
                phoneNumber: "+91-4321567890",
                email: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecurityGuardCard extends StatelessWidget {
  const SecurityGuardCard(
      {Key key,
      @required this.userName,
      @required this.societyDesignation,
      @required this.phoneNumber,
      @required this.email})
      : super(key: key);

  final String userName, societyDesignation, phoneNumber, email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 92.5 / 100,
      height: MediaQuery.of(context).size.height * 12 / 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(33)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0.2,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffd3d3d3),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.black,
                size: 35,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff707070),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    societyDesignation,
                    style: const TextStyle(
                      color: Color(0xff17a3e8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xffa0a0a0),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xffa0a0a0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
