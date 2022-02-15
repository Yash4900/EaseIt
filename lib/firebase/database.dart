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
          'imageUrl': '',
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
          'imageUrl': '',
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

  Future getUserDetails(String societyName, String uid) async {
    try {
      return await _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .doc(uid)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Complaints queries
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

  Future<void> addComplaint(String id, String societyName, String title,
      String description, String imageUrl, String postedBy) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('complaints')
          .collection('Complaint')
          .doc(id)
          .set({
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

  Future<void> markResolved(String id, String societyName) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('complaints')
          .collection('Complaint')
          .doc(id)
          .update({'status': 'Resolved'});
    } catch (e) {
      print(e.toString());
    }
  }

  // Notice queries
  Stream<QuerySnapshot> fetchNotices(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('notices')
          .collection('Notice')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> addNotice(String societyName, String title, String body) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('notices')
          .collection('Notice')
          .add({'title': title, 'body': body, 'postedOn': DateTime.now()});
    } catch (e) {
      print(e.toString());
    }
  }

  // Events queries
  Stream<QuerySnapshot> fetchPastEvents(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('events')
          .collection('Event')
          .where('date', isLessThan: DateTime.now())
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> fetchUpcomingEvents(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('events')
          .collection('Event')
          .where('date', isGreaterThanOrEqualTo: DateTime.now())
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> addEvent(String societyName, String name, String venue,
      DateTime date, String from, String to) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('events')
          .collection('Event')
          .add({
        'name': name,
        'venue': venue,
        'date': date,
        'from': from,
        'to': to
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Vehicle management queries
  Future<void> addVehicle(
      String societyName,
      String imageUrl,
      String licensePlateNo,
      String model,
      String parkingSpaceNo,
      String vehicleType,
      String wing,
      String flatNo) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('vehicles')
          .collection('Vehicle')
          .add({
        'imageUrl': imageUrl,
        'licensePlateNo': licensePlateNo,
        'model': model,
        'parkingSpaceNo': parkingSpaceNo,
        'vehicleType': vehicleType,
        'wing': wing,
        'flatNo': flatNo
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot> getMyVehicle(
      String societyName, String wing, String flatNo) async {
    try {
      return await _firestore
          .collection(societyName)
          .doc('vehicles')
          .collection('Vehicle')
          .where('wing', isEqualTo: wing)
          .where('flatNo', isEqualTo: flatNo)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
