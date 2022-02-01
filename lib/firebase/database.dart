// Cloud Firestore functions

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final _firestore = FirebaseFirestore.instance;

  Future<List<String>> getAllSocieties() async {
    List<String> societies = [];
    await _firestore.collection('Society').get().then((value) {
      value.docs.forEach((doc) {
        societies.add(doc.id);
      });
    });
    return societies;
  }

  Future<bool> checkRegisteredUser(String society, String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.size == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future createUser(String society, String uid, String fname, String lname,
      String email, String phoneNum, String role,
      [String wing, String flatNo]) async {
    try {
      if (role == 'Resident' || role == 'Tenant') {
        await _firestore
            .collection(society)
            .doc('users')
            .collection('User')
            .doc(uid)
            .set({
          'fname': fname,
          'lname': lname,
          'email': email,
          'phoneNum': phoneNum,
          'role': role,
          'wing': wing,
          'flatNo': flatNo
        });
      } else {
        await _firestore
            .collection(society)
            .doc('users')
            .collection('User')
            .doc(uid)
            .set({
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

  Future getUserDetails(String society, String uid) async {
    try {
      return await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .doc(uid)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> fetchComplaints(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('complaints')
          .collection('Complaint')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> addComplaint(String societyName, String title,
      String description, String imageUrl, String postedBy) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('complaints')
          .collection('Complaint')
          .add({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'status': 'Unresolved',
        'postedBy': postedBy,
        'postedOn': DateTime.now()
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
