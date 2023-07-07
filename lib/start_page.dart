import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  Future<void> isAlreadyLoggedIn(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID =  prefs.getInt("userID");
    String? username = prefs.getString("username");
    String? email = prefs.getString("email");
    String? createdAt = prefs.getString("created_at");

    if (userID != null && username != null && email != null && createdAt != null && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/homepage", (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }



  }

  @override
  Widget build(BuildContext context) {
    isAlreadyLoggedIn(context);
    return const Scaffold(backgroundColor: Colors.black,);
  }
}
