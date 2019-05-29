import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/bottom_navigation_widget.dart';
import 'package:flutter_demo/pages/search_screen.dart';

void main() {
  runApp(MyApp());
  // 添加如下代码，使状态栏透明  沉浸式
  if (Platform.isAndroid) {
    var style = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: BottomNavigationWidget(),
    );
  }
}
