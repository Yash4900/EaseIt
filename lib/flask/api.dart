import 'package:http/http.dart' as http;

class API {
  getUsage(String society, String licensePlateNo) async {
    var url = Uri.parse(
        'http://<ip_addr>:5000/usage?society=$society&licensePlateNo=$licensePlateNo');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else {
      return response.body;
    }
  }
}
