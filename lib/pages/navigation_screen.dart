import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/mode/NavigationDetailBean.dart';
import 'package:flutter_demo/eventbus/eventBus.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';
import 'package:event_bus/event_bus.dart';

/**
 * 导航
 */
class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<NavigationScreen> {
  List<Data> _listData = [];

  @override
  void initState() {
    super.initState();
    getNavigationData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "导航",
          style: TextStyle(color: GlobalConfig.fontColor),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SearchPage();
              }));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child:
                  Icon(Icons.search, color: GlobalConfig.fontColor, size: 20.0),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Offstage(
        offstage: _listData.length == 0,
        child: Container(
          child: Row(
            children: <Widget>[
              LeftCategoryNav(_listData),
              CategoryGoodsList(_listData)
            ],
          ),
        ),
      )),
    );
  }

  void getNavigationData() async {
    Dio dio = new Dio();
    Response response = await dio.get("https://www.wanandroid.com/navi/json");
    if (response != null) {
      NavigationDetailBean navigationDetailBean =
          NavigationDetailBean.fromJson(response.data);
      List<Data> list = navigationDetailBean.data;
      if (list != null && list.length > 0) {
        setState(() {
          _listData = list;
        });
      }
    }
  }
}

/**
 * 右侧数据列表
 */
class CategoryGoodsList extends StatefulWidget {
  List<Data> _rightNavData;

  CategoryGoodsList(this._rightNavData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoryRightState();
  }
}

class _CategoryRightState extends State<CategoryGoodsList> {
  int _leftIndex = 0;

  @override
  void initState() {
    super.initState();
    eventBus
        .on<NavigationEvent>()
        .listen((NavigationEvent data) => show(data.index));
  }

  void show(int val) {
    setState(() {
      _leftIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        child: Text(widget._rightNavData[_leftIndex].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: GlobalConfig.fontColor,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Wrap(
                    spacing: 3,
                    runSpacing: 1,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                        widget._rightNavData[_leftIndex].articles.length, (i) {
                      var random = Random(i + _leftIndex);
                      var _color = Color.fromRGBO(
                          random.nextInt(255),
                          random.nextInt(255),
                          random.nextInt(255),
                          GlobalConfig.dark ? 0.2 : 1);
                      return FlatButton(
                        onPressed: () => {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ArticleDetailPage(
                                    title: widget._rightNavData[_leftIndex]
                                        .articles[i].title,
                                    url: widget._rightNavData[_leftIndex]
                                        .articles[i].link);
                              }))
                            },
                        child: Text(
                          widget._rightNavData[_leftIndex].articles[i].title,
                          style: TextStyle(
                              fontSize: 14, color: GlobalConfig.fontColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        color: _color,
                        textColor: GlobalConfig.fontColor,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: _color,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                      );
                    }),
                  )
                ],
              ),
            )));
  }
}

/**
 * 左侧导航
 */
class LeftCategoryNav extends StatefulWidget {
  List<Data> _leftNavData;

  LeftCategoryNav(this._leftNavData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LeftCategoryNavState();
  }
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  bool isClick = false;
  var listIndex = 0; //索引

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 100,
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: widget._leftNavData.length,
        itemBuilder: (context, index) {
          isClick = (index == listIndex) ? true : false;
          return InkWell(
            onTap: () {
              eventBus.fire(NavigationEvent(index));
              setState(() {
                listIndex = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                  color: isClick
                      ? GlobalConfig.searchBackgroundColor
                      : GlobalConfig.cardBackgroundColor,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12))),
              child: Text(
                widget._leftNavData[index].name,
                style: TextStyle(fontSize: 16, color: GlobalConfig.fontColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
