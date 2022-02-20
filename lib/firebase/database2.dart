// Cloud Firestore functions

import 'package:cloud_firestore/cloud_firestore.dart';

class Database2 {
  final _firestore = FirebaseFirestore.instance;

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
}
