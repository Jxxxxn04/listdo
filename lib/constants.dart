import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class Constants {


  // Base-URL for every REST-Api request
  static const String domainBaseUrl = 'http://jxxxxxn.ddns.net:3000';
  //


  // Colors for LinearGradient
  static const Color linearGradientTopColor = Color(0xFF6774EB);
  static const Color linearGradientBottomColor = Color(0xFFCA8EFF);
  //


  // Every available Color for lists
  static const Color redColor = Color(0xFFFF8888);
  static const Color yellowColor = Color(0xFFFFD952);
  static const Color blueColor = Color(0xFF52C1FF);
  static const Color pinkColor = Color(0xFFFF88F3);
  static const Color magentaColor = Color(0xFFD988FF);
  static const Color lightGreenColor = Color(0xFFA4D3A9);
  static const Color darkBlueColor = Color(0xFF7785FF);
  static const Color errorBlackColor = Color(0xFF000000);
  //


  static Future<int?> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userID");
  }



}