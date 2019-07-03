import 'dart:async';

import "package:dio/dio.dart";
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
Future getHomePageContent(int _currentIndex) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(serviceUrl + "article/list/$_currentIndex/json");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//搜索详情页 查询结果列表
Future getSearchResult(int _currentIndex, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(serviceUrl + "article/query/$_currentIndex/json",
        data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//注册
Future registration(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(servicePath[url], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//项目系统体系刷新和加载更多
Future systemTabData(_currentIndex, cid) async {
  try {
    Response response;
    Dio dio = new Dio();
    response =
        await dio.get(serviceUrl + "article/list/$_currentIndex/json?cid=$cid");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

//项目tab刷新和加载更多
Future projectTabData(_currentIndex, cid) async {
  try {
    Response response;
    Dio dio = new Dio();
    response =
        await dio.get(serviceUrl + "project/list/$_currentIndex/json?cid=$cid");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

////公众号tab刷新和加载更多
Future officialTabData(_currentIndex, cid) async {
  try {
    Response response;
    Dio dio = new Dio();
    response =
        await dio.get(serviceUrl + "wxarticle/list/$cid/$_currentIndex/json");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}
