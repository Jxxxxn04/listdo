class Item {
  int itemID, userID, amount, categoryID;
  int? assignedTo;
  bool isItemCompleted;
  String itemName, itemDisc, createdAt;
  double price;
  late double totalPrice;

  Item(this.itemID, this.userID, this.assignedTo, this.isItemCompleted, this.itemName, this.itemDisc, this.createdAt, this.amount, this.price, this.categoryID) {
    totalPrice = price * amount;
  }
}