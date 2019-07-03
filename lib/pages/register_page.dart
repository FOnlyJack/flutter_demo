import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/mode/RegisterResultBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

///注册

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterPage> with TickerProviderStateMixin {
  var _registerUserName = "";
  var _registerPassword = "";
  var _registerAgainPassword = "";

  final TextEditingController userRegisterController =
      new TextEditingController();
  final TextEditingController pwRegisterController =
      new TextEditingController();
  final TextEditingController pwAgainRegisterController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///图片灰色蒙版遮罩
  Widget imageLayerMask() {
    return BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: new Container(
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Consumer<BottomCatModel>(
          builder: (context,model,_){
            return Scaffold(
              backgroundColor: Colors.grey.withOpacity(0.2),
              body: Stack(
                children: <Widget>[imageLayerMask(), regist(model)],
              ),
            );
          },
        ),
        onWillPop: _requestPop);
  }

  ///注册顶部title
  Widget registrationInput() {
    return Container(
      height: ScreenUtil().setHeight(130),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(130),
            child: Text(
              "注册",
              style: TextStyle(color: Colors.white30,fontSize: ScreenUtil().setSp(45)),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(130),
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
    );
  }

  ///账号输入
  Widget accountEntry() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        onChanged: (String value) {
          _registerUserName = value;
        },
        style: TextStyle(color: Colors.white30,fontSize: ScreenUtil().setSp(40)),
        cursorColor: Colors.grey,
        controller: userRegisterController,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          fillColor: Colors.transparent,
          filled: true,
          labelText: '账号',
          labelStyle: TextStyle(color: Colors.white30,fontSize: ScreenUtil().setSp(40)),
          prefixIcon: Icon(
            Icons.book,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }

  ///密码输入
  Widget passwordEntry() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        onChanged: (String value) {
          _registerPassword = value;
        },
        obscureText: true,
        controller: pwRegisterController,
        cursorColor: Colors.grey,
        style: TextStyle(color: Colors.white30,fontSize: ScreenUtil().setSp(40)),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          fillColor: Colors.transparent,
          filled: true,
          labelText: '密码',
          labelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(40),
            color: Colors.white30,
          ),
          prefixIcon: Icon(
            Icons.save,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }

  ///再次输入密码
  Widget againInputPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        onChanged: (String value) {
          _registerAgainPassword = value;
        },
        obscureText: true,
        controller: pwAgainRegisterController,
        cursorColor: Colors.grey,
        style: TextStyle(color: Colors.white30,fontSize: ScreenUtil().setSp(40)),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          fillColor: Colors.transparent,
          filled: true,
          labelText: '再次输入密码',
          labelStyle: TextStyle(
            color: Colors.white30,
            fontSize: ScreenUtil().setSp(40)
          ),
          prefixIcon: Icon(
            Icons.save,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }

  ///注册按钮
  Widget registButton(BottomCatModel model) {
    return Container(
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
                    if (_registerUserName == null ||
                        _registerUserName.length == 0) {
                      Fluttertoast.showToast(
                        msg: "请输入账号!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                      );
                      return;
                    }
                    if (_registerPassword == null ||
                        _registerPassword.length == 0) {
                      Fluttertoast.showToast(
                        msg: "请输入密码!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                      );
                      return;
                    }
                    if (_registerAgainPassword == null ||
                        _registerAgainPassword.length == 0) {
                      Fluttertoast.showToast(
                        msg: "请确认密码!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                      );
                      return;
                    }
                    registration("regist",
                        formData: FormData.from({
                          "username": _registerUserName.trim(),
                          "password": _registerPassword.trim(),
                          "repassword": _registerAgainPassword.trim()
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
                          msg: "注册成功!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                        ).whenComplete(()=>Navigator.of(context).pop());
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
                    height: ScreenUtil().setHeight(130),
                    child: Text(
                      "注册",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                          color: model.dark
                              ? model.fontColor
                              : Colors.white),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  ///注册组件
  Widget regist(BottomCatModel model) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              registrationInput(),
              accountEntry(),
              passwordEntry(),
              againInputPassword()
            ],
          ),
          registButton(model),
        ],
      ),
    );
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }
}
