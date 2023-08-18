import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:listdo/home_page/models/category_colors.dart';
import 'package:sizer/sizer.dart';

import '../models/item.dart';

class ListItem extends StatefulWidget {
  const ListItem({super.key, required this.onTap, required this.item, required this.listColor});

  final VoidCallback onTap;
  final Item item;
  final Color listColor;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 4,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: widget.onTap,
          child: Row(
            children: [
              SizedBox(width: 3.w,),
              _profilePictures(),
              SizedBox(width: 4.w,),
              _itemName(),
              SizedBox(width: 3.w,),
              _itemAmount(),
              _itemPrice(),
              SizedBox(width: 5.w,),
              _categoryIndicator()
            ],
          ),
        ),
      ),
    );
  }


  Widget _profilePictures() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.black,
          width: 2.0
        )
      ),
      height: 7.w,
      width: 7.w,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            // TODO : Leute ein Item als zuständigem hinzufügen oder Abhaken
            // TODO : Noch überlegen was an der Stelle eher passt
          },
        ),
      ),
    );
  }

  Widget _itemName() {
    return SizedBox(
      width: 30.w,
      child: AutoSizeText(
        widget.item.itemName,
        overflow: TextOverflow.ellipsis,
        stepGranularity: 1,
        minFontSize: 7.sp.roundToDouble(),
        maxLines: 1,
        style: GoogleFonts.poppins(
            color: const Color(0xFF5A5A5A),
            fontSize: 12.sp.roundToDouble()
        ),
      ),
    );
  }

  Widget _itemAmount() {
    return SizedBox(
      height: 7.w,
      width: 7.w,
      child: Material(
        color: widget.listColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            // TODO : Popup bei dem man die Anzahl verändern kann
          },
          child: Center(
            child: Text(
              widget.item.amount.toString(),
              style: GoogleFonts.poppins(
                color: const Color(0xFF5A5A5A),
                fontSize: 12.sp
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemPrice() {

    late String formattedPrice;
    double totalPrice = widget.item.price * widget.item.amount;

    if (totalPrice <= 9999.99) {
      formattedPrice = NumberFormat("###,##0.00").format(totalPrice);
    } else {
      formattedPrice = "9999,99+";
    }

    return SizedBox(
      width: 28.w,
      child: Row(
        children: [
          const Spacer(),
          AutoSizeText(
            '$formattedPrice €',
            minFontSize: 10.sp.roundToDouble(),
            stepGranularity: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: const Color(0xFF5A5A5A),
              fontSize: 12.sp.roundToDouble()
            ),
          ),
        ],
      ),
    );
  }


  Widget _categoryIndicator() {
    Color? indicator = CategoryColors.returnColorByCategoryID(widget.item.categoryID);
    return Container(
      height: 8.h,
      width: 3.w,
      decoration: BoxDecoration(
        color: indicator,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))
      ),
    );
  }

}
