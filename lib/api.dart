import 'dart:convert';

import 'constants.dart';
import 'package:http/http.dart' as http;

class Api {


  final Constants constants = Constants();

  final String apiKey = "42bee375-ecaa-4a93-9155-daca80549008";



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
    final url = Uri.parse('${constants.domainBaseUrl}/user/login');
    final headers = {'Content-Type': 'application/json',
                     'Authorization': apiKey};
    final data = {'email' : email, 'password': password};
    final response = await http.post(url, headers: headers, body: jsonEncode(data)).timeout(const Duration(seconds: 10));
    return response;
  }



}