import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/screens/common/profile/profile_form.dart';
import 'package:ease_it/screens/common/profile/support_feedback.dart';
import 'dart:io';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          "Your Profile",
          style: TextStyle(
            color: Color(0xff000000),
          ),
        ),
        leading: IconButton(
          color: const Color(0xff000000),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProfileCard(),
            SizedBox(height: 25),
            ButtonOptions(),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  ProfileCard({Key key}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Globals g = Globals();

  @override
  Widget build(BuildContext context) {
    // print(FlatDataOperations(hierarchy: g.hierarchy, structure: g.structure)
    //     .findingCombinations());
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: FutureBuilder(
        future: Database().getUserDetails(g.society, g.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "An Error Occured",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.redAccent,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            String fname = snapshot.data['fname'];
            String lname = snapshot.data['lname'];
            String phoneNum = snapshot.data['phoneNum'];
            String email = snapshot.data['email'];
            return Padding(
              padding: const EdgeInsets.only(
                top: 90,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    //Container for displaying data
                    //margin: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 72.5,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  fname + " " + lname,
                                  style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "+91-" + phoneNum,
                                  style: TextStyle(
                                    color: Color(
                                      0xffa0a0a0,
                                    ),
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffa0a0a0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                snapshot.data["status"] == "accepted" &&
                                        (snapshot.data["role"] == "Resident" ||
                                            snapshot.data["role"] ==
                                                "Secretary")
                                    ? Text(
                                        FlatDataOperations(
                                                hierarchy: g.hierarchy,
                                                flatNum:
                                                    Map<String, String>.from(
                                                        g.flat))
                                            .returnStringFormOfFlatMap(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xffa0a0a0),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 4),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 40,
                              color: Color(0xff707070),
                            ),
                            onTap: () async {
                              File _profilePicture = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileForm()),
                              );
                              setState(() {});
                            },
                            highlightColor: Colors.grey,
                            splashColor: Color(0xffd0d0d0),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(33),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    //height: MediaQuery.of(context).size.height * 25 / 100,
                    //width: MediaQuery.of(context).size.width * 92.5 / 100,
                  ),
                  Positioned(
                    //Container for Image
                    top: -45,
                    left: (MediaQuery.of(context).size.width / 2) -
                        ((MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width *
                                    92.5 /
                                    100)) /
                            2) -
                        50,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: g.imageUrl == ""
                              ? AssetImage("assets/default_profile_picture.png")
                              : NetworkImage(g.imageUrl),
                        ),
                        shape: BoxShape.circle,
                        color: const Color(0xfff3f3f3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 100,
                      width: 100,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Loading());
          }
        },
      ),
    );
  }
}

class ButtonOptions extends StatelessWidget {
  const ButtonOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        //height: MediaQuery.of(context).size.height * 20 / 100,
        //width: MediaQuery.of(context).size.width * 92.5 / 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(33),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            ButtonOption(
              onTapFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupportFeedback(),
                  ),
                );
              },
              iconData: Icons.feedback,
              iconText: "Support and Feedback",
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Color(0xffc7c3c3),
              ),
            ),
            ButtonOption(
              onTapFunction: () {
                Auth().logout();
                Navigator.pop(context);
              },
              iconData: Icons.logout,
              iconText: "Logout",
            )
          ],
        ),
      ),
    );
  }
}

class ButtonOption extends StatelessWidget {
  const ButtonOption(
      {Key key,
      @required this.iconData,
      @required this.iconText,
      @required this.onTapFunction})
      : super(key: key);

  final IconData iconData;
  final String iconText;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTapFunction,
          highlightColor: Colors.grey,
          splashColor: Color(0xffd0d0d0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                child: Icon(
                  iconData,
                  color: const Color(0xff707070),
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xfff3f3f3),
                ),
              ),
              Text(
                iconText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffa0a0a0),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffa0a0a0),
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
