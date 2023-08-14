import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class ListPageSearchButton extends StatefulWidget {
  const ListPageSearchButton({super.key, required this.listColor, required this.height, required this.width});

  final Color listColor;
  final double height;
  final double width;

  @override
  State<ListPageSearchButton> createState() => _ListPageSearchButtonState();
}

class _ListPageSearchButtonState extends State<ListPageSearchButton> {

  bool _isExtended = false;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Material(
        elevation: 5,
        color: widget.listColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: InkWell(
          onTap: changeStatus,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          child: Center(
            child: AnimatedCrossFade(
                firstChild: Icon(Icons.arrow_upward_outlined, color: Colors.white, size: 18.sp,),
                secondChild: Icon(Icons.arrow_downward_outlined, color: Colors.white, size: 18.sp,),
                crossFadeState: _isExtended ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 250)),
          ),
        ),
      ),
    );
  }

  void changeStatus() {
    setState(() {
      _isExtended = !_isExtended;
    });
  }

  void extendSearchContainer() {

  }

  void shrinkSearchContainer() {

  }



}