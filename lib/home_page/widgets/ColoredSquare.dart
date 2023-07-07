import 'package:flutter/material.dart';

class ColoredSquare extends StatefulWidget {
  const ColoredSquare({Key? key, required this.color, required this.size, this.onTap}) : super(key: key);

  final Color color;
  final double size;
  final VoidCallback? onTap;


  @override
  State<ColoredSquare> createState() => ColoredSquareState();
}

class ColoredSquareState extends State<ColoredSquare> {

  bool _isItemSelected = false;
  late Color color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color = widget.color;
  }

  Color getColor() {
    return color;
  }

  void changeStatus() {
    setState(() {
      _isItemSelected = !_isItemSelected;
    });
  }

  void unSelectItem() {
    setState(() {
      _isItemSelected = false;
    });
  }

  void selectItem () {
    setState(() {
      _isItemSelected = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isItemSelected ? const Color(0xFF494949) : Colors.transparent,
          width: 4,
        ),
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),

      child: Material(
        color: widget.color,

        child: InkWell(
            onTap: () {
              widget.onTap!();
            }
        ),
      ),
    );
  }
}

