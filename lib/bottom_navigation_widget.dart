import 'package:flutter/material.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/eventbus/eventBus.dart';
import 'package:flutter_demo/pages/my_screen.dart';
import 'package:flutter_demo/pages/project_screen.dart';

import 'pages/home_screen.dart';
import 'pages/navigation_screen.dart';
import 'pages/official_account_screen.dart';
import 'pages/system_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  var _bottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    super.initState();
    list
      ..clear()
      ..add(HomeScreen())
      ..add(SystemScreen())
      ..add(OfficialAccountScreen())
      ..add(NavigationScreen())
      ..add(ProjectScreen())
      ..add(MyScreen());
    eventBus
        .on<NightPatternEvent>()
        .listen((NightPatternEvent data) => show(data.isNight));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalConfig.themeData,
      home: Scaffold(
        body: list[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: GlobalConfig.cardBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor,
                ),
                title: Text(
                  '首页',
                  style: TextStyle(color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.wb_cloudy,
                  color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor,
                ),
                title: Text(
                  '体系',
                  style: TextStyle(color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.donut_large,
                  color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor,
                ),
                title: Text(
                  '公众号',
                  style: TextStyle(color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.navigation,
                  color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor,
                ),
                title: Text(
                  '导航',
                  style: TextStyle(color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.pets,
                  color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor,
                ),
                title: Text(
                  '项目',
                  style: TextStyle(color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.perm_identity,
                  color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor,
                ),
                title: Text(
                  '我的',
                  style: TextStyle(color: GlobalConfig.dark?GlobalConfig.fontColor:_bottomNavigationColor),
                )),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  show(bool index) {
    setState(() {
      print(index);
    });
  }
}
