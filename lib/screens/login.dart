// Login page

import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function toggleScreen;
  LoginPage(this.toggleScreen);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<String> dropDownItems = ["Resident", "Security Guard"];
  String dropDownValue = "Resident";
  final formKey = GlobalKey<FormState>();
  bool loading = false;

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
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(fontSize: 14),
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
                          dynamic result = await Auth().login(
                              emailController.text, passwordController.text);
                          setState(() => loading = false);
                          if (result == null) {
                            showMessageDialog(context, "Oops!",
                                "Could not Log In with those credentials. Make sure you have an account and entered valid credentials.");
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
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleScreen();
                          },
                          child: Text(
                            'Sign Up',
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
