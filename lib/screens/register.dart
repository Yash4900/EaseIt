// Register page

import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:flutter/material.dart';

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
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedSociety = widget.society;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? Loading()
          : Container(
              margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                              fontSize: 14, fontWeight: FontWeight.w500),
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
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() => selectedSociety = value);
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
                              fontSize: 14, fontWeight: FontWeight.w500),
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
                                style: TextStyle(fontSize: 14),
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
                              hintStyle: TextStyle(fontSize: 14),
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
                              hintStyle: TextStyle(fontSize: 14),
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
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value.length != 10 ? 'Enter a valid number' : null,
                    ),
                    SizedBox(height: 10),
                    dropDownValue == 'Resident'
                        ? Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Wing',
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  controller: wingController,
                                  validator: (value) =>
                                      dropDownValue == 'Security Guard' &&
                                              value.length > 0
                                          ? 'Enter valid wing'
                                          : null,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Flat No',
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  controller: flatController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) => (dropDownValue ==
                                                  'Resident' &&
                                              value.length != 4 &&
                                              value.length != 3) ||
                                          (dropDownValue == 'Security Guard' &&
                                              value.length > 0)
                                      ? 'Enter valid flat number'
                                      : null,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 14),
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
                        hintStyle: TextStyle(fontSize: 14),
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
                          setState(() => loading = true);
                          dynamic result = await Auth().register(
                              selectedSociety,
                              fnameController.text,
                              lnameController.text,
                              emailController.text,
                              phoneController.text,
                              passwordController.text,
                              dropDownValue,
                              wingController.text,
                              flatController.text);
                          if (result == null) {
                            setState(() => loading = false);
                            showMessageDialog(context, "Oops!",
                                "Something went wrong please try again!");
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
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
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleScreen();
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Color(0xff1a73e8)),
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
