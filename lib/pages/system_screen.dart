import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/mode/SystemBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/pages/classification_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 体系
class SystemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SystemState();
  }
}

class _SystemState extends State<SystemScreen> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  List<Data> _data = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSystemData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<BottomCatModel>(
      builder: (context,model,_){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "体系",
              style: TextStyle(color: model.fontColor),
            ),
            actions: <Widget>[_rightSearch(context,model)],
          ),
          body: SafeArea(
              child: Container(
                width: ScreenUtil().width,
                height: ScreenUtil().height,
                child: EasyRefresh(
                  key: _easyRefreshKey,
                  behavior: ScrollOverBehavior(),
                  refreshHeader: ClassicsHeader(
                    key: _headerKey,
                    bgColor: model.dark
                        ? model.searchBackgroundColor
                        : Colors.transparent,
                    textColor: model.fontColor,
                    moreInfoColor: model.fontColor,
                    showMore: true,
                  ),
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: model.searchBackgroundColor,
                    textColor: model.fontColor,
                    moreInfoColor: model.fontColor,
                    showMore: true,
                  ),
                  child: SystemList(
                    model:model,
                    listPage: _data,
                  ),
                  onRefresh: () async {
                    getSystemData();
                  },
                  loadMore: () async {},
                ),
              )),
        );
      },
    );
  }

  getSystemData() async {
    request('homePageSystem').then((val) {
      SystemBean systemBean = SystemBean.fromJson(val);
      List<Data> list = systemBean.data;
      setState(() {
        _data.clear();
        _data.addAll(list);
      });
    });
  }
}

///搜索
Widget _rightSearch(context, BottomCatModel model) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SearchPage();
      }));
    },
    child: Padding(
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Icon(Icons.search, color: model.fontColor, size: 20.0),
    ),
  );
}

///列表
class SystemList extends StatelessWidget {
  final List listPage;
  BottomCatModel model;
  SystemList({Key key, this.listPage,this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          //ListView的Item
          physics: new BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: listPage.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => {
                    debugPrint("跳转页面"),
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ClassiFicationPage(
                        title: listPage[index].name,
                        cid: listPage[index].id,
                        tabName: listPage[index].children,
                      );
                    }))
                  },
              child: Card(
                color: model.cardBackgroundColor,
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        listPage[index].name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: model.fontColor),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Wrap(
                              spacing: 10,
                              children: List.generate(
                                  listPage[index].children.length, (i) {
                                return Text(
                                  listPage[index].children[i].name,
                                  style:
                                      TextStyle(color: model.fontColor),
                                );
                              })))
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
