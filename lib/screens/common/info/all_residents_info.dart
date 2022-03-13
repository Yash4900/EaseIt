import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ease_it/utility/flat_data.dart';

class ResidentInfoPage extends StatefulWidget {
  const ResidentInfoPage({Key key}) : super(key: key);

  @override
  _ResidentInfoPageState createState() => _ResidentInfoPageState();
}

class _ResidentInfoPageState extends State<ResidentInfoPage> {
  @override
  Widget build(BuildContext context) {
    Globals g = Globals();
    FlatData f = FlatData(hierarchy: g.hierarchy, structure: g.structure);
    f.findingCombinations();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Residents",
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
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ButtonsTabBar(
                  radius: 50,
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(
                      color: Color(0xff707070), fontWeight: FontWeight.bold),
                  backgroundColor: const Color(0xff59cd90),
                  unselectedBackgroundColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  //buttonMargin: EdgeInsets.symmetric(horizontal: 10),
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.apartment),
                      text: "A Wing",
                    ),
                    Tab(
                      icon: Icon(Icons.apartment),
                      text: "B Wing",
                    ),
                    Tab(
                      icon: Icon(Icons.apartment),
                      text: "C Wing",
                    ),
                    Tab(
                      icon: Icon(Icons.apartment),
                      text: "D Wing",
                    ),
                    Tab(
                      icon: Icon(Icons.apartment),
                      text: "E Wing",
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: Color(0xffc7c3c3),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TabBarView(
                    children: <Widget>[
                      ListView(
                        children: const <Widget>[
                          Text(
                            "Flat 001",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Tarak Mehta",
                            societyDesignation: "Member",
                            homeDesignation: "Head of the Family",
                            email: "tm@gs.com",
                          ),
                          UserCard(
                            userName: "Anjali Mehta",
                            societyDesignation: "Resident",
                            homeDesignation: "Housewife, Nutritionist",
                            email: "am@gs.com",
                          ),
                          Text(
                            "Flat 101, 102",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Jethalal Gada",
                            societyDesignation: "Member",
                            homeDesignation: "Head of the Family",
                            email: "jethalal.gada@ge.com",
                          ),
                          UserCard(
                            userName: "Champaklal Gada",
                            societyDesignation: "Resident",
                            homeDesignation: "Retired",
                            email: "cjg@gs.com",
                          ),
                          UserCard(
                            userName: "Daya Gada",
                            societyDesignation: "Resident",
                            homeDesignation: "Housewife",
                            email: "djg@gs.com",
                          ),
                          UserCard(
                            userName: "Tapu Gada",
                            societyDesignation: "Resident",
                            homeDesignation: "Child",
                            email: "tjg@gs.com",
                          ),
                        ],
                      ),
                      ListView(
                        children: const <Widget>[
                          Text(
                            "Flat 201",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Matkaking Mohanlal",
                            societyDesignation: "Member",
                            homeDesignation: "Head of the Family",
                            email: "mm@gs.com",
                          ),
                        ],
                      ),
                      ListView(
                        children: const <Widget>[
                          Text(
                            "Flat 001",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Hansraj Hathi",
                            societyDesignation: "Member",
                            homeDesignation: "Head of the Family",
                            email: "hh@gs.com",
                          ),
                          UserCard(
                            userName: "Komal Hathi",
                            societyDesignation: "Resident",
                            homeDesignation: "Housewife",
                            email: "kh@gs.com",
                          ),
                          UserCard(
                            userName: "Goli Hathi",
                            societyDesignation: "Resident",
                            homeDesignation: "Child",
                            email: "gh@gs.com",
                          ),
                          Text(
                            "Flat 101",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Aatmaram Bhide",
                            societyDesignation: "Secretary",
                            homeDesignation: "Head of the Family",
                            email: "aatubhide.ems@gs.com",
                          ),
                          UserCard(
                            userName: "Madhavi Bhide",
                            societyDesignation: "Resident",
                            homeDesignation: "Housewife, Entrepreneur",
                            email: "mab@gs.com",
                          ),
                          UserCard(
                            userName: "Sonu Bhide",
                            societyDesignation: "Resident",
                            homeDesignation: "Child",
                            email: "sab@gs.com",
                          ),
                          Text(
                            "Flat 102",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Roshan Sodhi",
                            societyDesignation: "Member",
                            homeDesignation: "Head of the Family",
                            email: "ras@gs.com",
                          ),
                          UserCard(
                            userName: "Roshan Sodhi",
                            societyDesignation: "Resident",
                            homeDesignation: "Housewife",
                            email: "rrs@gs.com",
                          ),
                          UserCard(
                            userName: "Gurucharan Sodhi",
                            societyDesignation: "Resident",
                            homeDesignation: "Child",
                            email: "grs@gs.com",
                          ),
                        ],
                      ),
                      ListView(
                        children: const <Widget>[
                          Text(
                            "Flat 101",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Krishnan Iyer",
                            societyDesignation: "Treasurer",
                            homeDesignation: "Head of the Family",
                            email: "ksi@gs.com",
                          ),
                          UserCard(
                            userName: "Babita Iyer",
                            societyDesignation: "Resident",
                            homeDesignation: "Housewife",
                            email: "bki@gs.com",
                          ),
                          Text(
                            "Flat 201",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Popatlal",
                            societyDesignation: "Committee Member",
                            homeDesignation: "Head of the Family",
                            email: "ppp@gs.com",
                          ),
                        ],
                      ),
                      ListView(
                        children: const <Widget>[
                          Text(
                            "Flat 001",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff707070),
                              fontSize: 17,
                            ),
                          ),
                          Divider(
                            color: Color(0xffc7c3c3),
                          ),
                          UserCard(
                            userName: "Taiyaab Tailor",
                            societyDesignation: "Member",
                            homeDesignation: "Head of the Family",
                            email: "tt@gs.com",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard(
      {Key key,
      @required this.userName,
      @required this.societyDesignation,
      @required this.homeDesignation,
      @required this.email})
      : super(key: key);

  final String userName, societyDesignation, homeDesignation, email;

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
                homeDesignation,
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

class CustomTabViewPage extends StatefulWidget {
  List<String> optionUntilNow;
  CustomTabViewPage({Key key, @required this.optionUntilNow}) : super(key: key);

  @override
  State<CustomTabViewPage> createState() => _CustomTabViewPageState();
}

class _CustomTabViewPageState extends State<CustomTabViewPage> {
  List<String> nextOptions;
  Globals g = Globals();

  @override
  void initState() {
    dynamic temp = g.structure is List
        ? [...g.structure]
        : <String, dynamic>{...g.structure};
    dynamic tempIterationMap = temp;
    for (int i = 0; i < widget.optionUntilNow.length; i++) {
      if (tempIterationMap is Map) {
        nextOptions = tempIterationMap.keys.toList();
        tempIterationMap = tempIterationMap[widget.optionUntilNow[i]];
      } else if (tempIterationMap is List) {
        nextOptions = tempIterationMap.toList();
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.optionUntilNow.length == g.hierarchy.length) {
      return SizedBox();
    } else {
      return SizedBox();
    }
  }
}
