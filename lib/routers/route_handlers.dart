import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/article_detail_page.dart';
import 'package:flutter_demo/pages/classification_page.dart';
import 'package:flutter_demo/pages/search_screen.dart';

///跳转到搜索
var searchHandler =  Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SearchPage();
});
///跳转到web详情页
var webDetailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params){
    String title =params["title"]?.first;
    String url =params["url"]?.first;
    return ArticleDetailPage(title: title,url: url,);
  }
);
///跳转到体系的详情页
var classiFicationHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params){
      String classiFicationJsonString =params["classiFicationJson"]?.first;
      return ClassiFicationPage(classiFicationJsonString);
    }
);