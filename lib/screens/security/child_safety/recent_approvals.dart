// Recent child approvals list

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/flat_data.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:ease_it/utility/custom_dropdown_widget.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:flutter/material.dart';

class RecentApproval extends StatefulWidget {
  @override
  _RecentApprovalState createState() => _RecentApprovalState();
}

class _RecentApprovalState extends State<RecentApproval> {
  Globals g = Globals();
  bool loading = false;
  List<String> days = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Color getColor(String status) {
    if (status == "PENDING") return Color(0xff037DD6);
    if (status == "APPROVED") return Color(0xff107154);
    return Color(0xffbb121a);
  }

  String formatValue(int num) {
    return num < 10 ? '0' + num.toString() : num.toString();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Column(
            children: [
              Expanded(
                flex: 6,
                child: StreamBuilder(
                  stream: Database().getRecentChildApproval(g.society),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    } else {
                      return snapshot.data.docs.length > 0
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                DateTime date = ds['date'].toDate();
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 2),
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
                                    title: Text(
                                      ds['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Flat: ${FlatDataOperations(hierarchy: g.hierarchy, flatNum: Map<String, String>.from(ds['flat'])).returnStringFormOfFlatMap()}  Age: ${ds['age']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          "Time: ${formatValue(date.hour)}:${formatValue(date.minute)}, ${date.day} ${days[date.month - 1]} ${date.year}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[500],
                                          ),
                                        )
                                      ],
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            getColor(ds['status'].toUpperCase())
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 5,
                                      ),
                                      child: Text(
                                        ds['status'].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: getColor(
                                              ds['status'].toUpperCase()),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/no_data.png',
                                    width: 300,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'No Recent Approvals',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            );
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                          side: BorderSide(
                            color: Color(0xff037DD6),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        elevation: 1,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        builder: (context) {
                          return ApprovalAcceptance();
                        },
                      );
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Color(0xff037DD6),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'New Approval',
                            style: TextStyle(
                              color: Color(0xff037DD6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                ),
              )
            ],
          );
  }
}

class ApprovalAcceptance extends StatefulWidget {
  const ApprovalAcceptance({Key key}) : super(key: key);

  @override
  State<ApprovalAcceptance> createState() => _ApprovalAcceptanceState();
}

class _ApprovalAcceptanceState extends State<ApprovalAcceptance> {
  Globals g = Globals();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  //TextEditingController _wingController = TextEditingController();
  //TextEditingController _flatNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  FlatData flatVar = FlatData();
  String errorText = "";

  @override
  void initState() {
    super.initState();
    getSocietyStructure(g.society);
  }

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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Add details of child below',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Enter child\'s name'),
                        controller: _nameController,
                        validator: (value) =>
                            value.length == 0 ? 'Please enter name' : null,
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Enter child\'s age'),
                        controller: _ageController,
                        validator: (value) =>
                            value.length == 0 ? 'Please enter age' : null,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
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
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red),
                ),
                // Row(
                //   children: [
                //     Flexible(
                //       child: TextFormField(
                //         decoration: InputDecoration(
                //             hintText: 'Enter wing'),
                //         controller: _wingController,
                //         validator: (value) =>
                //             value.length == 0
                //                 ? 'Please enter wing'
                //                 : null,
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     Flexible(
                //       child: TextFormField(
                //         decoration: InputDecoration(
                //             hintText: 'Enter flat no'),
                //         controller: _flatNoController,
                //         validator: (value) => value
                //                     .length ==
                //                 0
                //             ? 'Please enter flat number'
                //             : null,
                //         keyboardType:
                //             TextInputType.number,
                //       ),
                //     )
                //   ],
                // ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey[200]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (!flatVar.flatValue.contains(null)) {
                            setState(() {
                              errorText = "";
                            });
                            bool confirmation = await showConfirmationDialog(
                                context,
                                "Alert!",
                                "Are you sure you want to send this request?");
                            if (confirmation) {
                              setState(() => loading = true);
                              flatVar.createMapFromListForFlat();
                              Database()
                                  .sendChildApprovalRequest(
                                g.society,
                                _nameController.text,
                                _ageController.text,
                                flatVar.flatNum,
                                //_wingController.text,
                                //_flatNoController.text,
                              )
                                  .then((value) {
                                setState(() => loading = false);
                                showToast(context, "success", "Success!",
                                    "Child approval request sent successfully");
                                Navigator.pop(context);
                              }).catchError(() {
                                setState(() => loading = false);
                              });
                            }
                          } else {
                            setState(() {
                              errorText = "Please fill all the flat fields";
                            });
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                      child: Text(
                        'Send Request',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
