import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.height,
      required this.width,
      required this.text,
      required this.color,
      this.textpadding,
      this.splashColor,
      this.onTap,
      this.textColor,
      this.borderRadius,
      this.alignment});

  final double height;
  final double width;
  final String text;
  final Color color;
  final EdgeInsetsGeometry? textpadding;
  final Color? splashColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: Material(
        borderRadius: borderRadius,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          splashColor: splashColor,
          onTap: onTap,
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: Padding(
              padding: textpadding ?? EdgeInsets.zero,
              child: Text(
                text,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 14.sp,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
