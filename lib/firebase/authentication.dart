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

  Future<bool> reAuthenticate(String currentEmail, String currentPassword,
      {String newEmail = "", String newPassword = ""}) async {
    final currUser = _auth.currentUser;
    dynamic userCred = EmailAuthProvider.credential(
        email: currentEmail, password: currentPassword);
    bool detailsChanged = true;
    if (newEmail != "") {
      currUser.reauthenticateWithCredential(userCred).then((value) {
        currUser.updateEmail(newEmail).then((value) {
          detailsChanged = true;
          userCred = EmailAuthProvider.credential(
              email: newEmail, password: currentPassword);
        }).catchError((onError) {
          detailsChanged = false;
        });
      }).catchError((onError) {
        detailsChanged = false;
      });
    }
    print("DetailsChanged In auth " + detailsChanged.toString());
    if (newPassword != "") {
      currUser.reauthenticateWithCredential(userCred).then((value) {
        currUser.updatePassword(newPassword).then((value) {
          detailsChanged = true;
        }).catchError((onError) {
          detailsChanged = false;
        });
      }).catchError((onError) {
        detailsChanged = false;
      });
    }
    print("DetailsChanged In auth " + detailsChanged.toString());
    return detailsChanged;
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
