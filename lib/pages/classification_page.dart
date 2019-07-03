import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/mode/HomePageListDataBean.dart';
import 'package:flutter_demo/mode/SystemBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassiFicationPage extends StatefulWidget {
  final int cid;
  List<Children> tabName = List();
  final String title;

  ClassiFicationPage(
      {Key key,
      @required this.title,
      @required this.cid,
      @required this.tabName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClassificationState();
  }
}

class _ClassificationState extends State<ClassiFicationPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<Children> _tabName = List();

  @override
  void initState() {
    super.initState();
    _tabName = widget.tabName;
    _tabController = TabController(length: _tabName.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: _tabName.map((Children item) {
              return Tab(
                text: item.name,
              );
            }).toList()),
      ),
      body: TabBarView(
        children: _tabName.map((Children item) {
          return Content(
            item.id,
          );
        }).toList(),
        controller: _tabController,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
            width: ScreenUtil().width,
            height: ScreenUtil().height,
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
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _listPage.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        elevation: 1,
                        color: Colors.white70,
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
                                        fontSize: ScreenUtil().setSp(28), color: Colors.black87),
                                  ),
                                )),
                                Padding(
                                  child: Icon(
                                    Icons.favorite,
                                    color: _listPage[index].collect
                                        ? Colors.red
                                        : Colors.grey,
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
                                    color: Colors.black,
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
                                    fontSize: ScreenUtil().setSp(28), color: Colors.black87),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 4),
                              child: Text(
                                "时间:" + _listPage[index].niceDate,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28), color: Colors.black87),
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
