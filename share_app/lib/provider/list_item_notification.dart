import 'package:flutter/material.dart';
class ListItemNotification with ChangeNotifier{
  ///文章id
  String _id="";

  ///是否兑换了文章
  bool _isExchange=false;

  bool get isExchange=>_isExchange;
  String get id=>_id;

  void updateStatusById(String id,bool status){
      _id=id;
      _isExchange=status;
      print("更新状态：${id}+${status}");
      notifyListeners();

  }
}