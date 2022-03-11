// Register page

// import 'dart:html';

import 'package:ease_it/screens/auth/register/custom_dropdown_widget.dart';
import 'package:ease_it/screens/auth/register/flat_data.dart';
import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleScreen;
  final List<String> societies;
  final String society;
  RegisterPage(this.toggleScreen, this.societies, this.society);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController wingController = TextEditingController();
  TextEditingController flatController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  List<String> dropDownItems = ["Resident", "Tenant", "Security Guard"];
  String dropDownValue = "Resident";
  String selectedSociety;
  String errorText = "";
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  FlatData flatVar = FlatData();

  @override
  void initState() {
    selectedSociety = widget.society;
    getSocietyStructure(selectedSociety);
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? Loading()
          : Container(
              margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Hello There!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Please register by entering the details',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Select your society',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 20),
                        DropdownButton(
                          value: selectedSociety,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: widget.societies.map((String items) {
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
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'I\'m a',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 20),
                        DropdownButton(
                          value: dropDownValue,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: dropDownItems.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() => dropDownValue = value);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(fontSize: 15),
                            ),
                            controller: fnameController,
                            validator: (value) => value.length < 2
                                ? 'Enter valid first name'
                                : null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(fontSize: 15),
                            ),
                            controller: lnameController,
                            validator: (value) => value.length < 2
                                ? 'Enter valid first name'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value.length != 10 ? 'Enter a valid number' : null,
                    ),
                    SizedBox(height: 10),
                    dropDownValue == 'Resident'
                        ?
                        //  Row(
                        //     children: [
                        //       Flexible(
                        //         flex: 1,
                        //         child: TextFormField(
                        //           decoration: InputDecoration(
                        //             hintText: 'Wing',
                        //             hintStyle: TextStyle(fontSize: 15),
                        //           ),
                        //           controller: wingController,
                        //           validator: (value) =>
                        //               dropDownValue == 'Security Guard' &&
                        //                       value.length > 0
                        //                   ? 'Enter valid wing'
                        //                   : null,
                        //         ),
                        //       ),
                        //       SizedBox(width: 10),
                        //       Flexible(
                        //         flex: 1,
                        //         child: TextFormField(
                        //           decoration: InputDecoration(
                        //             hintText: 'Flat No',
                        //             hintStyle: TextStyle(fontSize: 15),
                        //           ),
                        //           controller: flatController,
                        //           keyboardType: TextInputType.number,
                        //           validator: (value) => (dropDownValue ==
                        //                           'Resident' &&
                        //                       value.length != 4 &&
                        //                       value.length != 3) ||
                        //                   (dropDownValue == 'Security Guard' &&
                        //                       value.length > 0)
                        //               ? 'Enter valid flat number'
                        //               : null,
                        //         ),
                        //       ),
                        //     ],
                        //   )
                        Column(
                            //physics: ClampingScrollPhysics(),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                flatVar.flatWidgetForm.length, (i) {
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
                          )
                        : SizedBox(),
                    //SizedBox(height: 20),
                    // Column(
                    //   //physics: ClampingScrollPhysics(),
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children:
                    //       List.generate(flatVar.flatWidgetForm.length, (i) {
                    //     //return flatVar.flatWidgetForm[i];
                    //     if ((i + 1) % 2 == 1) {
                    //       if (i + 1 < flatVar.flatWidgetForm.length) {
                    //         return Row(
                    //           children: [
                    //             Expanded(
                    //               flex: 1,
                    //               child: flatVar.flatWidgetForm[i],
                    //             ),
                    //             SizedBox(
                    //               width: 10,
                    //             ),
                    //             Expanded(
                    //               flex: 1,
                    //               child: flatVar.flatWidgetForm[i + 1],
                    //             ),
                    //           ],
                    //         );
                    //       } else {
                    //         return Row(
                    //           children: [
                    //             Expanded(
                    //               flex: 1,
                    //               child: flatVar.flatWidgetForm[i],
                    //             ),
                    //           ],
                    //         );
                    //       }
                    //     } else {
                    //       return SizedBox();
                    //     }
                    //   }),
                    // ),
                    Text(
                      errorText,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 1),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? 'Password must have atleast 6 characters'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (value) => value != passwordController.text
                          ? 'Not matching with the password'
                          : null,
                    ),
                    SizedBox(height: 60),
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          if (!flatVar.flatValue.contains(null)) {
                            setState(() => errorText = "");
                            flatVar.createMapFromListForFlat();
                            //print(flatVar.flatNum);
                            setState(() => loading = true);
                            dynamic result = await Auth().register(
                                selectedSociety,
                                fnameController.text,
                                lnameController.text,
                                emailController.text,
                                phoneController.text,
                                passwordController.text,
                                dropDownValue,
                                flatVar.flatNum,
                                wingController.text,
                                flatController.text);
                            if (result == null) {
                              setState(() => loading = false);
                              showMessageDialog(context, "Oops!",
                                  "Something went wrong please try again!");
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
                          'Register',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleScreen();
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xff037DD6)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
