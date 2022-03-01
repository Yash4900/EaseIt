// User can toggle between login and register screen

import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/auth/login.dart';
import 'package:ease_it/screens/auth/register/register.dart';
import 'package:ease_it/utility/splash_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;
  bool loading = true;
  List<String> societies;
  String society;

  getSocietyList() async {
    societies = await Database().getAllSocieties();
    society = societies[0];
    setState(() => loading = false);
  }

  @override
  void initState() {
    getSocietyList();
    super.initState();
  }

  void toggleScreen() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: SplashScreen());
    } else {
      if (showLogin) {
        return LoginPage(toggleScreen, societies, society);
      } else {
        return RegisterPage(toggleScreen, societies, society);
      }
    }
  }
}
