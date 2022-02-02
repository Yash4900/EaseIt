import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Storage {
  final _storage = FirebaseStorage.instance;

  Future<String> storeImage(String path, String fileName, File file) async {
    try {
      TaskSnapshot taskSnapshot =
          await _storage.ref().child('$path/$fileName').putFile(file);
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
