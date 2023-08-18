import 'package:flutter/material.dart';
import 'package:listdo/widgets/inkwell_button.dart';
import 'package:sizer/sizer.dart';

class ListPageNavigationbarOverlay extends StatefulWidget {
  const ListPageNavigationbarOverlay({Key? key, required this.listColor})
      : super(key: key);

  final Color listColor;

  @override
  State<ListPageNavigationbarOverlay> createState() =>
      _ListPageNavigationbarOverlayState();
}

class _ListPageNavigationbarOverlayState
    extends State<ListPageNavigationbarOverlay> {
  bool _leftSideActive = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11.h,
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomInkWellButton(
            height: 7.h,
            width: 7.h,
            onTap: () {
             setState(() {
               _leftSideActive = true;
             });
            },
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              Icons.list,
              color: _leftSideActive ? widget.listColor : Colors.white,
              size: 36.sp,
            ),
          ),

          SizedBox(width: 5.w,),

          CustomInkWellButton(
            height: 7.h,
            width: 7.h,
            onTap: () {
              setState(() {
                _leftSideActive = false;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              Icons.book,
              color: _leftSideActive ? Colors.white : widget.listColor,
              size: 36.sp,
            ),
          ),
        ],
      ),
    );
  }
}
