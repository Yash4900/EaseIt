// Fetch data from flask API

import 'package:ease_it/secret/secret.dart';
import 'package:http/http.dart' as http;

class API {
  String _domain = FLASK_API_URL;
  // String _domain = 'http://192.168.0.113:5000';

  // Get usage of vehicle
  Future getUsage(String society, String licensePlateNo) async {
    var url = Uri.parse(
        '$_domain/usage?society=$society&licensePlateNo=$licensePlateNo');
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

  // To log resident's vehicle exit in database
  Future vehicleExit(String society, String licensePlateNo) async {
    DateTime now = DateTime.now();
    String time = '{${now.hour}:${now.minute}:${now.second}}';
    var url = Uri.parse(
        '$_domain/exit?society=$society&licensePlateNo=$licensePlateNo&time=$time');
    http.Response response;
    try {
      response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
      );
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }

  // To log resident's vehicle entry in database
  Future vehicleEntry(String society, String licensePlateNo) async {
    DateTime now = DateTime.now();
    String time = '{${now.hour}:${now.minute}:${now.second}}';
    var url = Uri.parse(
        '$_domain/entry?society=$society&licensePlateNo=$licensePlateNo&time=$time');
    http.Response response;
    try {
      response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
      );
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }

  // Get a parking space for the visitor
  Future allocateParking(String society, String stayTime) async {
    var url = Uri.parse('$_domain/allocate?society=$society&time=$stayTime');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }

  // To mark the parking space as unoccupied when visitor leaves
  Future disAllocateParking(String society, String parkingSpaceNumber) async {
    var url = Uri.parse(
        '$_domain/dis-allocate?society=$society&parking=$parkingSpaceNumber');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }

  // Add vehicle in flask database
  Future addVehicle(
      String society, String licensePlateNo, String parking) async {
    var url = Uri.parse('$_domain/add-vehicle?society=$society');
    http.Response response;
    try {
      response = await http.post(url,
          body: {'licensePlateNo': licensePlateNo, 'parking': parking});
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }
}
