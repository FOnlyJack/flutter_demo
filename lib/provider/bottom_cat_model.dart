import 'package:flutter/material.dart';
class BottomCatModel with ChangeNotifier{
  int _pageindex =0;

  int get getPageIndex => _pageindex;

  void setPageIndex(int currentIndex) {
    _pageindex = currentIndex;
    notifyListeners();
  }
}