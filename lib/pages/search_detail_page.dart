import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/mode/HomePageListDataBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchDetailPage extends StatefulWidget {
  final String searchStr;

  SearchDetailPage({
    Key key,
    @required this.searchStr,
  }) : super(key: key);

  @override
  _SearchDetailPageState createState() {
    return _SearchDetailPageState(searchStr);
  }
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  String searchStr;
  int _page = 0;
  List<Datas> _list = List();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  _SearchDetailPageState(this.searchStr);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search(0, false);
  }

  ///搜索结果列表
  Widget _searchresult(_list, BottomCatModel model) {
    return ListView.builder(
        //ListView的Item
        physics: new BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              elevation: 1,
              color: model.cardBackgroundColor,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(top: 10, left: 5, right: 5),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.zero,
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.circular(20.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 4),
                        child: Text(
                          "作者:" + _list[index].author,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(35),
                              color: model.fontColor),
                        ),
                      )),
                      Padding(
                        child: Icon(
                          Icons.favorite,
                          color: _list[index].collect
                              ? Colors.red
                              : model.fontColor,
                        ),
                        padding: EdgeInsets.only(right: 5, top: 4),
                      )
                    ],
                  ),
                  Padding(
                    child: Text(
                      _list[index].title,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(44),
                          color: model.fontColor,
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(left: 10, top: 1, bottom: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 4),
                    child: Text(
                      "分类:" +
                          _list[index].superChapterName +
                          "/" +
                          _list[index].chapterName,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(40),
                          color: model.fontColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 4),
                    child: Text(
                      "时间:" + _list[index].niceDate,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(40),
                          color: model.fontColor),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              if (_list != null && _list.length > 0) {
                App.router.navigateTo(context,
                    "${Routers.web}?title=${Uri.encodeComponent(_list[index].title)}&url=${Uri.encodeComponent(_list[index].link)}");
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: model.dark ? model.fontColor : Colors.white),
            title: Text(
              widget.searchStr,
              style:
                  TextStyle(color: model.dark ? model.fontColor : Colors.white),
            ),
          ),
          body: Container(
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
              child: _searchresult(_list, model),
              onRefresh: () async {
                search(0, false);
              },
              loadMore: () async {
                search(_page == 0 ? _page + 1 : _page, true);
              },
            ),
          ),
        );
      },
    ), onWillPop: () {
      if (widget.searchStr.isNotEmpty) {
        Navigator.pop(context, widget.searchStr);
      }
      return;
    });
  }

  search(int index, bool isload) async {
    String str = widget.searchStr;
    getSearchResult(index,
        formData: FormData.from({
          "k": str,
        })).then((val) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(val);
      Data data = homePageListDataBean.data;
      List<Datas> list = data.datas;
      if (list != null && list.length > 0) {
        if (isload) {
          setState(() {
            _list.addAll(list);
            _page++;
          });
        } else {
          _list.clear();
          setState(() {
            _page = 0;
            _list.addAll(list);
          });
        }
      }
    });
  }
}
