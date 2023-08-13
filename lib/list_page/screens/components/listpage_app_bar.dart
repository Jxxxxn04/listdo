import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/screens/home_page.dart';
import 'package:sizer/sizer.dart';

class ListPageAppBar extends StatelessWidget {
  const ListPageAppBar(
      {super.key,
      required this.listColor,
      required this.listName,
      required this.height});

  final Color listColor;
  final String listName;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 100.w,
      child: Material(
        elevation: 5,
        color: listColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    goBack(context);
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.white,
                    size: 36.sp,
                  )),
              Text(
                listName,
                style: GoogleFonts.poppins(fontSize: 24.sp, color: Colors.white),
              ),
              IconButton(
                  onPressed: burgerIconFunction,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 44.sp,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void goBack(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(),)
    );
  }

  void burgerIconFunction() {
    // TODO : Funktion hinzufügen
  }
}
