import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:listdo/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Constants constants = Constants();

  final _formKey = GlobalKey<FormState>();
  final _passwordTEC = TextEditingController();
  final _emailTEC = TextEditingController();

  @override
  void dispose() {
    _passwordTEC.dispose();
    _emailTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              constants.linearGradientTopColor,
              constants.linearGradientBottomColor
            ]
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              _registerButtonWidget("Registrieren"),
              _loginTextWidget("Einloggen"),
              _formWidget(),
              _forgotPasswordTextButtonWidget("Passwort vergessen?"),
              SizedBox(height: 5.h,),
              _loginButtonWidget("Anmelden"),
              SizedBox(height: 8.w,),
              _guestButtonWidget("Als Gast fortfahren"),
              SizedBox(height: 5.h,),
              _lineWithWord("oder"),
              SizedBox(height: 5.h,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerButtonWidget(String text) {
    return SizedBox(
      height: 15.h,
      width: 100.w,
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
                  onTap: () {}, // TODO : Go to RegisterPage()
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp
                        ),
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotPasswordTextButtonWidget(String text) {
    return SizedBox(
      height: 5.h,
      width: 100.w,
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 5.h,
              width: 45.w,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {}, // TODO : Go to ForgotPasswordPage()
                  child: Center(
                    child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _loginTextWidget(String text) {
    return SizedBox(
      height: 8.h,
      width: 100.w,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 24.sp
          ),
        )
      ),
    );
  }

  Widget _formWidget() {
    return SizedBox(
      height: 18.h,
      width: 100.w,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _emailFormInputFieldWidget("Email"),
            SizedBox(height: 4.w,),
            _passwordFormInputFieldWidget("Password"),
          ],
        ),
      ),
    );
  }

  Widget _emailFormInputFieldWidget(String hintText) {
    return TextFormField(
      controller: _passwordTEC,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_rounded),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          textStyle: TextStyle(
              color: const Color(0xFFACACAC),
              fontSize: 14.sp
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2
          )
        )
      ),
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
      controller: _emailTEC,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            textStyle: TextStyle(
                color: const Color(0xFFACACAC),
                fontSize: 14.sp
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2
              )
          )
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget _loginButtonWidget(String text) {
    return Container(
      height: 7.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF6A6FDE),
        elevation: 6,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},  // TODO : Login
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold
                )
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget _guestButtonWidget(String text) {
    return Container(
      height: 7.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF5BA9F0),
        elevation: 6,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},  // TODO : Login
          child: Center(
            child: Text(
                text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold
                    )
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget _lineWithWord (String word) {
    return SizedBox(
      height: 50,
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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

}
