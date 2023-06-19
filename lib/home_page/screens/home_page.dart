import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/widgets/rounded_navigation_bar.dart';
import 'package:listdo/screens.dart';
import 'package:listdo/constants.dart';
import 'package:listdo/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Constants constants = Constants();
  final Api api = Api();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [

              //App Bar
              _appBar("Meine Listen", 15.h, 100.w),

              //List Body
              Stack(
                children: [
                  Container(
                    height: 85.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                          constants.linearGradientTopColor,
                          constants.linearGradientBottomColor
                          ]
                      ),
                    ),
                  ),
                  const Positioned(bottom: 0,child: RoundedNavigationBar(backgroundColor: Color(0xFF252525))),
                ],
              ),  // 11.h
            ],
          ),


          //Loading Widget
          if (_isLoading)
            Container(
              height: 100.h,
              width: 100.w,
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _appBar(String text, double height, double width) {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFF252525),
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, bottom: 5.w),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.sp
              )
            ),
          ),
        ),
      ),
    );
  }


  Future<bool> _hasUsername() async {

    setState(() {
      _isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await api.hasUsername(prefs.getInt("userID"));

    if(response.statusCode == 500) {

      setState(() {
        _isLoading = false;
      });

      return false;
    }

    setState(() {
      _isLoading = false;
    });

    return true;
  }
}
