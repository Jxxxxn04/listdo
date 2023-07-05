import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.height, required this.width, required this.text, required this.color, required this.textpadding, this.splashColor, this.onTap, this.textColor});

  final double height;
  final double width;
  final String text;
  final Color color;
  final EdgeInsetsGeometry textpadding;
  final Color? splashColor;
  final Color? textColor;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: textpadding,
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14.sp
                  )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
