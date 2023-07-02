import 'dart:ui';

class CustomList {

  late int _listID;
  late String _createdAt;
  late Color _listColor;
  late String _listName;
  late String _listEmoji;
  late int _ownerID;



  CustomList(this._listID, this._listName, this._listColor, this._listEmoji, this._createdAt, this._ownerID);

  int getListID() {
    return _listID;
  }

  void setListID(int listID) {
    _listID = listID;
  }

  Color getListColor() {
    return _listColor;
  }

  void setListColor(Color color) {
    _listColor = color;
  }



  String getListName() {
    return _listName;
  }

  void setlistName(String name) {
    _listName = name;
  }

  String getEmoji() {
    return _listEmoji;
  }

  void setlistEmoji(String emoji) {
    _listEmoji = emoji;
  }

  String getCreateAt() {
    return _createdAt;
  }

  int getOwnerID() {
    return _ownerID;
  }


}