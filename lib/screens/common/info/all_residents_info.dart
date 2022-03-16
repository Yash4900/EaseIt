import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/loading.dart';
import 'dart:math';
//import 'package:flutter_beautiful_popup/main.dart';

class ResidentInfoPage extends StatefulWidget {
  const ResidentInfoPage({Key key}) : super(key: key);

  @override
  _ResidentInfoPageState createState() => _ResidentInfoPageState();
}

class _ResidentInfoPageState extends State<ResidentInfoPage> {
  @override
  Widget build(BuildContext context) {
    Globals g = Globals();
    FlatDataOperations f =
        FlatDataOperations(hierarchy: g.hierarchy, structure: g.structure);
    f.findingCombinations();
    f.getInitialCombination();
    // Map<String, String> flatNumber = {
    //   "Building": "C",
    //   "Wing": "A",
    //   "Flat": "303",
    //   "Floor": "3"
    // };
    //dynamic snapshot =
    // Database().getUserDetailsBasedOnFlatNumber(g.society, flatNumber);
    // if (snapshot.hasData)
    //   print(snapshot);
    // else
    //   print("f");
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
        child: Padding(
          child: CustomTabViewPage(
            optionUntilNow: f.getInitialCombination(),
            index: 0,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        // child: DefaultTabController(
        //   length: 5,
        //   child: Column(
        //     children: <Widget>[
        //       Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //         child: ButtonsTabBar(
        //           radius: 50,
        //           labelStyle: const TextStyle(
        //               color: Colors.white, fontWeight: FontWeight.bold),
        //           unselectedLabelStyle: const TextStyle(
        //               color: Color(0xff707070), fontWeight: FontWeight.bold),
        //           backgroundColor: const Color(0xff59cd90),
        //           unselectedBackgroundColor: Colors.white,
        //           contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //           //buttonMargin: EdgeInsets.symmetric(horizontal: 10),
        //           tabs: const <Widget>[
        //             Tab(
        //               icon: Icon(Icons.apartment),
        //               text: "A Wing",
        //             ),
        //             Tab(
        //               icon: Icon(Icons.apartment),
        //               text: "B Wing",
        //             ),
        //             Tab(
        //               icon: Icon(Icons.apartment),
        //               text: "C Wing",
        //             ),
        //             Tab(
        //               icon: Icon(Icons.apartment),
        //               text: "D Wing",
        //             ),
        //             Tab(
        //               icon: Icon(Icons.apartment),
        //               text: "E Wing",
        //             ),
        //           ],
        //         ),
        //       ),
        //       const Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 10),
        //         child: Divider(
        //           color: Color(0xffc7c3c3),
        //         ),
        //       ),
        //       Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 10),
        //           child: TabBarView(
        //             children: <Widget>[
        //               ListView(
        //                 children: const <Widget>[
        //                   Text(
        //                     "Flat 001",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Tarak Mehta",
        //                     societyDesignation: "Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "tm@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Anjali Mehta",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Housewife, Nutritionist",
        //                     email: "am@gs.com",
        //                   ),
        //                   Text(
        //                     "Flat 101, 102",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Jethalal Gada",
        //                     societyDesignation: "Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "jethalal.gada@ge.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Champaklal Gada",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Retired",
        //                     email: "cjg@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Daya Gada",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Housewife",
        //                     email: "djg@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Tapu Gada",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Child",
        //                     email: "tjg@gs.com",
        //                   ),
        //                 ],
        //               ),
        //               ListView(
        //                 children: const <Widget>[
        //                   Text(
        //                     "Flat 201",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Matkaking Mohanlal",
        //                     societyDesignation: "Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "mm@gs.com",
        //                   ),
        //                 ],
        //               ),
        //               ListView(
        //                 children: const <Widget>[
        //                   Text(
        //                     "Flat 001",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Hansraj Hathi",
        //                     societyDesignation: "Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "hh@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Komal Hathi",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Housewife",
        //                     email: "kh@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Goli Hathi",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Child",
        //                     email: "gh@gs.com",
        //                   ),
        //                   Text(
        //                     "Flat 101",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Aatmaram Bhide",
        //                     societyDesignation: "Secretary",
        //                     homeDesignation: "Head of the Family",
        //                     email: "aatubhide.ems@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Madhavi Bhide",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Housewife, Entrepreneur",
        //                     email: "mab@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Sonu Bhide",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Child",
        //                     email: "sab@gs.com",
        //                   ),
        //                   Text(
        //                     "Flat 102",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Roshan Sodhi",
        //                     societyDesignation: "Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "ras@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Roshan Sodhi",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Housewife",
        //                     email: "rrs@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Gurucharan Sodhi",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Child",
        //                     email: "grs@gs.com",
        //                   ),
        //                 ],
        //               ),
        //               ListView(
        //                 children: const <Widget>[
        //                   Text(
        //                     "Flat 101",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Krishnan Iyer",
        //                     societyDesignation: "Treasurer",
        //                     homeDesignation: "Head of the Family",
        //                     email: "ksi@gs.com",
        //                   ),
        //                   UserCard(
        //                     userName: "Babita Iyer",
        //                     societyDesignation: "Resident",
        //                     homeDesignation: "Housewife",
        //                     email: "bki@gs.com",
        //                   ),
        //                   Text(
        //                     "Flat 201",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Popatlal",
        //                     societyDesignation: "Committee Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "ppp@gs.com",
        //                   ),
        //                 ],
        //               ),
        //               ListView(
        //                 children: const <Widget>[
        //                   Text(
        //                     "Flat 001",
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       color: Color(0xff707070),
        //                       fontSize: 17,
        //                     ),
        //                   ),
        //                   Divider(
        //                     color: Color(0xffc7c3c3),
        //                   ),
        //                   UserCard(
        //                     userName: "Taiyaab Tailor",
        //                     societyDesignation: "Member",
        //                     homeDesignation: "Head of the Family",
        //                     email: "tt@gs.com",
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
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
  int index;
  CustomTabViewPage(
      {Key key, @required this.optionUntilNow, @required this.index})
      : super(key: key);

  @override
  State<CustomTabViewPage> createState() => _CustomTabViewPageState();
}

class _CustomTabViewPageState extends State<CustomTabViewPage> {
  List<String> nextOptions;
  bool isLoading = false;
  int level;
  Globals g = Globals();
  //List<Widget> userCardWidget;
  final Widget dividerWidget = Divider(
    color: Color(0xffc7c3c3),
  );
  Map<int, String> respectiveEndingTag = {
    1: "st",
    2: "nd",
    3: "rd",
    4: "th",
    5: "th",
    6: "th",
    7: "th",
    8: "th",
    9: "th",
    0: "th",
  };

  @override
  void initState() {
    super.initState();
    print("------------------------ InitState S ------------------------");
    level = widget.index;
    print(
        "Widget index: ${widget.index}, Widget optionUntilNow: ${widget.optionUntilNow}");
    dynamic temp = g.structure is List
        ? [...g.structure]
        : <String, dynamic>{...g.structure};
    dynamic tempIterationMap = temp;
    //print("TempIterationMap: $tempIterationMap");
    // if (level == 0 && widget.optionUntilNow.length == 0) {
    //   print("In if");
    //   if (tempIterationMap is Map) {
    //     //print("Wtf");
    //     nextOptions = tempIterationMap.keys.toList();
    //   } else if (tempIterationMap is List) {
    //     nextOptions = tempIterationMap.toList();
    //   } else {}
    // } else {
    //print("In else");
    //tempIterationMap = tempIterationMap[widget.optionUntilNow[0]];
    //print("tempIterationMap $tempIterationMap");
    for (int i = 0; i < level + 1; i++) {
      //print("Iteration i: $i");
      //print("TempIterationValue: $tempIterationMap");
      if (tempIterationMap is Map) {
        nextOptions = List<String>.from(tempIterationMap.keys.toList());
      } else if (tempIterationMap is List) {
        nextOptions = List<String>.from(tempIterationMap.toList());
      } else {}
      tempIterationMap = tempIterationMap[widget.optionUntilNow[i]];
      print("Nextoptions value: $nextOptions");
    }
    //}

    print("options: $nextOptions");
    if (widget.optionUntilNow.length > level) {
      print("In 2 if");
      widget.optionUntilNow.removeAt(level);
      widget.optionUntilNow.insert(level, nextOptions[0]);
    } else {
      print("In 2 else");
      widget.optionUntilNow.add(nextOptions[0]);
    }
    print("FINNNNNNNNNNNNNNNNNNNNNNNAL Value ${nextOptions[0]}");
    //print("Next option is $nextOptions");
    //print("Length of optionUntilNow: ${widget.optionUntilNow.length}");
    //print("Level: $level");

    print("Widget optionsUnitlNow in initState(): ${widget.optionUntilNow}");
    print("------------------------ InitState E ------------------------");
  }

  String updatedString(value) {
    //print("updateString");
    if (int.tryParse(value) != null) {
      int Num = int.parse(value);
      Num = Num % 10;
      String expectedEnding = respectiveEndingTag[Num];
      //print("Value $value , expectedEnding: $expectedEnding");
      value = value + expectedEnding;
      //print("Updated String");
      return value;
    }
    //print("UpdatedString");
    return value;
  }

  List<Widget> listOfTabWidgets(List<String> nextOptions, int level) {
    List<Widget> tabWidget = [];
    // print("!!!!!!!!!!!!!!!!!!!!!! ListOfTabWidgets S !!!!!!!!!!!!!!!!!!!!!!");
    // print("Next options received in listOfTabWidgets is: $nextOptions");
    //print("List of Tab Widgets");
    print("Level is: $level");
    for (int i = 0; i < nextOptions.length; i++) {
      Widget tempTab = Tab(
        icon: Icon(Icons.apartment),
        text: updatedString(nextOptions[i]) + " " + g.hierarchy[level],
      );
      tabWidget.add(tempTab);
    }
    //print("List of Tab widgets");
    // print("!!!!!!!!!!!!!!!!!!!!!! ListOfTabWidgets S !!!!!!!!!!!!!!!!!!!!!!");
    return tabWidget;
  }

  List<Widget> listOfCustomTabBarView(List<String> nextOptions) {
    //print("List of Custom Tab Bar View");
    // print(
    //     "######################### ListOfCustomTabBarView S #########################");
    print("In custom tab bar view $level");
    List<Widget> tabWidget = [];
    for (int i = 0; i < nextOptions.length; i++) {
      Widget tempTab = CustomTabViewPage(
        optionUntilNow: widget.optionUntilNow,
        index: level + 1,
      );
      tabWidget.add(tempTab);
    }
    // print("Length of tabs created: ${tabWidget.length}");
    //print("List of Custom Tab Bar View");
    // print(
    //     "######################### ListOfCustomTabBarView E #########################");
    return tabWidget;
  }

  Future<List<Widget>> listOfUserCards(
      List<String> nextOptions, int index) async {
    //setState(() => isLoading = true);
    //List<Widget> userCardWidget;
    List<Widget> userCardWidget = [];
    print("In List of user cards");
    Map<String, String> temp = {};
    dynamic tempNew = g.structure is List
        ? [...g.structure]
        : <String, dynamic>{...g.structure};
    dynamic tempIterationMap = tempNew;
    print("Length of optionuntilnow: ${widget.optionUntilNow.length}");
    for (int i = 0; i <= widget.optionUntilNow.length; i++) {
      //print("Temp iteration Map: $tempIterationMap\n");
      if (tempIterationMap is Map) {
        nextOptions = tempIterationMap.keys.toList();
        tempIterationMap = tempIterationMap[widget.optionUntilNow[i]];
      } else if (tempIterationMap is List) {
        nextOptions = List<String>.from(tempIterationMap.toList());
      } else {
        print("In else");
      }
    }
    print("Intermediate next Options: $nextOptions");
    for (int i = 0; i < g.hierarchy.length - 1; i++) {
      temp[g.hierarchy[i]] = widget.optionUntilNow[i];
    }
    print("Intermediate Temp: $temp");
    for (int i = 0; i < nextOptions.length; i++) {
      List<Widget> tempWidgets = [];
      temp[g.hierarchy[g.hierarchy.length - 1]] = nextOptions[i];
      print("Temp is: $temp");
      QuerySnapshot usersBelongingToSameFlat =
          await Database().getUserDetailsBasedOnFlatNumber(g.society, temp);
      List<Widget> tempMoreWidgets =
          generateListViewWidget(usersBelongingToSameFlat, temp);
      for (Widget k in tempMoreWidgets) {
        tempWidgets.add(k);
      }
      userCardWidget.add(
        ListView(
          children: tempWidgets,
        ),
      );
    }
    //print(userCardWidget);
    print("List of user cards ended");
    //setState(() => isLoading = false);
    //setState(() {});
    //widget.index = widget.index + 1;
    return userCardWidget;
  }

  List<Widget> generateSizedBoxes(List<String> nextOptions, int index) {
    //listOfUserCards(nextOptions, index);
    print("^^^^^^^^^^^^^^ generateSizedBoxes S ^^^^^^^^^^^^^^");
    List<Widget> listOfSizedBox = [];
    for (int i = 0; i < nextOptions.length; i++) {
      Widget temp = SizedBox(
        child: Text("It works bc"),
      );
      listOfSizedBox.add(temp);
    }
    print("^^^^^^^^^^^^^^ generateSizedBoxes S ^^^^^^^^^^^^^^");
    return listOfSizedBox;
  }

  List<Widget> generateListViewWidget(
      QuerySnapshot snapshots, Map<String, String> temp) {
    List<Widget> childrenWidgets = [];
    String textValue = g.hierarchy[g.hierarchy.length - 1] +
        " " +
        temp[g.hierarchy[g.hierarchy.length - 1]];
    childrenWidgets.add(
      Text(
        textValue,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff707070),
          fontSize: 17,
        ),
      ),
    );
    childrenWidgets.add(dividerWidget);
    if (snapshots.docs.length == 0) {
      childrenWidgets.add(
        Center(
          child: Row(
            children: [
              Icon(
                Icons.search_outlined,
                size: 25,
                color: Color(0xffa0a0a0),
              ),
              Text(
                "No residents found for this flat",
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
      for (int i = 0; i < snapshots.docs.length; i++) {
        childrenWidgets.add(
          UserCard(
            userName:
                snapshots.docs[i]["fname"] + " " + snapshots.docs[i]["lname"],
            societyDesignation: snapshots.docs[i]["role"],
            homeDesignation: "Resident",
            email: snapshots.docs[i]["email"],
          ),
        );
      }
    }
    return childrenWidgets;
  }

  @override
  Widget build(BuildContext context) {
    //print("Next options: $nextOptions");
    if (level == g.hierarchy.length - 2) {
      //listOfUserCards(nextOptions, widget.index + 1);
      print("*****************************");
      print("In if index: ${widget.index}");
      print("In if level: $level");
      return DefaultTabController(
        length: nextOptions.length,
        child: Column(
          children: [
            ButtonsTabBar(
              onTap: (index) {
                print("In onTap");
                print("Level: $level");
                print(nextOptions[index]);
                widget.optionUntilNow.removeAt(level);
                widget.optionUntilNow.insert(level, nextOptions[index]);
                setState(() {});
                print("Option until now ${widget.optionUntilNow}");
              },
              radius: 50,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                  color: Color(0xff707070), fontWeight: FontWeight.bold),
              backgroundColor: const Color(0xff59cd90),
              unselectedBackgroundColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              //buttonMargin: EdgeInsets.symmetric(horizontal: 10),
              tabs: listOfTabWidgets(nextOptions, level),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: dividerWidget,
            ),
            Expanded(
              child: FutureBuilder(
                future: listOfUserCards(nextOptions, widget.index),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TabBarView(
                      children: snapshot.data,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "Could not load Data",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else if (level < g.hierarchy.length - 2) {
      print("++++++++++++++++++++++++++++");
      print("In else if ${widget.index}");
      print("In else if level: $level");
      return DefaultTabController(
        length: nextOptions.length,
        child: Column(
          children: [
            ButtonsTabBar(
              onTap: (index) {
                print("In onTap");
                print("Level: $level");
                print(nextOptions[index]);
                widget.optionUntilNow.removeAt(level);
                widget.optionUntilNow.insert(level, nextOptions[index]);
                setState(() {});
                print("Option until now ${widget.optionUntilNow}");
              },
              radius: 50,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                  color: Color(0xff707070), fontWeight: FontWeight.bold),
              backgroundColor: const Color(0xff59cd90),
              unselectedBackgroundColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              //buttonMargin: EdgeInsets.symmetric(horizontal: 10),
              tabs: listOfTabWidgets(nextOptions, level),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: dividerWidget,
            ),
            Expanded(
              child: TabBarView(
                children: listOfCustomTabBarView(nextOptions),
              ),
            ),
          ],
        ),
      );
    } else {
      print("_____________________________");
      return SizedBox();
    }
  }
}
