import 'package:cloud_firestore/cloud_firestore.dart';

class Database2 {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addDailyHelper(String society, String name, String phoneNum,
      List<String> worksAt, String imageUrl, String purpose, int code) async {
    try {
      await _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .add({
        'name': name,
        'phoneNum': phoneNum,
        'worksAt': worksAt,
        'imageUrl': imageUrl,
        'purpose': purpose,
        'code': code
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendApproval(String society, String name, String phoneNum,
      String imageUrl, String purpose, String wing, String flatNo) async {
    try {
      await _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .add({
        'name': name,
        'phoneNum': phoneNum,
        'flatNo': flatNo,
        'imageUrl': imageUrl,
        'purpose': purpose,
        'wing': wing
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
