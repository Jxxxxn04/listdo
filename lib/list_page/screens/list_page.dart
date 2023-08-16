import 'package:flutter/material.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:listdo/home_page/screens/home_page.dart';
import 'package:listdo/list_page/screens/components/listpage_app_bar.dart';
import 'package:listdo/list_page/screens/components/listpage_search_button.dart';
import 'package:sizer/sizer.dart';


class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final CustomList list;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),), (route) => false);
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            ListPageAppBar( // height = 15.h, width = 100.w
                listColor: list.getListColor(),
                listName: list.getListName(),
            ),
            Center(
              child: ListPageSearchButton( // height for the search_bar_button is 3.h, width is 35.w
                  listColor: list.getListColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
