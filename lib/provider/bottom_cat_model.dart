import 'package:flutter/material.dart';

class BottomCatModel with ChangeNotifier {
  int _pageindex = 0; //首页底部tab切换
  int _navigationindex =1; //导航左侧菜单位置

  bool _dark = false;

  bool get dark => _dark; //是否是夜间模式
  ThemeData _themeData = ThemeData(
    primaryColor: Color(0xff2196f3),
    scaffoldBackgroundColor: Color(0xFFEBEBEB),
  );
  Color _searchBackgroundColor = Color(0xFFEBEBEB);
  Color _cardBackgroundColor = Colors.white;
  Color _fontColor = Colors.black54;

  int get getPageIndex => _pageindex;

  ThemeData get themeData => _themeData;

  Color get searchBackgroundColor => _searchBackgroundColor;

  Color get fontColor => _fontColor;

  Color get cardBackgroundColor => _cardBackgroundColor;

  int get navigationindex => _navigationindex;

  ///首页底部切换状态
  void setPageIndex(int currentIndex) {
    _pageindex = currentIndex;
    notifyListeners();
  }
  ///导航左侧菜单位置
  void setNavigationIndex(int currentIndex) {
    _navigationindex = currentIndex;
    notifyListeners();
  }
  ///夜间模式切换状态
  void setNightMode(bool dark) {
    if (dark) {
      _themeData = ThemeData(
        primaryColor: Color(0xff2196f3),
        scaffoldBackgroundColor: Color(0xFFEBEBEB),
      );
      _searchBackgroundColor = Color(0xFFEBEBEB);
      _cardBackgroundColor = Colors.white;
      _fontColor = Colors.black54;
      _dark = false;
    } else {
      _themeData = ThemeData.dark();
      _searchBackgroundColor = Colors.white10;
      _cardBackgroundColor = Color(0xFF222222);
      _fontColor = Colors.white30;
      _dark = true;
    }
    notifyListeners();
  }
}
