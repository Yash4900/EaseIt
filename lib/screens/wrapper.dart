import 'package:ease_it/screens/auth/authscreen.dart';
import 'package:ease_it/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      // User is not logged in
      return AuthScreen();
    } else {
      // User is logged in
      return Home(user.uid);
    }
  }
}
