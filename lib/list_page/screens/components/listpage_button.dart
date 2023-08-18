import 'package:flutter/material.dart';
import 'package:listdo/widgets/inkwell_button.dart';
import 'package:sizer/sizer.dart';

class ListPagebutton extends StatefulWidget {
  const ListPagebutton({Key? key, required this.listColor}) : super(key: key);

  final Color listColor;

  @override
  State<ListPagebutton> createState() => _ListPagebuttonState();
}

class _ListPagebuttonState extends State<ListPagebutton> {
  @override
  Widget build(BuildContext context) {
    return CustomInkWellButton(
      height: 17.w,
      width: 17.w,
      onTap: () {},
      borderRadius: BorderRadius.circular(100),
      color: widget.listColor,
      child: IconTheme(
        data: IconThemeData(
          size: 46.sp,

        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
