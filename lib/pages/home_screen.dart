import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/mode/HomePageBannerBean.dart';
import 'package:flutter_demo/mode/HomePageListDataBean.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_demo/pages/common_web_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';
import 'package:flutter_demo/view/PerfectArcView.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

/**
 * 首页
 */
class HomeScreen extends StatefulWidget {
  @override
  _SampleAppPageState createState() {
    return _SampleAppPageState();
  }
}

class _SampleAppPageState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<HomePageBannerData> _bannerImgData = List();
  List<Datas> _listPage = List();
  int _currentIndex = 0;

  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  ScrollController _scrollController;
  double downY = 0.0;
  double lastDownY = 0.0;
  double lastListLength = 0.0;
  bool _isShowActionButton = true;

  Widget _container;

  @override
  void initState() {
    super.initState();

    loadBanner();
    loadHomeListData();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent / (4 * _currentIndex + 1) >
          _scrollController.offset) {
        setState(() {
          _isShowActionButton = true;
        });
      } else {
        setState(() {
          _isShowActionButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget barSearch() {
      return Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SearchPage();
                  }));
                },
                padding: EdgeInsets.only(right: 15),
                icon: Icon(Icons.search,
                    color: GlobalConfig.fontColor, size: 25.0),
                label: Text(
                  "搜索关键词以空格隔开",
                  style: TextStyle(color: GlobalConfig.fontColor, fontSize: 16),
                  softWrap: true,
                ),
              )),
              Container(
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    border: BorderDirectional(
                        start: BorderSide(
                            color: GlobalConfig.fontColor, width: 1.0))),
                height: 14.0,
                width: 1.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CommonWebPage();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "常用",
                          style: TextStyle(
                            fontSize: 13,
                            color: GlobalConfig.fontColor,
                          ),
                        ),
                        Text(
                          "网站",
                          style: TextStyle(
                            fontSize: 13,
                            color: GlobalConfig.fontColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(3.0)),
            color: GlobalConfig.searchBackgroundColor,
          ));
    }

    return Scaffold(
        appBar: AppBar(
          leading: null,
          elevation: 0,
          centerTitle: true,
          title: Hero(tag: "search", child: barSearch()),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              PerfectArcView(
                mArcHeight: 20,
                mHeight: 250.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: _container,
                      ),
                      SliverFixedExtentList(
                          itemExtent: 130,
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return GestureDetector(
                              child: Card(
                                elevation: 1,
                                color: GlobalConfig.cardBackgroundColor,
                                clipBehavior: Clip.antiAlias,
                                margin:
                                    EdgeInsets.only(top: 10, left: 5, right: 5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.zero,
                                        bottomLeft: Radius.zero,
                                        bottomRight: Radius.circular(20.0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 4),
                                          child: Text(
                                            "作者:" + _listPage[index].author,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: GlobalConfig.fontColor),
                                          ),
                                        )),
                                        Padding(
                                          child: Icon(
                                            Icons.favorite,
                                            color: _listPage[index].collect
                                                ? Colors.red
                                                : GlobalConfig.fontColor,
                                          ),
                                          padding:
                                              EdgeInsets.only(right: 5, top: 4),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      child: Text(
                                        _listPage[index].title,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: GlobalConfig.fontColor,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      padding: EdgeInsets.only(
                                          left: 10, top: 1, bottom: 1),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 4),
                                      child: Text(
                                        "分类:" +
                                            _listPage[index].superChapterName +
                                            "/" +
                                            _listPage[index].chapterName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: GlobalConfig.fontColor),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 4),
                                      child: Text(
                                        "时间:" + _listPage[index].niceDate,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: GlobalConfig.fontColor),
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
                          }, childCount: _listPage.length))
                    ],
                  ),
                  onRefresh: () async {
                    loadBanner();
                    loadHomeListData();
                  },
                  loadMore: () async {
                    loadHomeListMoreData();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Offstage(
          offstage: _isShowActionButton,
          child: FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController
                    .animateTo(0,
                        duration: Duration(seconds: 1), curve: Curves.linear)
                    .then((_) {
                  setState(() {
                    _isShowActionButton = true;
                  });
                });
              }),
        ));
  }

  loadHomeListData() async {
    _currentIndex = 0;
    Dio dio = new Dio();
    Response response = await dio
        .get("https://www.wanandroid.com/article/list/$_currentIndex/json");
    if (response != null) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(response.data);
      List<Datas> list = homePageListDataBean.data.datas;
      setState(() {
        _listPage = list;
      });
    }
  }

  loadHomeListMoreData() async {
    _currentIndex++;
    Dio dio = new Dio();
    Response response = await dio
        .get("https://www.wanandroid.com/article/list/$_currentIndex/json");
    if (response != null) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(response.data);
      List<Datas> list = homePageListDataBean.data.datas;
      setState(() {
        _listPage.addAll(list);
      });
    }
  }

  loadBanner() async {
    Dio dio = new Dio();
    Response response = await dio.get("https://www.wanandroid.com/banner/json");
    if (response != null) {
      //网络请求成功
      List<HomePageBannerData> list =
          HomePageBannerBean.fromJson(response.data).data;
      if (list != null && list.length > 0) {
        setState(() {
          _bannerImgData.clear();
          _bannerImgData.addAll(list);
          _container = Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: RefreshSafeArea(
              child: Swiper(
                onTap: (i) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ArticleDetailPage(
                        title: _bannerImgData[i].title,
                        url: _bannerImgData[i].url);
                  }));
                },
                autoplayDisableOnInteraction: true,
                controller: SwiperController(),
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: _bannerImgData[index].imagePath,
                        errorWidget: (context, url, error) =>
                             Icon(Icons.error),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  );
                },
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: GlobalConfig.fontColor,
                  activeColor: GlobalConfig.cardBackgroundColor,
                )),
                itemCount: _bannerImgData.length,
              ),
            ),
          );
        });
      }
    }
  }
}
