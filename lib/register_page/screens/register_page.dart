import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:info_popup/info_popup.dart';
import 'package:listdo/api.dart';
import 'package:listdo/constants.dart';
import 'package:listdo/screens.dart';
import 'package:sizer/sizer.dart';
import 'package:listdo/register_page/widgets/register_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Constants constants = Constants();
  final Api api = Api();

  final _formKey = GlobalKey<FormState>();
  final _passwordTEC = TextEditingController();
  final _confirmTEC = TextEditingController();
  final _emailTEC = TextEditingController();
  final _usernameTEC = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _confirmTEC.dispose();
    _usernameTEC.dispose();
    _passwordTEC.dispose();
    _emailTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  constants.linearGradientTopColor,
                  constants.linearGradientBottomColor
                ])),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  _registerButtonWidget("Einloggen", 12.h, 100.w),
                  _loginTextWidget("Registrieren", 8.h, 100.w),
                  _formWidget(35.h, 100.w),
                  SizedBox(
                    height: 3.h,
                  ),
                  _loginButtonWidget("Registrieren", 7.h, 100.w),
                  SizedBox(
                    height: 4.w,
                  ),
                  _guestButtonWidget("Als Gast fortfahren", 7.h, 100.w),
                  SizedBox(
                    height: 2.h,
                  ),
                  _lineWithWord("oder", 3.h),
                  SizedBox(
                    height: 2.h,
                  ),
                  _logInWithAppleButtonWidget(
                      "Mit Apple fortfahren", 7.h, 100.w),
                  SizedBox(
                    height: 3.h,
                  ),
                  _logInWithGoogleButtonWidget(
                      "Mit Google fortfahren", 7.h, 100.w),
                ],
              ),
            ),
          ),
          if (isLoading)
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

  Widget _registerButtonWidget(String text, double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Row(
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 5.h,
              width: 32.w,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Center(
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 12.sp),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginTextWidget(String text, double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Text(text,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white, fontSize: 24.sp),
          )),
    );
  }

  Widget _formWidget(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            UsernameInputField(controller: _usernameTEC, hintText: "Nutzername"),
            SizedBox(
              height: 4.w,
            ),
            _emailFormInputFieldWidget("Email"),
            SizedBox(
              height: 4.w,
            ),
            _passwordFormInputFieldWidget("Password"),
            SizedBox(
              height: 4.w,
            ),
            _confirmFormInputFieldWidget("Passwort bestätigen"),
          ],
        ),
      ),
    );
  }

  Widget _usernameFormInputFieldWidget(String hintText) {
    return TextFormField(
      controller: _usernameTEC,
      decoration: InputDecoration(
        suffixIcon: InfoPopupWidget(
          arrowTheme: InfoPopupArrowTheme(
            color: Colors.purple,

          ),
          enableHighlight: true,
          customContent: Center(
            child: Container(
              height: 40.h,
              width: 50.w,
              color: Colors.orange,
              child: Text("Bliblablub"),
            ),
          ),
          child: Icon(
            Icons.info_outline,
            color: Colors.red,
            size: 24.sp,
          ),
        ),
          prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            textStyle:
            TextStyle(color: const Color(0xFFACACAC), fontSize: 14.sp),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2))),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _emailFormInputFieldWidget(String hintText) {
    return TextFormField(
      controller: _emailTEC,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email_rounded),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            textStyle:
                TextStyle(color: const Color(0xFFACACAC), fontSize: 14.sp),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2))),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _passwordFormInputFieldWidget(String hintText) {
    return TextFormField(
      controller: _passwordTEC,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            textStyle:
                TextStyle(color: const Color(0xFFACACAC), fontSize: 14.sp),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2))),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _confirmFormInputFieldWidget(String hintText) {
    return TextFormField(
      controller: _confirmTEC,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            textStyle:
                TextStyle(color: const Color(0xFFACACAC), fontSize: 14.sp),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2))),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _loginButtonWidget(String text, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF6A6FDE),
        elevation: 6,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _registerFunction, // TODO : Login
          child: Center(
            child: Text(text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }

  Widget _guestButtonWidget(String text, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF5BA9F0),
        elevation: 6,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {}, // TODO : Login
          child: Center(
            child: Text(text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }

  Widget _lineWithWord(String word, double height) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Divider(
              thickness: 1.0,
              endIndent: 24.0,
              color: Colors.white,
            ),
          ),
          Text(
            word,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Expanded(
            child: Divider(
              thickness: 1.0,
              indent: 24.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logInWithGoogleButtonWidget(
      String text, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Row(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 3.5.w, top: 3.5.w, bottom: 3.5.w),
                  child: const Image(
                      image: AssetImage("assets/images/google_logo.png"))),
              const Spacer(),
              Text(
                text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logInWithAppleButtonWidget(String text, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Row(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 3.5.w, top: 3.5.w, bottom: 3.5.w),
                  child: const Image(
                      image: AssetImage("assets/images/apple_logo.png"))),
              const Spacer(),
              Text(
                text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  //Funktionen
  void _registerFunction() async {
    setState(() {
      isLoading = true;
    });

    //_formKey.currentState?.validate();

    // TODO : Wenn Felder leer oder email ungültig Error anzeigen lassen

    String email = _emailTEC.text.toString();
    String password = _passwordTEC.text.toString();
    String confirm = _confirmTEC.text.toString();
    String username = _usernameTEC.text.toString();

    if (password != confirm) {
      print("Falsches Passwort");
      setState(() {
        isLoading = false;
      });
      return;
    }

    http.Response response = await api.registerUser(username, email, password);
    //print("${response.statusCode} \n ${response.body}");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(
                "Status Code: ${response.statusCode.toString()} \n Message: ${response.body}"))));

    if (response.statusCode == 200) {
      await _onSuccessRegistration(response);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onSuccessRegistration(http.Response response) async {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);

    String message = jsonMap['message'];
    int userID = jsonMap['userID'];
    String username = jsonMap['username'];
    String email = jsonMap['email'];
    String createdAt = jsonMap['created_at'];

    Future.delayed(const Duration(seconds: 2));

    // TODO : Wenn auf HomePage weitergeleitet Benutzernamen eingeben
  }
}
