import 'package:flutter/material.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:listdo/home_page/screens/home_page.dart';
import 'package:listdo/list_page/screens/components/listpage_navigationbar_overlay.dart';
import 'package:listdo/widgets/home_page_widgets.dart';
import 'package:listdo/list_page/screens/components/listpage_app_bar.dart';
import 'package:listdo/list_page/screens/components/listpage_body.dart';
import 'package:listdo/list_page/screens/components/listpage_filter_button.dart';
import 'package:listdo/list_page/screens/components/listpage_totalprice.dart';
import 'package:sizer/sizer.dart';

import 'components/listpage_button.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final CustomList list;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
                (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: Stack(
          children: [
            Column(
              children: [
                ListPageAppBar(
                  // height = 15.h, width = 100.w
                  listColor: list.getListColor(),
                  listName: list.getListName(),
                ),

                Stack(
                  // Body of the ListPage
                  children: [
                    ListPageBody(
                      listColor: list.getListColor(), listID: list.getListID(),
                    ), // height = 74.h

                    ListPageFilterButton(
                      // height for the filter_button is 3.h, width is 35.w
                      listColor: list.getListColor(),
                    ),
                  ],
                ),
                ListPageTotalPrice(totalPrice: 2, listColor: list.getListColor()),
                Stack(children: [const RoundedNavigationBar(backgroundColor: Color(0xFF252525)), ListPageNavigationbarOverlay(listColor: list.getListColor())])
                //RoundedNavigationBar height is 11.h
              ],
            ),
            Positioned(left: 41.5.w, right: 41.5.w, bottom: 5.5.h, child: ListPagebutton(listColor: list.getListColor(),))
          ],
        ),
      ),
    );
  }

  Widget _line() =>
      Container(
        height: 0.1.h,
        width: 100.w,
        decoration: const BoxDecoration(color: Colors.transparent, boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: Offset(0, -1),
          )
        ])
        ,);
}