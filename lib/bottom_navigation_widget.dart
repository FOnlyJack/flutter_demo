import 'package:flutter/material.dart';
import 'package:flutter_demo/config/GlobalConfig.dart';
import 'package:flutter_demo/eventbus/eventBus.dart';
import 'package:flutter_demo/pages/my_screen.dart';
import 'package:flutter_demo/pages/project_screen.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pages/home_screen.dart';
import 'pages/navigation_screen.dart';
import 'pages/official_account_screen.dart';
import 'pages/system_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigationWidget extends StatelessWidget {
  static var _bottomNavigationColor = Colors.blue;
  final List<Widget> tabBodies = [
    HomeScreen(),
    SystemScreen(),
    OfficialAccountScreen(),
    NavigationScreen(),
    ProjectScreen(),
    MyScreen()
  ];
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          color: GlobalConfig.dark
              ? GlobalConfig.fontColor
              : _bottomNavigationColor,
        ),
        title: Text(
          '首页',
          style: TextStyle(
              color: GlobalConfig.dark
                  ? GlobalConfig.fontColor
                  : _bottomNavigationColor),
        )),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.wb_cloudy,
          color: GlobalConfig.dark
              ? GlobalConfig.fontColor
              : _bottomNavigationColor,
        ),
        title: Text(
          '体系',
          style: TextStyle(
              color: GlobalConfig.dark
                  ? GlobalConfig.fontColor
                  : _bottomNavigationColor),
        )),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.donut_large,
          color: GlobalConfig.dark
              ? GlobalConfig.fontColor
              : _bottomNavigationColor,
        ),
        title: Text(
          '公众号',
          style: TextStyle(
              color: GlobalConfig.dark
                  ? GlobalConfig.fontColor
                  : _bottomNavigationColor),
        )),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.navigation,
          color: GlobalConfig.dark
              ? GlobalConfig.fontColor
              : _bottomNavigationColor,
        ),
        title: Text(
          '导航',
          style: TextStyle(
              color: GlobalConfig.dark
                  ? GlobalConfig.fontColor
                  : _bottomNavigationColor),
        )),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.pets,
          color: GlobalConfig.dark
              ? GlobalConfig.fontColor
              : _bottomNavigationColor,
        ),
        title: Text(
          '项目',
          style: TextStyle(
              color: GlobalConfig.dark
                  ? GlobalConfig.fontColor
                  : _bottomNavigationColor),
        )),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.perm_identity,
          color: GlobalConfig.dark
              ? GlobalConfig.fontColor
              : _bottomNavigationColor,
        ),
        title: Text(
          '我的',
          style: TextStyle(
              color: GlobalConfig.dark
                  ? GlobalConfig.fontColor
                  : _bottomNavigationColor),
        )),
  ];



  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);
    return Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return MaterialApp(
          theme: GlobalConfig.themeData,
          home: Scaffold(
            body: IndexedStack(
              index: model.getPageIndex,
              children: tabBodies,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: GlobalConfig.cardBackgroundColor,
              items: bottomTabs,
              currentIndex: model.getPageIndex,
              onTap: (index) {
                Provider.of<BottomCatModel>(context).setPageIndex(index);
              },
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
    );
  }
}
