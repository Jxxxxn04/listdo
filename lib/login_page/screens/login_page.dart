import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:listdo/constants.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final Constants constants = Constants();
  final _formKey = GlobalKey<FormState>();

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
              _registerButtonWidget(),
              _loginTextWidget("Einloggen"),
              _formWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerButtonWidget() {
    return SizedBox(
      height: 20.h,
      width: 100.w,
      child: Row(
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10.w),
            child: Align(
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
                        "Registrieren",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp
                        ),
                      ),
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

  Widget _loginTextWidget(String text) {
    return SizedBox(
      height: 10.h,
      width: 100.w,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp
        ),
      ),
    );
  }

  Widget _formWidget() {
    return SizedBox(
      height: 30.h,
      width: 100.w,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _emailFormInputFieldWidget(),
          ],
        ),
      ),
    );
  }

  Widget _emailFormInputFieldWidget() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: "Email",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
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

}
