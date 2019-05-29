import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/mode/HomePageListDataBean.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SearchDetailPage extends StatefulWidget {
  String searchStr;

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:Scaffold(
          appBar: AppBar(
            title: Text(widget.searchStr,style: TextStyle(
                color: GlobalConfig.fontColor
            ),),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: EasyRefresh(
              key: _easyRefreshKey,
              behavior: ScrollOverBehavior(),
              refreshHeader: ClassicsHeader(
                key: _headerKey,
                bgColor: GlobalConfig.dark
                    ? GlobalConfig.searchBackgroundColor
                    : Colors.transparent,
                textColor: GlobalConfig.fontColor,
                moreInfoColor: GlobalConfig.fontColor,
                showMore: true,
              ),
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: GlobalConfig.searchBackgroundColor,
                textColor: GlobalConfig.fontColor,
                moreInfoColor: GlobalConfig.fontColor,
                showMore: true,
              ),
              child: ListView.builder(
                //ListView的Item
                  physics: new BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        elevation: 1,
                        color: GlobalConfig.cardBackgroundColor,
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
                                            fontSize: 14, color: GlobalConfig.fontColor),
                                      ),
                                    )),
                                Padding(
                                  child: Icon(
                                    Icons.favorite,
                                    color: _list[index].collect
                                        ? Colors.red
                                        : GlobalConfig.fontColor,
                                  ),
                                  padding: EdgeInsets.only(right: 5, top: 4),
                                )
                              ],
                            ),
                            Padding(
                              child: Text(
                                _list[index].title,
                                style: TextStyle(
                                    fontSize: 17,
                                    color:GlobalConfig.fontColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              padding:
                              EdgeInsets.only(left: 10, top: 1, bottom: 1),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 4),
                              child: Text(
                                "分类:" +
                                    _list[index].superChapterName +
                                    "/" +
                                    _list[index].chapterName,
                                style: TextStyle(
                                    fontSize: 14, color: GlobalConfig.fontColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 4),
                              child: Text(
                                "时间:" + _list[index].niceDate,
                                style: TextStyle(
                                    fontSize: 14, color: GlobalConfig.fontColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        if (_list != null && _list.length > 0) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ArticleDetailPage(
                                title: _list[index].title,
                                url: _list[index].link);
                          }));
                        }
                      },
                    );
                  }),
              onRefresh: () async {
                search(0, false);
              },
              loadMore: () async {
                search(_page == 0 ? _page + 1 : _page, true);
              },
            ),
          ),
        ),
        onWillPop: () {
          if (widget.searchStr.isNotEmpty) {
            Navigator.pop(context, widget.searchStr);
          }
        });
  }

  search(int index, bool isload) async {
    String str = widget.searchStr;

    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "k": str,
    });
    Response response = await dio.post(
        "https://www.wanandroid.com/article/query/$index/json",
        data: formData);
    print(response);
    HomePageListDataBean homePageListDataBean =
        HomePageListDataBean.fromJson(response.data);
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
  }
}
