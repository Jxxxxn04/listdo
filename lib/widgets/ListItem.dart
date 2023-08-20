import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:listdo/Global_Classes/timer_handler.dart';
import 'package:listdo/home_page/models/category_colors.dart';
import 'package:listdo/list_page/providers/item_provider.dart';
import 'package:listdo/widgets/inkwell_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../api.dart';
import '../list_page/models/item.dart';

class ListItem extends StatefulWidget {
  const ListItem({super.key, required this.onTap, required this.item, required this.listColor, required this.index});

  final VoidCallback onTap;
  final Item item;
  final Color listColor;
  final int index;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  late int userID;
  bool _isAssignedToUser = false;
  bool _isPoppedUp = false;
  Color backgroundColor = Colors.white;
  TimerHandler timerHandler = TimerHandler(const Duration(seconds: 2));
  Api api = Api();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefValue) => {
      setState(() {
        userID = prefValue.getInt('userID')?? "" as int;
        _isAssignedToUser = userID == widget.item.assignedTo;
      })
    });
    super.initState();
  }

  void changeAmount(int newAmount) {
    if (newAmount < 1 || newAmount > 99){
      return;
    }
    api.changeItemAmount(widget.item.itemID, newAmount);
    setState(() {
      widget.item.amount = newAmount;
    });
    Provider.of<ItemProvider>(context, listen: false).changeAmountFromIndex(widget.index, newAmount);
    Provider.of<ItemProvider>(context, listen: false).reloadTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: 8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: widget.onTap,
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(width: 3.w,),
                  _profilePictures(),
                  SizedBox(width: 4.w,),
                  _itemName(),
                  if(_isAssignedToUser) SizedBox(width: 1.5.w,),
                  if(_isAssignedToUser) _assignedToIcon(),
                  SizedBox(width: _isAssignedToUser ? 1.5.w : 3.w,),
                  _placeHolderWidget(),
                  _itemPrice(),
                  SizedBox(width: 5.w,),
                  _categoryIndicator()
                ],
              ),
              Positioned(left: 37.w, top: 2.25.h, child: _amountChangerWidget()),
              Positioned(left: 48.w, bottom: 2.25.h, top: 2.25.h, child: _itemAmount()),
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
      width: _isAssignedToUser ? 24.w : 30.w,
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

  Widget _placeHolderWidget() => SizedBox(height: 7.w, width: 7.w,);

  Widget _itemAmount() {
    return SizedBox(
      height: 3.5.h,
      width: 3.5.h,
      child: Material(
        color: widget.listColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            setState(() {
              _isPoppedUp = true;
              timerHandler.startTimer(() {
                setState(() {
                  _isPoppedUp = false;
                });
              });
            });
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
      formattedPrice = NumberFormat.currency(
        symbol: '€',
        decimalDigits: 2,
        locale: 'de_DE', // Pass appropriate locale
      ).format(totalPrice);
    } else {
      formattedPrice = "9999,99+ €";
    }

    return SizedBox(
      width: 28.w,
      child: Row(
        children: [
          const Spacer(),
          AutoSizeText(
            formattedPrice,
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

  Widget _assignedToIcon() {
    return SizedBox(
      height: 5.w,
      width: 6.w,
      child: Center(
        child: Icon(
          FontAwesome5.tag,
          color: const Color(0xffFFC700),
          size: 14.sp,
        ),
      ),
    );
  }

  Widget _amountChangerWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
      width: _isPoppedUp ? 14.h : 0,
      height: _isPoppedUp ? 3.5.h : 0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.listColor,
      ),
      child: _isPoppedUp
          ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomInkWellButton(
                        height: 3.h,
                        width: 3.h,
                        color: const Color(0xFF4E4E4E),
                        onTap: () {
                          timerHandler.restartTimer();
                          changeAmount(widget.item.amount - 1);
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Icon(
                          Icons.remove,
                          color: widget.listColor.withOpacity(0.2),
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.h,),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomInkWellButton(
                        height: 3.h,
                        width: 3.h,
                        color: const Color(0xFF4E4E4E),
                        onTap: () {
                          timerHandler.restartTimer();
                          changeAmount(widget.item.amount + 1);
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Icon(
                          Icons.add,
                          color: widget.listColor.withOpacity(0.2),
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          )
          : null,
    );
  }
}


