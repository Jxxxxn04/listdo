import 'package:flutter/cupertino.dart';

import '../models/item.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  double totalPrice = 0;

  void addMultipleItems(List<Item> items) {
    _items.addAll(items);
    notifyListeners();
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  void reloadTotalPrice() {
    for(int i = 0; i < _items.length; i++) {
      totalPrice += _items[i].price * _items[i].amount;
    }
    notifyListeners();
  }

  void resetTotalPrice() {
    totalPrice = 0;
    notifyListeners();
  }

  void setNewTotalPrice(double newPrice) {
    totalPrice = newPrice;
    notifyListeners();
  }

  void addPriceToTotalPrice(double price) {
    totalPrice += price;
    notifyListeners();
  }

  void refreshList() => notifyListeners();
}