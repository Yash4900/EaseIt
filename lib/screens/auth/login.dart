// Login page

import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/auth/society_registration.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function toggleScreen;
  final List<String> societies;
  final String society;
  LoginPage(this.toggleScreen, this.societies, this.society);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<String> dropDownItems = ["Resident", "Tenant", "Security Guard"];
  String dropDownValue = "Resident";
  String selectedSociety;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

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
                    Image.asset(
                      'assets/login_page_image.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Welcome!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Please Log In to continue',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]),
                    ),
                    SizedBox(height: 20),
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
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) => value.length < 6
                          ? 'Password must have atleast 6 characters'
                          : null,
                    ),
                    SizedBox(height: 80),
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          setState(() => loading = true);
                          // Checking if user is registered or not
                          bool isRegistered = await Database()
                              .checkRegisteredUser(
                                  selectedSociety, emailController.text);
                          if (isRegistered) {
                            dynamic result = await Auth().login(selectedSociety,
                                emailController.text, passwordController.text);
                            setState(() => loading = false);
                            if (result == null) {
                              showMessageDialog(context, "Oops!", [
                                Text(
                                    "Could not Log In with those credentials. Make sure you have an account and entered valid credentials.")
                              ]);
                            }
                          } else {
                            setState(() => loading = false);
                            showMessageDialog(context, "Oops!", [
                              Text(
                                  "User not found for the selected society! Please register into your society.")
                            ]);
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
                          'Log In',
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
                          'Don\'t have an account? ',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleScreen();
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xff037DD6)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Want your society on our app ',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SocietyRegistration(),
                              ),
                            );
                          },
                          child: Text(
                            'Society Registration',
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
