import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:provider/provider.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/custom_dropdown_widget.dart';
import 'package:ease_it/utility/flat_data.dart';

class ResidentApproval extends StatefulWidget {
  ResidentApproval({Key key}) : super(key: key);

  @override
  State<ResidentApproval> createState() => _ResidentApprovalState();
}

class _ResidentApprovalState extends State<ResidentApproval> {
  Globals g = Globals();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot a = Provider.of<DocumentSnapshot>(context);
    return isLoading
        ? Loading()
        : a["status"] == "pending"
            ? Pending()
            : SizedBox();
  }
}

class Pending extends StatefulWidget {
  Pending({Key key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  String name;
  Globals g = Globals();

  @override
  void initState() {
    name = g.fname + ' ' + g.lname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: ListView(
          children: [
            Text(
              'Hello, ${g.fname}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.pending_actions,
                    color: Color(0xffa0a0a0),
                    size: 30,
                  ),
                  Text(
                    "Your residence joining request is pending, Please ask the secretary to accept your request",
                    style: TextStyle(
                      color: Color(0xffa0a0a0),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
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

class ReApproval extends StatefulWidget {
  const ReApproval({Key key}) : super(key: key);

  @override
  State<ReApproval> createState() => _ReApprovalState();
}

class _ReApprovalState extends State<ReApproval> {
  Globals g = Globals();
  String name;

  @override
  void initState() {
    name = g.fname + ' ' + g.lname;
    super.initState();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: [
            Text(
              'Hello, ${g.fname}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    color: Color(0xffa0a0a0),
                    size: 30,
                  ),
                  Text(
                    "Your residence joining request has been cancelled by secretary",
                    style: TextStyle(
                      color: Color(0xffa0a0a0),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ReApply();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                child: Text(
                  'ReApply',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReApply extends StatefulWidget {
  const ReApply({Key key}) : super(key: key);

  @override
  State<ReApply> createState() => _ReApplyState();
}

class _ReApplyState extends State<ReApply> {
  String selectedSociety;
  List<String> societies;
  String society;
  bool loading;
  String errorText = "";
  FlatData flatVar = FlatData();

  void _update() {
    setState(() {});
  }

  void getSocietyStructure(String societyValue) async {
    setState(() => loading = true);
    //print(List<String>.from(societyStructureWidget[societyStructureWidget["Hierarchy"][0]]));
    //Empty all previous data and set new data
    //print(
    //    "%%%%%%%%%%%%%%%%%%%%% getSocietyStructure is called %%%%%%%%%%%%%%%%%%%%%");
    //print("Set error text to null");
    errorText = "";
    //print("Clearing the Widget form that I have created");
    flatVar.clearFlatWidgetForm();
    //print("Clearing the flat values map");
    flatVar.clearFlatNum();
    //print("Clearing the flat value list");
    flatVar.clearFlatValue();
    //print("Setting current level");
    flatVar.setCurrentLevel = 1;
    //print("Setting widget flat form to empty");
    flatVar.setFlatWidgetForm = [];
    //print("Setting all update functions to null");
    flatVar.setAllUpdateFunctions = [];

    //get society info
    Map<dynamic, dynamic> tempSnapData =
        await Database().getSocietyInfo(societyValue);
    //print("The data: $tempSnapData");

    //set structure
    //print("Setting the structure to incoming data");
    flatVar.setStructure = Map<String, dynamic>.from(tempSnapData);
    //print("Setting the total levels of hierarchy");
    flatVar.setTotalLevels =
        tempSnapData["Hierarchy"].length; // set total levels
    //print("Flat value list to null");
    flatVar.setFlatValue =
        List<String>.filled(flatVar.totalLevels, null, growable: true);
    //print("Adding initial dropdown to the flatWidgetForm that is the list");
    flatVar.addInFlatWidgetForm(CustomDropDown(
      options: flatVar.getILevelInHierarchy(flatVar.currentLevel),
      typeText: flatVar.getTypeText(flatVar.currentLevel),
      flatVariable: flatVar,
      update: _update,
    ));
    //print(
    //    "%%%%%%%%%%%%%%%%%%%%% getSocietyStructure is called %%%%%%%%%%%%%%%%%%%%%");
    //print(societyStructureWidget);
    setState(() => loading = false);
  }

  getSocietyList() async {
    societies = await Database().getAllSocieties();
    society = societies[0];
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  'Select your society',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 20),
                DropdownButton(
                  value: selectedSociety,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: societies.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() => loading = true);
                    setState(() {
                      selectedSociety = value;
                      //flatVar.structure.clear();
                      //print("Called on change");
                      getSocietyStructure(selectedSociety);
                    });
                    setState(() => loading = false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
