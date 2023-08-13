import 'package:flutter/material.dart';
import 'package:listdo/home_page/models/CustomListModel.dart';
import 'package:listdo/list_page/screens/components/listpage_app_bar.dart';
import 'package:sizer/sizer.dart';


class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final CustomList list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListPageAppBar(
              listColor: list.getListColor(),
              listName: list.getListName(),
              height: 20.h
          )
        ],
      ),
    );
  }
}
