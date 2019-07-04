import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/mode/HomePageListDataBean.dart';
import 'package:flutter_demo/mode/SystemBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
class ClassiFicationPage extends StatefulWidget {

  final String classiFicationJson;
  ClassiFicationPage(this.classiFicationJson);

  @override
  State<StatefulWidget> createState() {
    return _ClassificationState();
  }
}

class _ClassificationState extends State<ClassiFicationPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomCatModel>(
      builder: (context,model,_){
        return FutureBuilder(
          future: json2Bean(),
          builder: (context,val){
          if(val.hasData){
           SystemBeanChild _systemBeanChild =val.data;
            _tabController = TabController(length: _systemBeanChild.children.length, vsync: this);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(_systemBeanChild.name,style: TextStyle(
                    color:  model.fontColor
                ),),
                bottom: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    indicatorColor: model.fontColor,
                    labelColor: model.fontColor,
                    unselectedLabelColor: model.fontColor,
                    tabs: _systemBeanChild.children.map((Children item) {
                      return Tab(
                        text: item.name,
                      );
                    }).toList()),
              ),
              body: TabBarView(
                children: _systemBeanChild.children.map((Children item) {
                  return Content(
                      item.id,
                      model
                  );
                }).toList(),
                controller: _tabController,
              ),
            );
          }else{
            return Container(
              child: Center(
                child: Text(""),
              ),
            );
          }
        },);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future json2Bean() async {
    return  SystemBeanChild.fromJson(await jsonDecode(widget.classiFicationJson));
  }
}

class Content extends StatefulWidget {
  final int id;
  BottomCatModel model;
  Content(this.id, this.model);

  @override
  State<StatefulWidget> createState() {
    return _ContentState();
  }
}

class _ContentState extends State<Content> {
  List<Datas> _listPage = List();
  int _currentIndex = 0;
  ScrollController _scrollController = ScrollController();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTabData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Container(
            margin: EdgeInsets.all(5),
            width: ScreenUtil().width,
            height: ScreenUtil().height,
            child: EasyRefresh(
              key: _easyRefreshKey,
              behavior: ScrollOverBehavior(),
              refreshHeader: ClassicsHeader(
                bgColor:  widget.model.dark
                    ?  widget.model.searchBackgroundColor
                    : Colors.transparent,
                textColor:  widget.model.fontColor,
                moreInfoColor:  widget.model.fontColor,
                showMore: true,
                key: _headerKey,
              ),
              refreshFooter: ClassicsFooter(
                bgColor: widget.model.searchBackgroundColor,
                textColor: widget.model.fontColor,
                moreInfoColor: widget.model.fontColor,
                showMore: true,
                key: _footerKey,
              ),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listPage.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        elevation: 1,
                        color: widget.model.cardBackgroundColor,
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 10, top: 4),
                                  child: Text(
                                    "作者:" + _listPage[index].author,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28), color: widget.model.fontColor),
                                  ),
                                )),
                                Padding(
                                  child: Icon(
                                    Icons.favorite,
                                    color: _listPage[index].collect
                                        ? Colors.red
                                        :widget.model.fontColor,
                                  ),
                                  padding: EdgeInsets.only(right: 5, top: 4),
                                )
                              ],
                            ),
                            Padding(
                              child: Text(
                                _listPage[index].title,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(34),
                                    color: widget.model.fontColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              padding:
                                  EdgeInsets.only(left: 10, top: 1, bottom: 1),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 4),
                              child: Text(
                                "分类:" +
                                    _listPage[index].superChapterName +
                                    "/" +
                                    _listPage[index].chapterName,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28), color: widget.model.fontColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 4),
                              child: Text(
                                "时间:" + _listPage[index].niceDate,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28), color: widget.model.fontColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {

                        App.router.navigateTo(context,
                            "${Routers.web}?title=${Uri.encodeComponent(_listPage[index].title)}&url=${Uri.encodeComponent(_listPage[index].link)}");
                      },
                    );
                  }),
              onRefresh: () async {
                getTabData();
              },
              loadMore: () async {
                getMoreTabData();
              },
            )));
  }

  getTabData() async {
    _currentIndex = 0;
    int _cid = widget.id;
    systemTabData(_currentIndex, _cid).then((val) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(val);
      List<Datas> list = homePageListDataBean.data.datas;
      if (list != null && list.length > 0) {
        setState(() {
          _listPage = list;
        });
      }
    });
  }

  void getMoreTabData() async {
    _currentIndex++;
    int _cid = widget.id;
    systemTabData(_currentIndex, _cid).then((val) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(val);
      List<Datas> list = homePageListDataBean.data.datas;
      if (list != null && list.length > 0) {
        setState(() {
          _listPage.addAll(list);
        });
      }
    });
  }
}
