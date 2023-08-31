import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:listdo/list_page/screens/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ListWidget extends StatelessWidget {
  ListWidget({Key? key, required this.list}) : super(key: key);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final CustomList list;

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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ListPage(list: list),), (route) => false,
            );
          },
          child: FutureBuilder(
            future: _isUserListOwner(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Center(child: _baseWidget()),
                    if(snapshot.data == true) _isOwnedWidget()
                  ],
                );
              }
              else {
                return const Center(child: Text("Fehler!"));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _baseWidget() {
    return Column(
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
    );
  }

  Widget _isOwnedWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 3.w, top: 2.w),
      child: Align(
        alignment: Alignment.topRight,
        child: Icon(
          FontAwesome5.crown,   //TODO : Choose better Icon
          color: Colors.black,
          size: 16.sp,
        ),
      ),
    );
  }


  Future<bool> _isUserListOwner() async {
    Future<bool> isOwner = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('userID') == list.getOwnerID();
    });
  return isOwner;
}
}