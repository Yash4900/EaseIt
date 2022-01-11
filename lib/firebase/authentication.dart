// Firebase Authentication functions

import 'package:ease_it/firebase/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future register(String fname, String lname, String email, String phoneNum,
      String password, String role,
      [String wing, String flatNo]) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // Store new user's data in firestore database
      await Database().createUser(
          user.uid, fname, lname, email, phoneNum, role, wing, flatNo);
      return user;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  logout() {
    _auth.signOut();
  }

  Stream<User> get user {
    return _auth.authStateChanges();
  }
}
