import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/utility/custom_tags.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:url_launcher/url_launcher.dart';

class SecurityGuardInfo extends StatefulWidget {
  const SecurityGuardInfo({Key key}) : super(key: key);

  @override
  State<SecurityGuardInfo> createState() => _SecurityGuardInfoState();
}

class _SecurityGuardInfoState extends State<SecurityGuardInfo> {
  //Future<Widget> _securityGuardInfoWidget;
  Globals g = Globals();
  bool loading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _securityGuardInfoWidget = getListOfSecurityGuards();
  // }

  Widget getListOfSecurityGuards(QuerySnapshot listOfSG) {
    Widget toDisplay;
    // QuerySnapshot listOfSG =
    //     await Database().getSecurityGuardsOfSociety(g.society);
    //print(listOfSG);
    //print(listOfSG.docs[0].data());
    if (listOfSG.docs.length == 0) {
      toDisplay = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search_outlined,
                size: 25,
                color: Color(0xffa0a0a0),
              ),
              Text(
                "No security guards found for society",
                style: TextStyle(
                  color: Color(0xffa0a0a0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      List<Widget> temp = [];
      for (int i = 0; i < listOfSG.docs.length; i++) {
        print(listOfSG.docs[i]["email"]);
        temp.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SecurityGuardCard(
              email: listOfSG.docs[i]["email"],
              userName:
                  listOfSG.docs[i]["fname"] + " " + listOfSG.docs[i]["lname"],
              phoneNumber: "+91 - " + listOfSG.docs[i]["phoneNum"],
              societyDesignation: listOfSG.docs[i]["role"],
              imageUrl: listOfSG.docs[i]["imageUrl"],
            ),
          ),
        );
      }
      print(temp);
      print("toDispla else y");
      toDisplay = ListView(
        children: temp,
      );
      print("Complete");
    }
    print("In function: $toDisplay");
    return toDisplay;
  }

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
      body: loading
          ? Loading()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: StreamBuilder(
                  stream: Database().getSecurityGuardsOfSociety(g.society),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      Widget tempWidget =
                          getListOfSecurityGuards(snapshot.data);
                      return tempWidget;
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Loading();
                    } else {
                      print(snapshot.data);
                      return Text(
                        "Could not load data",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
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
      @required this.email,
      @required this.imageUrl})
      : super(key: key);

  final String userName, societyDesignation, phoneNumber, email, imageUrl;

  @override
  Widget build(BuildContext context) {
    print("Building user card");
    print("username: $userName");
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      margin: const EdgeInsets.all(10),
      //width: MediaQuery.of(context).size.width * 92.5 / 100,
      //height: MediaQuery.of(context).size.height * 12 / 100,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: imageUrl == ""
                ? Container(
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
                  )
                : Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Color(0xffd3d3d3),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                      ),
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
                ],
              ),
              const SizedBox(height: 10),
              CustomTag(
                text: "Security",
                backgroundColor: Colors.cyan[100],
                textColor: Colors.cyan,
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
          InkWell(
            splashColor: Color(0xffd0d0d0),
            child: GestureDetector(
                child: Icon(
                  Icons.phone,
                  size: 25,
                ),
                onTap: () async {
                  try {
                    await launch('tel:$phoneNumber');
                  } catch (e) {
                    print(e.toString());
                    showToast(context, "error", "Error",
                        "Oops! Something went wrong");
                  }
                }),
          ),
        ],
      ),
    );
  }
}
