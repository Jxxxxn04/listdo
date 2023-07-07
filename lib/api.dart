import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'package:http/http.dart' as http;

class Api {

  final String _apiKey = "42bee375-ecaa-4a93-9155-daca80549008";

  final http.Response _noConnection = http.Response("Es konnte keine Verbindung zur API hergestellt werden!", 500);



  //Will wait a Specific time until the method is finished
  Future<bool> waitMethod(Duration duration) async {
    await Future.delayed(duration);
    return true;
  }

  //Will throw an error
  Future<Future> errorMethod() async {
    return Future.error("Error");
  }


  Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('${Constants.domainBaseUrl}/user/login');
    final headers = {'Content-Type': 'application/json',
                     'Authorization': _apiKey};
    final data = {'email' : email, 'password': password};


    try {
      final response = await http.post(
          url, headers: headers, body: jsonEncode(data)).timeout(
          const Duration(seconds: 5));
      return response;
    } catch (e) {
      if (e is TimeoutException) {
        // Ein Timeout ist aufgetreten
        print('Timeout aufgetreten!');
      } else {
        // Anderer Fehler ist aufgetreten
        print('Fehler: $e');
      }

      return _noConnection;

    }
  }

  Future<http.Response> registerUser(String username, String email, String password) async {
    final url = Uri.parse('${Constants.domainBaseUrl}/user/register');
    final headers = {'Content-Type': 'application/json',
      'Authorization': _apiKey};
    final data = {'username' : username, 'email' : email, 'password': password};


    try {
      final response = await http.post(
          url, headers: headers, body: jsonEncode(data)).timeout(
          const Duration(seconds: 5));
      return response;
    } catch (e) {
      if (e is TimeoutException) {
        // Ein Timeout ist aufgetreten
        print('Timeout aufgetreten!');
      } else {
        // Anderer Fehler ist aufgetreten
        print('Fehler: $e');
      }

      return _noConnection;

    }
  }

  Future<http.Response> getLists() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userID = prefs.getInt("userID");

    final url = Uri.parse('${Constants.domainBaseUrl}/list/getUserLists/$userID');
    final headers = {'Content-Type': 'application/json',
      'Authorization': _apiKey};


    try {
      final response = await http.get(
          url, headers: headers).timeout(
          const Duration(seconds: 5));
      return response;
    } catch (e) {
      if (e is TimeoutException) {
        // Ein Timeout ist aufgetreten
        if (kDebugMode) {
          print('Timeout aufgetreten!');
        }
      } else {
        // Anderer Fehler ist aufgetreten
        if (kDebugMode) {
          print('Fehler: $e');
        }
      }

      return _noConnection;

    }
  }




}