// Cloud Firestore functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:intl/intl.dart';

class Database {
  Globals g = Globals();
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

  Future updateUserDetails(String societyName, String uid, String fname,
      String lname, String email, String phoneNumber, String imageUrl) async {
    try {
      return await _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .doc(uid)
          .update({
        'fname': fname,
        'lname': lname,
        'email': email,
        'phoneNum': phoneNumber,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
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

  Stream<DocumentSnapshot> userStream(String societyName, String uid) {
    try {
      return _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .doc(uid)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Maintenance queries
  Stream<QuerySnapshot> fetchMaintenance(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('maintenance')
          .collection('Maintenance')
          .orderBy('datePaid', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Resident Fetch queries
  Stream<QuerySnapshot> fetchResidentsOfSociety(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .where('role', isNotEqualTo: "Security Guard")
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

  Future<void> addMaintenance(
      String societyName, String billAmount, String month) async {
    QuerySnapshot snap = await _firestore
        .collection(societyName)
        .doc('users')
        .collection('User')
        .where('role', isNotEqualTo: "Security Guard")
        .get();

    snap.docs.forEach((doc) {
      return _firestore
          .collection(societyName)
          .doc('maintenance')
          .collection('Maintenance')
          .add({
        'status': "Pending",
        'billAmount': billAmount,
        'month': month,
        'datePaid': "",
        'name': doc["fname"],
        'flatNo': doc["flatNo"],
        'wing': doc["wing"]
      });
    });
  }

  Future<void> markMaintenanceAsPaid(
      String societyName, String wing, String flatNo, String month, String billAmount) async {
    // print("12Inside Add Maintenance");
    String docID = "";
    QuerySnapshot snap = await _firestore
        .collection(societyName)
        .doc('maintenance')        
        .collection('Maintenance')                        
        .where('wing', isEqualTo: wing)
        .where('flatNo', isEqualTo: flatNo)
        .where('month', isEqualTo: month)        
        .get();

    snap.docs.forEach((doc) {
      docID = doc.id.toString();
    });

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return _firestore
      .collection(societyName)
      .doc('maintenance')        
      .collection('Maintenance')   
      .doc(docID)
      .update({
        'status': "Paid",
        'datePaid': formattedDate
      });
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

  Future<QuerySnapshot> searchVehicle(
      String society, String licensePlateNo) async {
    try {
      return await _firestore
          .collection(society)
          .doc('vehicles')
          .collection('Vehicle')
          .where('licensePlateNo', isEqualTo: licensePlateNo)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Child approval
  Stream<QuerySnapshot> getPastChildApproval(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .where('date', isLessThan: DateTime.now().subtract(Duration(days: 1)))
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> getRecentChildApproval(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)))
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> sendChildApprovalRequest(String society, String name, String age,
      String wing, String flatNo) async {
    try {
      await _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .add({
        'name': name,
        'age': age,
        'wing': wing,
        'flatNo': flatNo,
        'date': DateTime.now(),
        'status': 'Pending'
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
