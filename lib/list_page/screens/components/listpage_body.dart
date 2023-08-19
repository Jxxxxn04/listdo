import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listdo/list_page/providers/item_provider.dart';
import 'package:listdo/widgets/ListItem.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../api.dart';
import '../../models/item.dart';

class ListPageBody extends StatelessWidget {
  ListPageBody({super.key, required this.listColor, required this.listID});

  final Color listColor;
  final int listID;
  final Api api = Api();

  /*static List<Item> testItems = [
    Item(2, 2, 2, false, "Hallo", "Bye", "blub", 3, 34.3, 4),
    Item(2, 2, 2, false, "Hallo2", "Bye", "blub", 7, 34.3, 2),
    Item(2, 2, 2, false, "Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3", "Bye", "blub", 75, 2.30, 4),
    Item(2, 2, 2, false, "Hallo4Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3", "Bye", "blub", 0, 1, 1),
    Item(2, 2, 2, false, "Hallo5Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3Hallo3", "Bye", "blub", 64, 203, 2),
    Item(2, 2, 2, false, "Hallo6Hallo3Hallo3Hallo3Hallo3", "Bye", "blub", 64, 9999, 8),
    Item(2, 2, 2, false, "Hallo7Hallo3Hallo3", "Bye", "blub", 64, 34.3, 3),
    Item(2, 2, 2, false, "Hallo8", "Bye", "blub", 6, 34.3, 7),
    Item(2, 2, 2, false, "Hallo9", "Bye", "blub", 642, 34.3, 2),
    Item(2, 2, 2, false, "Hallo22", "Bye", "blub", 1, 34.3, 1),
    Item(2, 2, 2, false, "Hallo33", "Bye", "blub", 84, 34.3, 5),
    Item(2, 2, 2, false, "Hallo44", "Bye", "blub", 5, 34.3, 6),
    Item(2, 2, 2, false, "Hallo55", "Bye", "blub", 9, 34.3, 3),
    Item(2, 2, 2, false, "Hallo66", "Bye", "blub", 23, 34.3, 7),
  ];*/

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).clearItems();
      Provider.of<ItemProvider>(context, listen: false).resetTotalPrice();
    });

    return SizedBox(
      height: 62.h,
      child: FutureBuilder(
        future: api.getItemsFromList(listID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _waitWidget();
          } else if (snapshot.hasError) {
            return _errorWidget(snapshot.error);
          } else if (snapshot.hasData) {

            Map<String, dynamic> response =
              json.decode(snapshot.data!.body.toString());

            bool isEmpty = response['isEmpty'];
            List<dynamic> itemsData = response['items'];

            for (var itemData in itemsData) {
              Item newItem = Item(
                itemData['itemID'],
                itemData['listID'],
                itemData['userID'],
                itemData['assignedTo'],
                itemData['isItemCompleted'] == 1,   // If isItemCompleted true in the Database it will send a 1 so we will need to check wheather 1 is equal to 1
                itemData['itemName'],
                itemData['itemDisc'],
                itemData['created_at'],
                itemData['amount'],
                itemData['price'].toDouble(),
                itemData['categoryID'],
              );

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<ItemProvider>(context, listen: false).addItem(newItem);
              });
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<ItemProvider>(context, listen: false).reloadTotalPrice();
            });


            return _hasDataWidget(context);
          } else {
            return _waitWidget();
          }
        },
      ),
    );
  }

  Widget _errorWidget(Object? error) {
    return SafeArea(child: Text(error.toString()));
  }

  Widget _waitWidget() {
    return Center(
      child: SizedBox(
        height: 5.h,
        width: 5.h,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _hasDataWidget(BuildContext context) {
    List<Item> items = Provider.of<ItemProvider>(context, listen: false).items;

    return Consumer<ItemProvider>(
      builder: (context, value, child) => ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
        separatorBuilder: (context, index) => SizedBox(height: 1.5.h,),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListItem(onTap: () {}, item: items[index], listColor: listColor, index: index,);
        },
      ),
    );
  }

  Future<String> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return "Daten sind angekommen";
  }
}
