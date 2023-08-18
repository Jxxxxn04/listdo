import 'package:flutter/material.dart';

import '../../widgets/ListWidget.dart';


class ListProvider extends ChangeNotifier {

  List<ListWidget> _lists = [];


  List<ListWidget> get lists => _lists;

  void addMultipleLists(List<ListWidget> lists) {
    _lists.addAll(lists);
    notifyListeners();
  }

  void addList(ListWidget newList) {
    _lists.add(newList);
    notifyListeners();
  }

  void removeList(int position) {
    _lists.removeAt(position);
    notifyListeners();
  }

  void clearList() {
    _lists.clear();
    notifyListeners();
  }

}