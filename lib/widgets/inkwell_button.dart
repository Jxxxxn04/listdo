import 'package:flutter/material.dart';

class CustomInkWellButton extends StatelessWidget {
  const CustomInkWellButton(
      {Key? key,
        this.borderRadius,
        required this.height,
        required this.width,
        this.color,
        required this.onTap,
        this.elevation,
        this.child})
      : super(key: key);

  final BorderRadius? borderRadius;
  final double height;
  final double width;
  final Color? color;
  final VoidCallback onTap;
  final double? elevation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        borderRadius: borderRadius,
        elevation: elevation ?? 0,
        color: color ?? Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}