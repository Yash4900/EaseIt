// Cloud Firestore functions

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final _firestore = FirebaseFirestore.instance;

  Future createUser(String uid, String fname, String lname, String email,
      String phoneNum, String role,
      [String wing, String flatNo]) async {
    try {
      if (role == 'Resident') {
        await _firestore.collection('Users').doc(uid).set({
          'fname': fname,
          'lname': lname,
          'email': email,
          'phoneNum': phoneNum,
          'role': role,
          'wing': wing,
          'flatNo': flatNo
        });
      } else {
        await _firestore.collection('Users').doc(uid).set({
          'fname': fname,
          'lname': lname,
          'email': email,
          'phoneNum': phoneNum,
          'role': role
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getUserDetails(String uid) async {
    try {
      return await _firestore.collection('Users').doc(uid).get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
