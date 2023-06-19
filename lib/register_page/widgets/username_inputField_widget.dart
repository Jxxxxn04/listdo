import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';
import 'package:sizer/sizer.dart';


class UsernameInputField extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;

  const UsernameInputField({super.key, required this.controller, required this.hintText});

  @override
  State<UsernameInputField> createState() => _UsernameInputFieldState();
}

class _UsernameInputFieldState extends State<UsernameInputField> {

  bool _isError = false;
  bool _isUsernameLongEnough = false;



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(

        // TODO 2. _popupWidget() durch none ersetzen
          suffixIcon: _isError ? _popupWidget(context) : _popupWidget(context),
          prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            textStyle:
            TextStyle(color: const Color(0xFFACACAC), fontSize: 14.sp),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: _isError ? const BorderSide(color: Colors.red, width: 3) : BorderSide(color: Colors.green, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  _isError ? const BorderSide(color: Colors.red, width: 3) : const BorderSide(color: Colors.green, width: 2))),
      // The validator receives the text that the user has entered.
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        _isUsernameLongEnough = _checkForLength(value);
        return null;
      },
    );
  }

  Widget _popupWidget(BuildContext context) {
    return InfoPopupWidget(

      dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,

      arrowTheme: const InfoPopupArrowTheme(
        color: Colors.transparent,
      ),
      enableHighlight: true,
      customContent: _returnErrorsWidget(),
      child: Icon(
        Icons.info_outline,
        color: Colors.red,
        size: 24.sp,
      ),
    );
  }

  bool _checkForLength(String? value) {


    // TODO : Hier steckt ein Denkfehler drinne, noch wegmachen
    //Gibt true zurück wenn value länger als 4 ist
    if (value != null && value.isNotEmpty) {
      if (value.length >= 4) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _changeToIsNotError();
          });
        });
        return true;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _changeToIsError();
          });
        });
        return false;
      }
    }

    return false;

  }

  void _changeToIsError() {
    setState(() {
      _isError = true;
    });
  }

  void _changeToIsNotError() {
    setState(() {
      _isError = false;
    });
  }

  Widget _returnErrorsWidget() {
    return Center(
      child: Container(
        height: 20.h,
        width: 80.w,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Text(
                "Der Benutzername muss mindestens\n 4 Buchstaben haben!",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: _isError ? Colors.red : Colors.green
                ),
                textAlign: TextAlign.center,
              ),


              const Spacer(),

              Align(
                alignment: Alignment.centerRight, child: _isError ? Icon(
                Icons.error,
                color: Colors.red,
                size: 24.sp,
              ) : Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.sp,
              ),
              ),
              ]
            ),
            Row(children: [
              Text(
                "Der Benutzername darf keine \nSonderzeichen haben!",
                style: TextStyle(
                    fontSize: 10.sp,
                    color: _isError ? Colors.red : Colors.green
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              Align(
                alignment: Alignment.centerRight, child: _isError ? Icon(
                Icons.error,
                color: Colors.red,
                size: 24.sp,
              ) : Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.sp,
              ),
              ),

            ]
            )
          ],
        ),
      ),
    );
  }

}
