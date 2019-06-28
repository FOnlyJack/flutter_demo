import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/config/GlobalConfig.dart';
import 'package:flutter_demo/mode/CommonWebBean.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';

class CommonWebPage extends StatefulWidget {
  @override
  _Common_Web_State createState() {
    return _Common_Web_State();
  }
}

class _Common_Web_State extends State<CommonWebPage> {
  List<Data> _list = List();

  @override
  void initState() {
    super.initState();
    getCommonWebData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("常用网站",style: TextStyle(
          color: GlobalConfig.fontColor
        ),),
      ),
      body: SafeArea(
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            alignment: WrapAlignment.spaceAround,
            direction: Axis.horizontal,
            verticalDirection: VerticalDirection.down,
            children: List.generate(_list.length, (i) {
              var random = Random(i);
              var _color = Color.fromRGBO(random.nextInt(255),
                  random.nextInt(255), random.nextInt(255), GlobalConfig.dark?0.2:1);
              return FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ArticleDetailPage(
                        title: _list[i].name, url: _list[i].link);
                  }));
                },
                child: Text(_list[i].name,style: TextStyle(
                  color: GlobalConfig.fontColor
                ),),
                color: _color,
                textColor:GlobalConfig.fontColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: _color,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5)),
              );
            }),
          )),
    );
  }

  getCommonWebData() async {
    Dio dio = new Dio();
    Response response = await dio.get("https://www.wanandroid.com/friend/json");
    if (response != null) {
      CommonWebBean commonWebBean = CommonWebBean.fromJson(response.data);
      List<Data> list = commonWebBean.data;
      setState(() {
        _list.clear();
        _list.addAll(list);
      });
    }
  }
}
