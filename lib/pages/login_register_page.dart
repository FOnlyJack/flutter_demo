import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/config/GlobalConfig.dart';
import 'package:flutter_demo/mode/RegisterResultBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/pages/register_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

/**
 * 登录
 */
class LoginRegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginRegisterState();
  }
}

class _LoginRegisterState extends State<LoginRegisterPage>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  bool isShowVideo = false;
  bool isShowLogin = true;

  AnimationController animationController;
  Animation<double> _translation;
  Animation<double> _height;

  var _loginUserName = "";
  var _loginPassword = "";

  final TextEditingController userLoginController = new TextEditingController();
  final TextEditingController pwLoginController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/4.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      });
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _translation = Tween(begin: 0.0, end: 0.65).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Cubic(0.18, 1.0, 0.18, 1.0),
      ),
    )..addStatusListener(_handler);

    _height = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Cubic(0.18, 1.0, 0.18, 1.0),
      ),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _height.removeStatusListener(_handler);
        }
      });
    initParams();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.2),
          body: Stack(
            children: <Widget>[
              Offstage(
                offstage: false,
                child: vedio(),
              ),
              BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: new Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              AnimatedCrossFade(
                  firstChild: vedio(),
                  secondChild: login(),
                  crossFadeState: isShowLogin
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(seconds: 1)),
            ],
          ),
        ),
        onWillPop: _requestPop);
  }

  Widget vedio() {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.height,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AnimatedBuilder(
                    animation: animationController,
                    child: RawMaterialButton(
                        elevation: 5,
                        fillColor: Colors.red,
                        onPressed: () {
                          setState(() {});
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5)),
                              ),
                              width: ScreenUtil().setWidth(140),
                              height: ScreenUtil().setHeight(140),
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/qq.png",
                                color: Colors.white54,
                                width: ScreenUtil().setWidth(60),
                                height: ScreenUtil().setHeight(60),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                              ),
                              alignment: Alignment.center,
                              height: ScreenUtil().setHeight(140),
                              child: Text(
                                "QQ登录",
                                style: TextStyle(
                                    color: GlobalConfig.dark
                                        ? GlobalConfig.fontColor
                                        : Colors.white),
                              ),
                            ))
                          ],
                        )),
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                          0.0,
                          _translation.value *
                              -MediaQuery.of(context).size.height,
                          0.0,
                        ),
                        child: Offstage(
                          offstage: _height.value == 0.5 ? true : false,
                          child: Opacity(
                            opacity: 0.7,
                            child: Container(
                              height: _height.value != 0.5
                                  ? 50 - _height.value * 100
                                  : 0,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    }),
                AnimatedBuilder(
                  animation: animationController,
                  child: RawMaterialButton(
                      elevation: 5,
                      fillColor: Colors.green,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                            ),
                            width: ScreenUtil().setWidth(140),
                            height: ScreenUtil().setHeight(140),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/weixin.png",
                              color: Colors.white54,
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setHeight(60),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            alignment: Alignment.center,
                            height: ScreenUtil().setHeight(140),
                            child: Text(
                              "微信登录",
                              style: TextStyle(
                                  color: GlobalConfig.dark
                                      ? GlobalConfig.fontColor
                                      : Colors.white),
                            ),
                          ))
                        ],
                      )),
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        _translation.value *
                            -MediaQuery.of(context).size.height,
                        0.0,
                      ),
                      child: Offstage(
                        offstage: _height.value == 0.5 ? true : false,
                        child: Opacity(
                          opacity: 0.7,
                          child: Container(
                            height: _height.value != 0.5
                                ? 50 - _height.value * 100
                                : 0,
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Offstage(
                  offstage: !isShowLogin,
                  child: Opacity(
                    opacity: 0.7,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: RawMaterialButton(
                          elevation: 5,
                          fillColor: Colors.black,
                          onPressed: () {
                            setState(() {
                              isShowLogin = !isShowLogin;
                              isShowVideo = false;
                              animationController.forward();
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                ),
                                width: ScreenUtil().setWidth(140),
                                height: ScreenUtil().setHeight(140),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/zhanghao.png",
                                  color: Colors.white54,
                                  width: ScreenUtil().setWidth(60),
                                  height: ScreenUtil().setHeight(60),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                alignment: Alignment.center,
                                height: ScreenUtil().setHeight(140),
                                child: Text(
                                  "普通账号登录",
                                  style: TextStyle(
                                      color: GlobalConfig.dark
                                          ? GlobalConfig.fontColor
                                          : Colors.white),
                                ),
                              ))
                            ],
                          )),
                    ),
                  ),
                ),
                Offstage(
                  offstage: !isShowLogin,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return RegisterPage();
                        }));
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "没有账号?注册",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white30,
                            color: Colors.white30,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget login() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(140),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(140),
                      child: Text(
                        "登录",
                        style: TextStyle(color: Colors.white30),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(140),
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          _requestPop();
                        },
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  onChanged: (String value) {
                    _loginUserName = value;
                  },
                  controller: userLoginController,
                  style: TextStyle(color: Colors.white30),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30)),
                    fillColor: Colors.transparent,
                    filled: true,
                    labelText: '账号',
                    labelStyle: TextStyle(color: Colors.white30),
                    prefixIcon: Icon(
                      Icons.book,
                      color: Colors.white30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  onChanged: (String value) {
                    _loginPassword = value;
                  },
                  obscureText: true,
                  controller: pwLoginController,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white30),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30)),
                    fillColor: Colors.transparent,
                    filled: true,
                    labelText: '密码',
                    labelStyle: TextStyle(
                      color: Colors.white30,
                    ),
                    prefixIcon: Icon(
                      Icons.save,
                      color: Colors.white30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Opacity(
                  opacity: 0.7,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: RawMaterialButton(
                        elevation: 5,
                        fillColor: Colors.white30,
                        onPressed: () async {
                          if (_loginUserName == null ||
                              _loginUserName.length == 0) {
                            return;
                          }
                          if (_loginPassword == null ||
                              _loginPassword.length == 0) {
                            return;
                          }

                          String type = _loginUserName + ":" + _loginPassword;
                          var bytes = utf8.encode(type);
                          var base64Str = base64.encode(bytes);

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(USER_NAME_KEY, _loginUserName);

                          SharedPreferences prefs1 =
                              await SharedPreferences.getInstance();
                          prefs1.setString(PW_KEY, _loginPassword);

                          registration('login',
                              formData: FormData.from({
                                "username": _loginUserName.trim(),
                                "password": _loginPassword.trim(),
                              })).then((val) {
                            RegisterResultBean register =
                                RegisterResultBean.fromJson(val);
                            if (register.errorCode == -1) {
                              Fluttertoast.showToast(
                                msg: register.errorMsg,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "登录成功!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                              ).whenComplete(() => loginSucess());
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(140),
                          child: Text(
                            "登录",
                            style: TextStyle(
                                color: GlobalConfig.dark
                                    ? GlobalConfig.fontColor
                                    : Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _handler(status) {
    if (status == AnimationStatus.completed) {
      _translation.removeStatusListener(_handler);
      setState(() {
        isShowLogin = false;
      });
//      animationController.reset();
//      _animation = Tween(begin: 0.0, end: 1.0).animate(
//        CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
//      )..addStatusListener(
//            (status) {
//          if (status == AnimationStatus.completed) {
//
//          }
//        },
//      );
//      animationController.forward();
    }
  }

  Future<bool> _requestPop() {
    print("requestPop");
    if (!isShowLogin) {
      setState(() {
        isShowLogin = !isShowLogin;
        animationController.reverse();
      });
    } else {
      Navigator.of(context).pop();
    }
    return new Future.value(false);
  }

  static const USER_NAME_KEY = "user-name";
  static const PW_KEY = "user-pw";
  static const USER_BASIC_CODE = "user-basic-code";

  initParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loginUserName = prefs.get(USER_NAME_KEY);

    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    _loginPassword = prefs1.get(PW_KEY);

    userLoginController.value =
        new TextEditingValue(text: _loginUserName ?? "");
    pwLoginController.value = new TextEditingValue(text: _loginPassword ?? "");
  }

  loginSucess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", true).then((result) {
      Navigator.of(context).pop(result);
    });
  }
}
