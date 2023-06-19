import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedNavigationBar extends StatelessWidget {
  const RoundedNavigationBar({Key? key, required this.backgroundColor}) : super(key: key);

  final Color backgroundColor;


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 11.h,
        width: 100.w,
        child: Row(

          children: [
            Container(
              height: 11.h,
              width: 40.w,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
                color: backgroundColor,

                )
              ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 11.h - 15,
                width: 20.w,
                child: CustomPaint(
                  size: Size(20.w, 11.h - 15),
                  painter: RPSCustomPainter(backgroundColor),

                ),
              ),
            ),

            Container(
              height: 11.h,
              width: 40.w,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                color: backgroundColor,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{

  RPSCustomPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color =  color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;



    /*Path path0 = Path();
    path0.moveTo(0, 0);
    path0.quadraticBezierTo(0, size.width * 0.5, size.width * 0.5, size.width * 0.5);
    path0.quadraticBezierTo(size.width, size.width * 0.5, size.width, 0);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, 0 );
    path0.close();*/
    
    double width= size.width;
    double height = size.height;
    
    Path path0 = Path()
        //Startet bei 20% der Breite und auf 0 % der Höhe
      ..moveTo(0, 0)
      ..arcToPoint(
        //Der arcToPoint geht bis zum ende der Breite bleibt aber auf der Höhe 0
        Offset(width, 0),
        radius: Radius.circular((width / pi) / 2),
        clockwise: false,
      )
      ..lineTo(width, height)
      ..lineTo(0, height);

    
/*
    Path path0 = Path()
      ..moveTo(20, 0)
      ..arcToPoint(
        Offset(70, 0),
        radius: Radius.circular(10),
        clockwise: false,
      )
      ..lineTo(70, 40)
      ..lineTo(20, 40)
      ..lineTo(20, 0);*/

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

