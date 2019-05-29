import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/mode/SystemBean.dart';
import 'package:flutter_demo/pages/classification_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

/**
 * 体系
 */
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("体系",style: TextStyle(
          color: GlobalConfig.fontColor
        ),),
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
      body: SafeArea(
          child: Container(
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
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                      debugPrint("跳转页面"),
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ClassiFicationPage(title: _data[index].name,cid: _data[index].id,tabName: _data[index].children,);
                      }))
                      },
                      child: Card(
                        color: GlobalConfig.cardBackgroundColor,
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                _data[index].name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold,color: GlobalConfig.fontColor),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Wrap(
                                      spacing: 10,
                                      children: List.generate(
                                          _data[index].children.length, (i) {
                                        return Text(
                                            _data[index].children[i].name,style: TextStyle(
                                          color: GlobalConfig.fontColor
                                        ),);
                                      })
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              onRefresh: () async {
                getSystemData();
              },
              loadMore: () async {},
            ),
          )),
    );
  }

  getSystemData() async {
    Dio dio = Dio();
    Response response = await dio.get("https://www.wanandroid.com/tree/json");
    SystemBean systemBean = SystemBean.fromJson(response.data);
    List<Data> list = systemBean.data;
    setState(() {
      _data.clear();
      _data.addAll(list);
    });
  }
}
