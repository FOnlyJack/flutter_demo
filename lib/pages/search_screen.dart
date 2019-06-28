import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/config/GlobalConfig.dart';
import 'package:flutter_demo/mode/HotSearchBean.dart';
import 'package:flutter_demo/pages/search_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<Data> _hotList = List();
  List<String> _historyList = List();
  String _searchContent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHotSearch().whenComplete(getSearchHistory);
    _textEditingController.addListener(() {
      _searchContent = _textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Hero(
              tag: "search",
              child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      autofocus: false,
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      textAlign: TextAlign.left,
                      cursorColor: GlobalConfig.fontColor,
                      style: TextStyle(
                          color: GlobalConfig.fontColor, fontSize: 16),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          suffix: Container(
                            height: 25,
                            width: 40,
                            alignment: Alignment.center,
                            child: FlatButton(
                              onPressed: () => {
                                    _textEditingController.clear(),
                                    _focusNode.unfocus()
                                  },
                              child: Text(
                                "x",
                                style: TextStyle(fontSize: 12),
                              ),
                              color: Colors.transparent,
                              textColor: GlobalConfig.fontColor,
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: GlobalConfig.fontColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "搜索关键词以空格隔开",
                          hintStyle: TextStyle(
                              color: GlobalConfig.fontColor, fontSize: 16),
                          border: InputBorder.none),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(3.0)),
                    color: GlobalConfig.searchBackgroundColor,
                  ))),
          actions: <Widget>[
            InkWell(
              onTap: () {
                if (_textEditingController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "搜索内容不能为空!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                  );
                } else {
                  startPageForResult(_textEditingController.text);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(Icons.search,
                    color: GlobalConfig.fontColor, size: 20.0),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            color: GlobalConfig.cardBackgroundColor,
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "热搜",
                      style: TextStyle(
                          fontSize: 20, color: GlobalConfig.dark?GlobalConfig.fontColor:Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 4,
                  runSpacing: 1,
                  alignment: WrapAlignment.start,
                  children: List.generate(_hotList.length, (i) {
                    var random = Random(i);
                    var _color = Color.fromRGBO(random.nextInt(255),
                        random.nextInt(255), random.nextInt(255), GlobalConfig.dark?0.2:1);
                    return FlatButton(
                      onPressed: () =>{
                        startPageForResult(_hotList[i].name)
                      },
                      child: Text(_hotList[i].name),
                      color: _color,
                      textColor: GlobalConfig.fontColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _color,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                    );
                  }),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text(
                          "搜索历史",
                          style: TextStyle(
                              fontSize: 20,
                              color: GlobalConfig.dark?GlobalConfig.fontColor:Theme.of(context).primaryColor),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    )),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          clearHistory();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.delete_forever,
                              size: 30,
                              color: GlobalConfig.fontColor,
                            ),
                            Text("清空",style: TextStyle(
                              color: GlobalConfig.fontColor
                            ),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Stack(
                    children: <Widget>[
                      Offstage(
                        offstage: _historyList.length != 0,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Text("暂无搜索数据!",style: TextStyle(
                            color: GlobalConfig.fontColor
                          ),),
                        ),
                      ),
                      Offstage(
                        offstage: _historyList.length == 0,
                        child: ListView.builder(
                            itemCount: _historyList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () =>
                                    {startPageForResult(_historyList[index])},
                                child: Container(
                                    height: 50,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.history,
                                                  size: 30,
                                                  color: GlobalConfig.fontColor,
                                                ),
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                _historyList[index],
                                                style: TextStyle(fontSize: 14,color: GlobalConfig.fontColor),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            }),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ));
  }

  Future getHotSearch() async {
    Dio dio = new Dio();
    Response response =
        await dio.get("https://www.wanandroid.com//hotkey/json");
    HotSearchBean hotSearchBean = HotSearchBean.fromJson(response.data);
    setState(() {
      _hotList.clear();
      _hotList.addAll(hotSearchBean.data);
    });
  }

  clearHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isContain = sharedPreferences.containsKey("historyList");
    if (isContain) {
      sharedPreferences.setStringList("historyList", []);
    }
    setState(() {
      _historyList.clear();
    });
  }

  getSearchHistory() async {
    List<String> history;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    history = sharedPreferences.getStringList("historyList");
    setState(() {
      _historyList.clear();
      _historyList.addAll(history);
    });
  }

  save() async {
    setState(() {
      _historyList.add(_searchContent);
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("historyList", _historyList);
  }

  startPageForResult(String str) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SearchDetailPage(
        searchStr: str,
      );
    })).then((result) {
      if (result != null) {
        _searchContent = result;
        save();
      }
    });
  }
}
