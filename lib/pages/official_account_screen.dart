import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/mode/OfficalAccountTabBean.dart';
import 'package:flutter_demo/mode/OfficalAccountTabDetailBean.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

/**
 * 公众号
 */
class OfficialAccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfficialAccount();
  }
}

class _OfficialAccount extends State<OfficialAccountScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<OfficalAccountTabData> _tabName = List();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: _tabName.length, vsync: this);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("公众号",style: TextStyle(
          color: GlobalConfig.fontColor
        ),),
        bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            unselectedLabelColor:  GlobalConfig.fontColor,
            indicatorColor:  GlobalConfig.fontColor,
            labelColor:  GlobalConfig.fontColor,
            tabs: _tabName.map((OfficalAccountTabData item) {
              return Tab(
                text: item.name,
              );
            }).toList()),
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
      body: TabBarView(
        children: _tabName.map((OfficalAccountTabData item) {
          return Content(item.id);
        }).toList(),
        controller: _tabController,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void initData() async {
    Dio dio = new Dio();
    Response response =
        await dio.get("https://wanandroid.com/wxarticle/chapters/json");
    OfficalAccountTabBean officalAccountTabBean =
        OfficalAccountTabBean.fromJson(response.data);
    List<OfficalAccountTabData> list = officalAccountTabBean.data;
    if (list != null && list.length > 0) {
      setState(() {
        _tabName = list;
      });
    }
  }
}

class Content extends StatefulWidget {
  final int id;

  Content(this.id);

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
            width: double.infinity,
            height: double.infinity,
            child: EasyRefresh(
              key: _easyRefreshKey,
              behavior: ScrollOverBehavior(),
              refreshHeader: ClassicsHeader(
                bgColor: Colors.transparent,
                textColor: Colors.grey,
                moreInfoColor: Colors.grey,
                showMore: true,
                key: _headerKey,
              ),
              refreshFooter: ClassicsFooter(
                bgColor: Colors.white,
                textColor: Colors.grey,
                moreInfoColor: Colors.grey,
                showMore: true,
                key: _footerKey,
              ),
              child: ListView.builder(
                  physics: new BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listPage.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        elevation: 1,
                        color: GlobalConfig.cardBackgroundColor,
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
                                        fontSize: 14, color: GlobalConfig.fontColor),
                                  ),
                                )),
                                Padding(
                                  child: Icon(
                                    Icons.favorite,
                                    color: _listPage[index].collect
                                        ? Colors.red
                                        : GlobalConfig.fontColor,
                                  ),
                                  padding: EdgeInsets.only(right: 5, top: 4),
                                )
                              ],
                            ),
                            Padding(
                              child: Text(
                                _listPage[index].title,
                                style: TextStyle(
                                    fontSize: 17,
                                    color:  GlobalConfig.fontColor,
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
                                    fontSize: 14, color:  GlobalConfig.fontColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 4),
                              child: Text(
                                "时间:" + _listPage[index].niceDate,
                                style: TextStyle(
                                    fontSize: 14, color:  GlobalConfig.fontColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ArticleDetailPage(
                              title: _listPage[index].title,
                              url: _listPage[index].link);
                        }));
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
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://wanandroid.com/wxarticle/list/$_cid/$_currentIndex/json");
    if (response != null) {
      OfficalAccountTabDetailBean officalAccountTabDetailBean =
          OfficalAccountTabDetailBean.fromJson(response.data);
      List<Datas> list = officalAccountTabDetailBean.data.datas;
      if (list != null && list.length > 0) {
        setState(() {
          _listPage = list;
        });
      }
    }
  }

  void getMoreTabData() async {
    _currentIndex++;
    int _cid = widget.id;
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://wanandroid.com/wxarticle/list/$_cid/$_currentIndex/json");
    if (response != null) {
      OfficalAccountTabDetailBean officalAccountTabDetailBean =
          OfficalAccountTabDetailBean.fromJson(response.data);
      List<Datas> list = officalAccountTabDetailBean.data.datas;
      if (list != null && list.length > 0) {
        setState(() {
          _listPage.addAll(list);
        });
      }
    }
  }
}
