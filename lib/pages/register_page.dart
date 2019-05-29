import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/GlobalConfig.dart';
import 'package:flutter_demo/mode/RegisterResultBean.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * 注册
 */
class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterPage>
    with TickerProviderStateMixin {



  var _registerUserName = "";
  var _registerPassword = "";
  var _registerAgainPassword = "";


  final TextEditingController userRegisterController = new TextEditingController();
  final TextEditingController pwRegisterController = new TextEditingController();
  final TextEditingController pwAgainRegisterController = new TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.2),
          body: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: new Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              regist()
            ],
          ),
        ),
        onWillPop: _requestPop);
  }


  Widget regist() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        "注册",
                        style: TextStyle(color: Colors.white30),
                      ),
                    ),
                    Container(
                      height: 50,
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
                  onChanged: (String value){
                    _registerUserName =value;
                  },
                  style: TextStyle(color: Colors.white30),
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
                  onChanged: (String value){
                    _registerPassword =value;
                  },
                  obscureText: true,
                  controller: pwRegisterController,
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
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  onChanged: (String value){
                    _registerAgainPassword =value;
                  },
                  obscureText: true,
                  controller: pwAgainRegisterController,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white30),
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
                        onPressed: () async{


                          if (_registerUserName == null || _registerUserName.length == 0) {
                            return;
                          }
                          if (_registerPassword == null || _registerPassword.length == 0) {
                            return;
                          }
                          if (_registerAgainPassword == null || _registerAgainPassword.length == 0) {
                            return;
                          }

                          Dio dio = new Dio();
                          FormData formData = new FormData.from({
                            "username": _registerUserName.trim(),
                            "password": _registerPassword.trim(),
                            "repassword": _registerAgainPassword.trim()
                          });
                          Response response;
                          response =await dio.post(
                            "https://www.wanandroid.com/user/register",
                            data: formData,);
                          RegisterResultBean register =RegisterResultBean.fromJson(response.data);
                          if(register.errorCode==-1){
                            Fluttertoast.showToast(
                              msg: register.errorMsg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                            );
                          }else{
                            Fluttertoast.showToast(
                              msg: "注册成功!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                            );
                            Navigator.of(context).pop();
                          }
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
                          height: 50,
                          child: Text(
                            "注册",
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



  Future<bool> _requestPop() {
    print("requestPop");
      Navigator.of(context).pop();

    return new Future.value(false);
  }

  static const USER_NAME_KEY = "user-name";
  static const PW_KEY = "user-pw";
  static const USER_BASIC_CODE = "user-basic-code";

}
