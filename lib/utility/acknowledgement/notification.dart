import 'dart:convert';
// import 'package:ease_it/secret/secret.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotification(String to, String title, String message) async {
  try {
    String FCM_KEY="AAAAnT6_oc0:APA91bGLoDSYcS-S5XHl29kCGPFp-_taOb7j-Wdu5fB6qzzMTF79RJiZA1P9O_KZIW_FVzRWHr-Luvu-pSQi37ZX3XoiN5ywJ59rEor9TKSE1d-X6c-2ZVUsZpb3iVmyvSIrRYEiMkET";
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$FCM_KEY'
      },
      body: jsonEncode({
        'to': to,
        'notification': {
          'title': title,
          'body': message,
        },
      }),
    );
    print('FCM request for device sent!');
  } catch (e) {
    print(e);
  }
}
