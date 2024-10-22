import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:listdo/list_page/providers/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ListPageTotalPrice extends StatefulWidget {
  const ListPageTotalPrice(
      {super.key, required this.totalPrice, required this.listColor});

  final double totalPrice;
  final Color listColor;

  @override
  State<ListPageTotalPrice> createState() => _ListPageTotalPriceState();
}

class _ListPageTotalPriceState extends State<ListPageTotalPrice> {



  @override
  Widget build(BuildContext context) {

    double totalPrice = Provider.of<ItemProvider>(context).totalPrice;

    final formattedPrice = NumberFormat.currency(
      symbol: '€',
      decimalDigits: 2,
      locale: 'de_DE', // Pass appropriate locale
    ).format(totalPrice);

    return Container(
      height: 12.h,
      width: 100.w,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: Offset(0,-1),
          )
        ]
      ),
      child: Container(
        height: 12.h,
        width: 100.w,
        color: const Color(0xFFF0F0F0),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: SizedBox(
              height: 7.h,
              width: 90.w,
              child: Material(
                color: widget.listColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Summe:",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF5A5A5A), fontSize: 13.sp),
                          ),
                        ),
                        const Spacer(),
                        Consumer<ItemProvider>(
                          builder: (context, value, child) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                formattedPrice,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF5A5A5A),
                                    fontSize: 13.sp),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
