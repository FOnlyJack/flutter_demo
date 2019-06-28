import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import 'package:flutter_demo/config/service_url.dart';

Future request(url) async {
  try {
    Response response;
    Dio dio = new Dio();
//    dio.options.contentType =
//        ContentType.parse("application/x-www-form-urlencoded");
    response = await dio.get(servicePath[url]);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//获得首页列表数据 下拉刷新和加载更多
Future getHomePageContent(int _currentIndex) async{
  try{
    Response response;
    Dio dio = new Dio();
    response = await dio.get(serviceUrl+"article/list/$_currentIndex/json");
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }
}

