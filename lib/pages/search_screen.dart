import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/mode/HotSearchBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Hero(
                  tag: "search",
                  child: Container(
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(140),
                      margin: EdgeInsets.only(bottom: 5),
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          autofocus: false,
                          focusNode: _focusNode,
                          controller: _textEditingController,
                          textAlign: TextAlign.left,
                          cursorColor: model.fontColor,
                          style: TextStyle(
                              color: model.fontColor,
                              fontSize: ScreenUtil().setSp(40)),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              suffix: Container(
                                height: ScreenUtil().setHeight(60),
                                width: ScreenUtil().setWidth(120),
                                child: FlatButton(
                                  onPressed: () => {
                                    _textEditingController.clear(),
                                    _focusNode.unfocus()
                                  },
                                  child: Text(
                                    "x",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(24)),
                                  ),
                                  color: Colors.transparent,
                                  textColor: model.fontColor,
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: model.fontColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: "搜索关键词以空格隔开",
                              hintStyle: TextStyle(
                                  color: model.fontColor,
                                  fontSize: ScreenUtil().setSp(42)),
                              border: InputBorder.none),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(3.0)),
                        color: model.searchBackgroundColor,
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
                    child:
                        Icon(Icons.search, color: model.fontColor, size: 20.0),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: Container(
                color: model.cardBackgroundColor,
                padding: EdgeInsets.all(10),
                width: ScreenUtil().width,
                height: ScreenUtil().height,
                child: Column(
                  children: <Widget>[
                    _hotsearch(model),
                    _wraplist(model),
                    _searchhistory(model),
                    _searchhistorycontent(model),
                  ],
                ),
              ),
            ));
      },
    );
  }

  ///热搜
  Widget _hotsearch(BottomCatModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "热搜",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(48),
              color: model.dark
                  ? model.fontColor
                  : Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  ///热搜子项
  Widget _wraplist(BottomCatModel model) {
    if (_hotList.length != 0) {
      List<Widget> listWidget = List.generate(_hotList.length, (i) {
        var random = Random(i);
        var _color = Color.fromRGBO(random.nextInt(255), random.nextInt(255),
            random.nextInt(255), model.dark ? 0.2 : 1);
        return FlatButton(
          onPressed: () => {startPageForResult(_hotList[i].name)},
          child: Text(_hotList[i].name),
          color: _color,
          textColor: model.fontColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: _color,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5)),
        );
      });
      return Wrap(
        spacing: 4,
        runSpacing: 1,
        alignment: WrapAlignment.start,
        children: listWidget,
      );
    } else {
      return Text("");
    }
  }

  ///搜索历史标题
  Widget _searchhistory(BottomCatModel model) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Text(
              "搜索历史",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  color: model.dark
                      ? model.fontColor
                      : Theme.of(context).primaryColor),
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
                  size: 28,
                  color: model.fontColor,
                ),
                Text(
                  "清空",
                  style: TextStyle(color: model.fontColor),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///搜索历史列表
  Widget _searchhistorycontent(BottomCatModel model) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 5),
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: _historyList.length != 0,
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                "暂无搜索数据!",
                style: TextStyle(color: model.fontColor),
              ),
            ),
          ),
          Offstage(
            offstage: _historyList.length == 0,
            child: ListView.builder(
                itemCount: _historyList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => {startPageForResult(_historyList[index])},
                    child: Container(
                        height: ScreenUtil().setHeight(100),
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
                                      color: model.fontColor,
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                )),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    _historyList[index],
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(38),
                                        color: model.fontColor),
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
    ));
  }

  Future getHotSearch() async {
    request('hotsearch').then((val) {
      HotSearchBean hotSearchBean = HotSearchBean.fromJson(val);
      setState(() {
        _hotList.clear();
        _hotList.addAll(hotSearchBean.data);
      });
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
    App.router
        .navigateTo(context,
            "${Routers.searchDetail}?searchStr=${Uri.encodeComponent(str)}")
        .then((result) {
      if (result != null) {
        _searchContent = result;
        save();
      }
    });
  }
}
