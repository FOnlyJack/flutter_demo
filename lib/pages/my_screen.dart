import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/mode/RegisterResultBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyScreenState();
  }
}

class _MyScreenState extends State<MyScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomCatModel>(
      builder: (context, val, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "我的",
              style: TextStyle(color: val.fontColor),
            ),
          ),
          body: Column(
            children: <Widget>[
              _buildHead(val),
              _buildItems(val),
            ],
          ),
        );
      },
    );
  }

  //用户头像、用户名
  _buildHead(BottomCatModel val) {
    String iconBg =
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558520301227&di=eb01bf2689890224c31d1f6e6bae51af&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F16%2F84%2F56%2F53S58PICrpj_1024.jpg";
    String icon =
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558516745155&di=f9b26e1e32576a8a3aaf39b583120e11&imgtype=0&src=http%3A%2F%2Fa4.att.hudong.com%2F45%2F34%2F01300001024098148066342526056_s.jpg";
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: val.dark ? 0.3 : 1,
          child: CachedNetworkImage(
            imageUrl: iconBg,
          ),
        ),
        Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: Opacity(
                  opacity: val.dark ? 0.3 : 1,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: icon,
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setWidth(150),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Text(
                  val.isLogin ? '已登录' : "未登录",
                  style: TextStyle(
                      color: val.fontColor, fontSize: ScreenUtil().setSp(44)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _buildItems(BottomCatModel val) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/images/theme_icon.png',
                  color: val.fontColor,
                  height: ScreenUtil().setHeight(40),
                  width: ScreenUtil().setHeight(40),
                ),
                margin: EdgeInsets.only(left: 15),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Text(
                    '选择主题',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36), color: val.fontColor),
                  ),
                  margin: EdgeInsets.only(left: 5),
                ),
              ),
              Expanded(
                  child: Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      '夜间模式',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: val.fontColor),
                    ),
                    Switch.adaptive(
                        value: val.dark,
                        onChanged: (bool) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("is_dark", bool).then((_) {
                            Provider.of<BottomCatModel>(context)
                                .setNightMode(!bool);
                          });
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              )),
            ],
          ),
          height: ScreenUtil().setHeight(140),
          color: val.cardBackgroundColor,
        ),
        Divider(height: 1),
        InkWell(
          onTap: () {
            App.router.navigateTo(context,
                "${Routers.web}?title=${Uri.encodeComponent("关于")}&url=${Uri.encodeComponent("https://github.com/FOnlyJack/flutter_demo")}");
          },
          child: Container(
            color: val.cardBackgroundColor,
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/about.png',
                    color: val.fontColor,
                    height: ScreenUtil().setHeight(40),
                    width: ScreenUtil().setWidth(40),
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '关于',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: val.fontColor),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
                ),
              ],
            ),
            height: ScreenUtil().setHeight(140),
          ),
        ),
        Divider(height: 1),
        InkWell(
          onTap: () {
            Fluttertoast.showToast(
              msg: "暂未实现!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
            );
          },
          child: Container(
            color: val.cardBackgroundColor,
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/about.png',
                    color: val.fontColor,
                    height: ScreenUtil().setHeight(40),
                    width: ScreenUtil().setWidth(40),
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '我的收藏',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: val.fontColor),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
                ),
              ],
            ),
            height: ScreenUtil().setHeight(140),
          ),
        ),
        Divider(height: 1),
        Container(
          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
          child: FlatButton(
            onPressed: () async {
              if (val.isLogin) {
                request("logout").then((val) async {
                  RegisterResultBean register =
                      RegisterResultBean.fromJson(val);
                  if (register.errorCode != -1) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool("isLogin", false);
                    prefs.setString("user-name", "");
                    prefs.setString("user-pw", "");
                    Provider.of<BottomCatModel>(context).setIsLogin(false);
                    Fluttertoast.showToast(
                      msg: "退出成功!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                    );
                  }
                });
              } else {
                App.router
                    .navigateTo(context, Routers.loginOrRegister)
                    .then((result) {
                      if(result!=null){
                        Provider.of<BottomCatModel>(context)
                            .setIsLogin(result);
                      }
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().width,
              height: ScreenUtil().setHeight(120),
              child: Text(
                val.isLogin ? "退  出" : "登  录",
                style: TextStyle(
                    color: val.fontColor,
                    fontSize: ScreenUtil().setSp(48),
                    fontWeight: FontWeight.bold),
              ),
            ),
            color:
                val.dark ? val.cardBackgroundColor : val.themeData.primaryColor,
            textColor: val.fontColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: val.dark
                      ? val.cardBackgroundColor
                      : val.themeData.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5)),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
