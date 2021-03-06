import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/display/custom_dropdown_widget.dart';
import 'package:ease_it/utility/flat_data.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/display/drawer.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
//import 'package:flutter/services.dart';

// class ResidentApproval extends StatefulWidget {
//   ResidentApproval({Key key}) : super(key: key);

//   @override
//   State<ResidentApproval> createState() => _ResidentApprovalState();
// }

// class _ResidentApprovalState extends State<ResidentApproval> {
//   Globals g = Globals();
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     //DocumentSnapshot a = Provider.of<DocumentSnapshot>(context);
//     return isLoading
//         ? Loading()
//         : a["status"] == "pending"
//             ? Pending()
//             : SizedBox();
//   }
// }

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
    //print("Normal ${g.flat}");
    //print("Changed: ${Map<String, String>.from(g.flat)}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: showCustomDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Hello, ${g.fname}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pending_actions,
                    color: Color(0xffffb30f),
                    size: 45,
                  ),
                  SizedBox(height: 20),
                  Text(
                    g.role == "Resident" || g.role == "Secretary"
                        ? "Your Residence joining request as ${g.homeRole} for the flat ${FlatDataOperations(
                            hierarchy: g.hierarchy,
                            flatNum: Map<String, String>.from(g.flat),
                          ).returnStringFormOfFlatMap()} in ${g.society} is pending"
                        : "Your Residence joining request as ${g.role} in ${g.society} is pending",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      drawer: showCustomDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Hello, ${g.fname}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.redAccent,
                      size: 45,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      g.role == "Resident"
                          ? "Your residence joining request as ${g.role} of ${FlatDataOperations(
                              hierarchy: g.hierarchy,
                              flatNum: Map<String, String>.from(g.flat),
                            ).returnStringFormOfFlatMap()} in ${g.society} has been cancelled by secretary"
                          : "Your residence joining request as ${g.role} in ${g.society} has been cancelled by the secretary",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: g.role == "Security Guard"
                          ? () {
                              Database()
                                  .updateStatus(g.society, g.email, "pending");
                            }
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReApply(),
                                ),
                              );
                            },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
            ],
          ),
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
  Globals g = Globals();
  bool loading;
  String errorText = "";
  FlatData flatVar = FlatData();
  List<String> secondDropDownItems = ["Owner", "Resident", "Tenant"];
  String secondDropDownValue = "Owner";

  void _update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    societies = [g.society];
    society = g.society;
    selectedSociety = society;
    getSocietyStructure(g.society);
    setState(() {
      loading = false;
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ReApply",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("I\'m a"),
                SizedBox(
                  width: 20,
                ),
                DropdownButton(
                  value: secondDropDownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: secondDropDownItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() => secondDropDownValue = value);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                Text("of the flat"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              //physics: ClampingScrollPhysics(),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(flatVar.flatWidgetForm.length, (i) {
                //return flatVar.flatWidgetForm[i];
                if ((i + 1) % 2 == 1) {
                  if (i + 1 < flatVar.flatWidgetForm.length) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: flatVar.flatWidgetForm[i],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: flatVar.flatWidgetForm[i + 1],
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: flatVar.flatWidgetForm[i],
                        ),
                      ],
                    );
                  }
                } else {
                  return SizedBox();
                }
              }),
            ),
            errorText == ""
                ? SizedBox(height: 0)
                : Text(
                    errorText,
                    style: TextStyle(color: Colors.red),
                  ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                if (!flatVar.flatValue.contains(null)) {
                  setState(() => errorText = "");
                  flatVar.createMapFromListForFlat();
                  setState(() {
                    loading = true;
                  });
                  List<bool> booleanValuesForRoles = [];
                  //String errorMsg = "";
                  //print(secondDropDownItems.length);
                  for (int i = 0; i < secondDropDownItems.length; i++) {
                    print(i);
                    bool temp = await Database()
                        .isAcceptedParticularHomeRoleForFlatPresent(
                      selectedSociety,
                      flatVar.flatNum,
                      secondDropDownItems[i],
                    );
                    booleanValuesForRoles.add(temp);
                  }
                  if (secondDropDownValue == "Owner" &&
                      booleanValuesForRoles[0]) {
                    setState(() {
                      loading = false;
                    });
                    showMessageDialog(
                      context,
                      "Alert",
                      [
                        Text(
                            "Each flat can have only one owner and the flat you are registering for already has one"),
                      ],
                    );
                    getSocietyStructure(selectedSociety);
                    return;
                  } else if (secondDropDownValue == "Resident" &&
                      !booleanValuesForRoles[0]) {
                    setState(() {
                      loading = false;
                    });
                    showMessageDialog(
                      context,
                      "Alert",
                      [
                        Text(
                          "The flat you are registering for does not have a owner so you cannot apply as Resident",
                        ),
                      ],
                    );
                    getSocietyStructure(selectedSociety);
                    return;
                  } else if (secondDropDownValue == "Resident" &&
                      booleanValuesForRoles[2]) {
                    setState(() {
                      loading = false;
                    });
                    showMessageDialog(
                      context,
                      "Alert",
                      [
                        Text(
                          "The flat has Tenant(s) you cannot register as Resident",
                        ),
                      ],
                    );
                    getSocietyStructure(selectedSociety);
                    return;
                  } else if (secondDropDownValue == "Tenant" &&
                      !booleanValuesForRoles[0]) {
                    setState(() {
                      loading = false;
                    });
                    showMessageDialog(
                      context,
                      "Alert",
                      [
                        Text(
                          "The flat you are registering for does not have a owner so you cannot apply as Tenant",
                        ),
                      ],
                    );
                    getSocietyStructure(selectedSociety);
                    return;
                  } else if (secondDropDownValue == "Tenant" &&
                      booleanValuesForRoles[1]) {
                    setState(() {
                      loading = false;
                    });
                    showMessageDialog(
                      context,
                      "Alert",
                      [
                        Text(
                          "The flat has Resident(s) you cannot register as Tenant",
                        ),
                      ],
                    );
                    getSocietyStructure(selectedSociety);
                    return;
                  } else {}
                  g.setRole = secondDropDownValue;
                  print(secondDropDownValue);
                  bool result = await Database().reApplication(
                      g.society, g.uid, flatVar.flatNum, secondDropDownValue);
                  setState(() {
                    loading = false;
                  });
                  if (result == true) {
                    Navigator.pop(context);
                    showToast(context, "success", "Success",
                        "ReApplication was successful");
                  } else {
                    Navigator.pop(context);
                    showToast(context, "error", "Error", "Unable to ReApply");
                  }
                } else {
                  setState(() {
                    errorText = "Please fill all the flat fields";
                  });
                }
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
