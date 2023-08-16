import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/screens/home_page.dart';
import 'package:sizer/sizer.dart';

class ListPageAppBar extends StatelessWidget {
  const ListPageAppBar(
      {super.key,
      required this.listColor,
      required this.listName,});

  final Color listColor;
  final String listName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.h,
      width: 100.w,
      child: Material(
        elevation: 5,
        color: listColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 1.h, left: 6.w, right: 6.w),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      splashRadius: 18.sp,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      // TODO : Responsiv machen mit AutoSizeText
                      child: AutoSizeText(
                        listName,
                        minFontSize: 14.sp.roundToDouble(),
                        stepGranularity: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      splashRadius: 18.sp,
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(
                        Icons.dehaze,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
