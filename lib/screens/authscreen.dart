// User can toggle between login and register screen

import 'package:ease_it/screens/login.dart';
import 'package:ease_it/screens/register.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  void toggleScreen() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(toggleScreen);
    } else {
      return RegisterPage(toggleScreen);
    }
  }
}
