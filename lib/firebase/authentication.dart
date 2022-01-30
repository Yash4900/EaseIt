// Firebase Authentication functions

import 'package:ease_it/firebase/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future login(String society, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Save society name in local memory
      prefs.setString("society", society);

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      prefs.clear();
    }
    return null;
  }

  Future register(String society, String fname, String lname, String email,
      String phoneNum, String password, String role,
      [String wing, String flatNo]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Save society name in local memory
      prefs.setString("society", society);

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // Store new user's data in firestore database
      await Database().createUser(
          society, user.uid, fname, lname, email, phoneNum, role, wing, flatNo);
      return user;
    } catch (e) {
      print(e.toString());
      prefs.clear();
    }
    return null;
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _auth.signOut();
    prefs.clear();
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }
}
