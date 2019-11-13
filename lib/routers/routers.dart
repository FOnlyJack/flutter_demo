import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'route_handlers.dart';

///路由配置
class Routers {
  static String root = "/";
  static String search = "/search";
  static String web = "/web";
  static String classfication = "/classfication";
  static String commonweb = "/commonweb";
  static String register = "/register";
  static String searchDetail = "/searchdetail";
  static String loginOrRegister = "/loginorregister";
  static String splash = "/splash";
  static String home = "/home";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        // ignore: missing_return
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });

    /// 第一个参数是路由地址，第二个参数是页面跳转和传参，第三个参数是默认的转场动画
    router.define(search, handler: searchHandler);
    router.define(web, handler: webDetailsHandler);
    router.define(classfication, handler: classiFicationHandler);
    router.define(commonweb, handler: commonWebHandler);
    router.define(register, handler: registerHandler);
    router.define(searchDetail, handler: searchDetailsHandler);
    router.define(loginOrRegister, handler: loginOrRegisterHandler);
    router.define(home, handler: homeHandler);
  }
}
