import 'package:flutter/material.dart';
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

  final pageController = PageController();
  final List<Widget> tabBodies = [
    HomeScreen(),
    SystemScreen(),
    OfficialAccountScreen(),
    NavigationScreen(),
    ProjectScreen(),
    MyScreen()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);
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
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      '首页',
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.wb_cloudy,
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      '体系',
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.donut_large,
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      '公众号',
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.navigation,
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      '导航',
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.pets,
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      '项目',
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.perm_identity,
                      color:
                          model.dark ? model.fontColor : _bottomNavigationColor,
                    ),
                    title: Text(
                      '我的',
                      style: TextStyle(
                          color: model.dark
                              ? model.fontColor
                              : _bottomNavigationColor),
                    )),
              ],
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
