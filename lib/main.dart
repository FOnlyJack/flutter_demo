import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/bottom_navigation_widget.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:provider/provider.dart';

import 'routers/app.dart';
import 'routers/routers.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;



  // 注册 fluro routes
  Router router = Router();
  Routers.configureRoutes(router);
  App.router = router;

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
      onGenerateRoute: App.router.generator,
      home:MultiProvider(providers: [
        ChangeNotifierProvider(
          builder:(_)=> BottomCatModel(),
        )
      ], child: BottomNavigationWidget(),),
    );
  }
}
