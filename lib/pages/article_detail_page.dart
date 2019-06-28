import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/config/GlobalConfig.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleDetailPage extends StatefulWidget {
   String title;
   String url;

  ArticleDetailPage({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  ArticleDetailPageState createState() {
    return ArticleDetailPageState();
  }
}

class ArticleDetailPageState extends State<ArticleDetailPage> {
  // 标记是否是加载中
  bool loading = true;

  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;

  // URL变化监听器
  StreamSubscription<String> onUrlChanged;

  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> onStateChanged;

  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    onStateChanged = flutterWebViewPlugin.onStateChanged.listen((state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
          // 开始加载
          break;
        case WebViewState.finishLoad:
          // 加载完成
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            // 当前是回调页面，则调用js方法获取数据
            parseResult();
          }
          break;
        case WebViewState.abortLoad:
          break;
      }
    });
    flutterWebViewPlugin.onProgressChanged.listen((onstate) {
      setState(() {
        _progress = onstate.toDouble();
      });
    });
  }

  // 解析WebView中的数据
  void parseResult() {
//    flutterWebViewPlugin.evalJavascript("get();").then((result) {
//      // result json字符串，包含token信息
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        elevation: 0.1,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          child: _progressBar(),
          preferredSize: Size.fromHeight(2.0),
        ),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    ) ;
  }

  Widget _progressBar() {
    return SizedBox(
      height: loading ? 2 : 0,
      child: LinearProgressIndicator(
        value: loading ? _progress : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }

  @override
  void dispose() {
    if (onUrlChanged != null) {
      onUrlChanged.cancel();
    }
    if (onStateChanged != null) {
      onStateChanged.cancel();
    }
    if (flutterWebViewPlugin != null) {
      flutterWebViewPlugin.dispose();
    }
    super.dispose();
  }
}
