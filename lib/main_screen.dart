import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/pages/my_screen.dart';
import 'package:flutter_demo/pages/project_screen.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_screen.dart';
import 'pages/navigation_screen.dart';
import 'pages/official_account_screen.dart';
import 'pages/system_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _bottomNavigationColor = Colors.blue;

  final _buttomTitle = ["首页", "体系", "公众号", "导航", "项目", "我的"];
  final _buttomIcon = [
    Icons.home,
    Icons.wb_cloudy,
    Icons.donut_large,
    Icons.navigation,
    Icons.pets,
    Icons.perm_identity
  ];

  ///PageView控制器
  final pageController = PageController();

  ///底部菜单页面存储
  final List<Widget> tabBodies = [
    ///首页
    HomeScreen(),

    ///体系
    SystemScreen(),

    ///公众号
    OfficialAccountScreen(),

    ///导航
    NavigationScreen(),

    ///项目
    ProjectScreen(),

    ///我的
    MyScreen()
  ];
  @override
  void initState() {
    super.initState();
    init();
  }
  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<BottomCatModel>(context)
        .setNightMode(!prefs.getBool("is_dark") ?? false);
    Provider.of<BottomCatModel>(context)
        .setIsLogin(prefs.get("isLogin") ?? false);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return MaterialApp(
          theme: model.themeData,
          home: Scaffold(
            body: PageView(
                controller: pageController,
                children: tabBodies,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int index) {
                  Provider.of<BottomCatModel>(context).setPageIndex(index);
                }),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: model.cardBackgroundColor,
              items: List.generate(tabBodies.length, (i) {
                ///底部菜单item
                return BottomNavigationBarItem(
                    icon: Icon(
                      _buttomIcon[i],
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      _buttomTitle[i],
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    ));
              }),
              currentIndex: model.getPageIndex,
              onTap: (index) {
                pageController.jumpToPage(index);
              },
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
    );
  }
}
