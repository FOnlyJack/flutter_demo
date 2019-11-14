import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String url;

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
           //调用js方法获取数据
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
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return WebviewScaffold(
          url: widget.url,
          appBar: AppBar(
            elevation: 0.1,
            title: Text(
              widget.title,
              style:
                  TextStyle(color: model.dark ? model.fontColor : Colors.white),
            ),
            iconTheme: IconThemeData(
                color: model.dark ? model.fontColor : Colors.white),
            bottom: PreferredSize(
              child: _progressBar(),
              preferredSize: Size.fromHeight(2.5),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.open_in_browser),
                  onPressed: () => launch(widget.url))
            ],
          ),
          withZoom: false,
          withLocalStorage: true,
          withJavascript: true,
        );
      },
    );
  }

  ///页面加载进度
  Widget _progressBar() {
    return SizedBox(
      height: loading ? 2.5 : 0,
      child: LinearProgressIndicator(
        value: loading ? _progress : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
