import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:sizer/sizer.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({Key? key, required this.list, this.onTap}) : super(key: key);

  final CustomList list;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    //int emoji = int.parse(list.getEmoji());
    //emoji = int.parse("0x") + emoji;
    return Container(
      decoration: BoxDecoration(
          color: list.getListColor(),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: list.getListColor(),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            //print(String.fromCharCode(emoji));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 2.5.h, 4.w, 0.0),
                    child: Text(
                      list.getEmoji(),
                      style: TextStyle(
                          fontSize: 45.sp,
                      ),
                    ),
                  )
              ),


              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 0.0, 4.w, 0.0),
                  child: AutoSizeText(
                    list.getListName(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    stepGranularity: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 12.sp.roundToDouble(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}