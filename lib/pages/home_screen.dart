import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/mode/HomePageBannerBean.dart';
import 'package:flutter_demo/mode/HomePageListDataBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_demo/pages/common_web_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:flutter_demo/view/PerfectArcView.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

/// 首页

class HomeScreen extends StatefulWidget {
  @override
  _SampleAppPageState createState() {
    return _SampleAppPageState();
  }
}

class _SampleAppPageState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Datas> _listPage = List();
  int _currentIndex = 0;

  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  ScrollController _scrollController;
  bool _isShowActionButton = true;

  @override
  void initState() {
    super.initState();

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
    return Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return Scaffold(
            appBar: AppBar(
              leading: null,
              elevation: 0,
              centerTitle: true,
              title: Hero(tag: "search", child: _barSearch(context, model)),
            ),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  PerfectArcView(
                    model: model,
                  ),
                  Container(
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
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          _banner(model),
                          PageList(
                            model: model,
                            listPage: _listPage,
                          )
                        ],
                      ),
                      onRefresh: () async {
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: Offstage(
              offstage: _isShowActionButton,
              child: FloatingActionButton(
                  child: Icon(Icons.arrow_upward),
                  onPressed: () {
                    _scrollController
                        .animateTo(0,
                            duration: Duration(seconds: 1),
                            curve: Curves.linear)
                        .then((_) {
                      setState(() {
                        _isShowActionButton = true;
                      });
                    });
                  }),
            ));
      },
    );
  }

  loadHomeListData() async {
    _currentIndex = 0;
    getHomePageContent(_currentIndex).then((val) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(val);
      List<Datas> list = homePageListDataBean.data.datas;
      setState(() {
        _listPage = list;
      });
    });
  }

  loadHomeListMoreData() async {
    _currentIndex++;
    getHomePageContent(_currentIndex).then((val) {
      HomePageListDataBean homePageListDataBean =
          HomePageListDataBean.fromJson(val);
      List<Datas> list = homePageListDataBean.data.datas;
      setState(() {
        _listPage.addAll(list);
      });
    });
  }
}

/// 首页顶部搜索
Widget _barSearch(context, BottomCatModel model) {
  return Container(
      height: ScreenUtil().setHeight(140),
      child: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton.icon(
            onPressed: () {
              App.router.navigateTo(context,Routers.search);
            },
            padding: EdgeInsets.only(right: 15),
            icon: Icon(Icons.search, color: model.fontColor, size: 25.0),
            label: Text(
              "搜索关键词以空格隔开",
              style: TextStyle(
                  color: model.fontColor, fontSize: ScreenUtil().setSp(42)),
              softWrap: true,
            ),
          )),
          Container(
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                border: BorderDirectional(
                    start: BorderSide(color: model.fontColor, width: 1.0))),
            height: ScreenUtil().setHeight(45),
            width: ScreenUtil().setWidth(3),
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
                        fontSize: ScreenUtil().setSp(35),
                        color: model.fontColor,
                      ),
                    ),
                    Text(
                      "网站",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        color: model.fontColor,
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
        color: model.searchBackgroundColor,
      ));
}

///首页轮播
Widget _banner(BottomCatModel model) {
  return SliverToBoxAdapter(
    child: FutureBuilder(
        future: request("homePageBanner"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HomePageBannerData> bannerListData =
                HomePageBannerBean.fromJson(snapshot.data).data;
            return Opacity(
              opacity: model.dark ? 0.3 : 1,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: ScreenUtil().width,
                height: ScreenUtil().setHeight(450),
                child: RefreshSafeArea(
                  child: Swiper(
                    onTap: (i) {
                      App.router.navigateTo(context,
                          "${Routers.web}?title=${Uri.encodeComponent(bannerListData[i].title)}&url=${Uri.encodeComponent(bannerListData[i].url)}");
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
                            imageUrl: bannerListData[index].imagePath,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      );
                    },
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                      color: model.fontColor,
                      activeColor: model.cardBackgroundColor,
                    )),
                    itemCount: bannerListData.length,
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: RefreshProgressIndicator(),
              ),
            );
          }
        }),
  );
}

///首页list列表
class PageList extends StatelessWidget {
  final List listPage;
  BottomCatModel model;

  PageList({Key key, this.listPage, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
        itemExtent: ScreenUtil().setHeight(400),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 4),
                        child: Text(
                          "作者:" + listPage[index].author,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              color: model.fontColor),
                        ),
                      )),
                      Padding(
                        child: Icon(
                          Icons.favorite,
                          color: listPage[index].collect
                              ? Colors.red
                              : model.fontColor,
                        ),
                        padding: EdgeInsets.only(right: 5, top: 4),
                      )
                    ],
                  ),
                  Padding(
                    child: Text(
                      listPage[index].title,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: model.fontColor,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    padding: EdgeInsets.only(left: 10, top: 1, bottom: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 4),
                    child: Text(
                      "分类:" +
                          listPage[index].superChapterName +
                          "/" +
                          listPage[index].chapterName,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: model.fontColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 4),
                    child: Text(
                      "时间:" + listPage[index].niceDate,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: model.fontColor),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              App.router.navigateTo(context,
                  "${Routers.web}?title=${Uri.encodeComponent(listPage[index].title)}&url=${Uri.encodeComponent(listPage[index].link)}");
            },
          );
        }, childCount: listPage.length));
  }
}
