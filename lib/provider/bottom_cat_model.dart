import 'package:flutter/material.dart';

class BottomCatModel with ChangeNotifier {
  int _pageindex = 0;
  int _navigationindex = 1;
  bool _dark = false;
  bool _isShowActionButton = true;
  double _opacity = 1.0;

  ThemeData _themeData = ThemeData(
    primaryColor: Color(0xff2196f3),
    scaffoldBackgroundColor: Color(0xFFEBEBEB),
  );
  Color _searchBackgroundColor = Color(0xFFEBEBEB);
  Color _cardBackgroundColor = Colors.white;
  Color _fontColor = Colors.black87;
  Color _imgColor = Color(0xff2196f3);

  int get getPageIndex => _pageindex;

  ThemeData get themeData => _themeData;

  Color get searchBackgroundColor => _searchBackgroundColor;

  Color get fontColor => _fontColor;

  Color get cardBackgroundColor => _cardBackgroundColor;

  int get navigationindex => _navigationindex;

  Color get imageColor => _imgColor;

  bool get isShowActionButton => _isShowActionButton;

  double get opacity => _opacity;

  bool get dark => _dark;

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
      _fontColor = Colors.black87;
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

  ///设置首页背景颜色
  void setImageColor(Color color) {
    _imgColor = color ?? Color(0xff2196f3);
    notifyListeners();
  }

  ///控制首页浮动按钮显示和隐藏
  void setIsShowActionButton(bool param) {
    _isShowActionButton = param;
    notifyListeners();
  }

  ///设置首页背景透明度变化
  void setOpacity(double t) {
    _opacity = t;
    notifyListeners();
  }
}
