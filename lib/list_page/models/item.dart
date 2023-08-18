class Item {
  int itemID, userID, amount, categoryID, listID;
  int? assignedTo;
  bool isItemCompleted;
  String itemName, itemDisc, createdAt;
  double price;

  Item(
      this.itemID,
      this.listID,
      this.userID,
      this.assignedTo,
      this.isItemCompleted,
      this.itemName,
      this.itemDisc,
      this.createdAt,
      this.amount,
      this.price,
      this.categoryID);
}