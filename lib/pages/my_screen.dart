import 'package:flutter/material.dart';
import 'package:flutter_demo/mode/RegisterResultBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/pages/login_register_page.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyScreenState();
  }
}

class _MyScreenState extends State<MyScreen> {
  bool _switchValue = false;
  bool _islogin = false;

  @override
  initState() {
    super.initState();
    init();
  }

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
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: val.dark ? 0.3 : 1,
          child: Image.network(
              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558520301227&di=eb01bf2689890224c31d1f6e6bae51af&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F16%2F84%2F56%2F53S58PICrpj_1024.jpg"),
        ),
        Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: Opacity(
                  opacity: val.dark ? 0.3 : 1,
                  child: ClipOval(
                    child: Image.network(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558516745155&di=f9b26e1e32576a8a3aaf39b583120e11&imgtype=0&src=http%3A%2F%2Fa4.att.hudong.com%2F45%2F34%2F01300001024098148066342526056_s.jpg",
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setWidth(120),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginRegisterPage();
                  })).then((result) {
                    _islogin = result;
                    init();
                  });
                },
                child: Text(
                  _islogin ? '已登录' : "未登录",
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
                        value: _switchValue,
                        onChanged: (bool) async {
                          print(_switchValue);
                          print(bool);

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("is_dark", bool).then((_) {
                            setState(() {
                              _switchValue = bool;
                              Provider.of<BottomCatModel>(context)
                                  .setNightMode(!bool);
                            });
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
        Divider(height: ScreenUtil().setHeight(1)),
        InkWell(
          onTap: () {},
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
        FlatButton(
          onPressed: () async {
            request("logout").then((val) async {
              RegisterResultBean register = RegisterResultBean.fromJson(val);
              if (register.errorCode != -1) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLogin", false);
                prefs.setString("user-name", "");
                prefs.setString("user-pw", "");
                setState(() {
                  _islogin = false;
                });
                Fluttertoast.showToast(
                  msg: "退出成功!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                );
              }
            });
          },
          child: Text("退出"),
          color: val.dark ? val.cardBackgroundColor : Colors.red,
          textColor: val.fontColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: val.dark ? val.cardBackgroundColor : Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5)),
        )
      ],
    );
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _islogin = prefs.get("isLogin") ?? false;
      _switchValue = prefs.getBool("is_dark") ?? false;
      Provider.of<BottomCatModel>(context).setNightMode(!_switchValue);
    });
  }
}
