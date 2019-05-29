import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/eventbus/eventBus.dart';
import 'package:flutter_demo/mode/RegisterResultBean.dart';
import 'package:flutter_demo/pages/login_register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "我的",
          style: TextStyle(color: GlobalConfig.fontColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildHead(),
          _buildItems(),
        ],
      ),
    );
  }

  //用户头像、用户名
  _buildHead() {
    return Stack(
      children: <Widget>[
        Image.network(
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558520301227&di=eb01bf2689890224c31d1f6e6bae51af&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F16%2F84%2F56%2F53S58PICrpj_1024.jpg"),
        Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60),
                child: ClipOval(
                  child: new Image.network(
                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558516745155&di=f9b26e1e32576a8a3aaf39b583120e11&imgtype=0&src=http%3A%2F%2Fa4.att.hudong.com%2F45%2F34%2F01300001024098148066342526056_s.jpg",
                    width: 50,
                    height: 50,
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
                  style: TextStyle(color: GlobalConfig.fontColor, fontSize: 16),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _buildItems() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/images/theme_icon.png',
                  color: GlobalConfig.fontColor,
                  height: 18,
                  width: 18,
                ),
                margin: EdgeInsets.only(left: 15),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Text(
                    '选择主题',
                    style:
                        TextStyle(fontSize: 16, color: GlobalConfig.fontColor),
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
                          fontSize: 12, color: GlobalConfig.fontColor),
                    ),
                    Switch.adaptive(
                        value: _switchValue,
                        onChanged: (bool) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setBool("is_dark",bool );
                          setState(()  {
                            _switchValue = !_switchValue;
                            if (bool) {
                              GlobalConfig.themeData = ThemeData(
                                primaryColor: Color(0xff2196f3),
                                scaffoldBackgroundColor: Color(0xFFEBEBEB),
                              );
                              GlobalConfig.searchBackgroundColor =
                                  Color(0xFFEBEBEB);
                              GlobalConfig.cardBackgroundColor = Colors.white;
                              GlobalConfig.fontColor = Colors.black54;
                              GlobalConfig.dark = false;
                            } else {
                              GlobalConfig.themeData = ThemeData.dark();
                              GlobalConfig.searchBackgroundColor =
                                  Colors.white10;
                              GlobalConfig.cardBackgroundColor =
                                  Color(0xFF222222);
                              GlobalConfig.fontColor = Colors.white30;
                              GlobalConfig.dark = true;
                            }
                            eventBus.fire(NightPatternEvent(_switchValue));
                          });
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              )),
            ],
          ),
          height: 50,
          color: GlobalConfig.cardBackgroundColor,
        ),
        Divider(height: 1),
        InkWell(
          onTap: () {},
          child: Container(
            color: GlobalConfig.cardBackgroundColor,
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/about.png',
                    color: GlobalConfig.fontColor,
                    height: 23,
                    width: 23,
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '关于',
                      style: TextStyle(
                          fontSize: 16, color: GlobalConfig.fontColor),
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
                ),
              ],
            ),
            height: 50,
          ),
        ),
        Divider(height: 1),
        FlatButton(
          onPressed: () async {
            Dio dio = new Dio();
            Response response =
                await dio.get("https://www.wanandroid.com/user/logout/json");
            RegisterResultBean register =
                RegisterResultBean.fromJson(response.data);
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
          },
          child: Text("退出"),
          color: Colors.red,
          textColor: GlobalConfig.fontColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.red,
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
      _islogin = prefs.get("isLogin")??false;
      _switchValue=  prefs.getBool("is_dark")??false;
    });
  }
}
