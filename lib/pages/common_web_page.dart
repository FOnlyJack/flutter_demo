import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/mode/CommonWebBean.dart';
import 'package:flutter_demo/net/service_method.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:provider/provider.dart';

class CommonWebPage extends StatefulWidget {
  @override
  _Common_Web_State createState() {
    return _Common_Web_State();
  }
}

class _Common_Web_State extends State<CommonWebPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<BottomCatModel>(
      builder: (context, model, _) {
        return FutureBuilder(
          future: request('commonWeb'),
          builder: (context, val) {
            if (val.hasData) {
              CommonWebBean commonWebBean = CommonWebBean.fromJson(val.data);
              List<Data> _list = commonWebBean.data;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "常用网站",
                    style: TextStyle(color: model.fontColor),
                  ),
                ),
                body: SafeArea(
                    child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  alignment: WrapAlignment.spaceAround,
                  direction: Axis.horizontal,
                  verticalDirection: VerticalDirection.down,
                  children: List.generate(_list.length, (i) {
                    var random = Random(i);
                    var _color = Color.fromRGBO(
                        random.nextInt(255),
                        random.nextInt(255),
                        random.nextInt(255),
                        model.dark ? 0.2 : 1);
                    return FlatButton(
                      onPressed: () {

                        App.router.navigateTo(context,
                            "${Routers.web}?title=${Uri.encodeComponent(_list[i].name)}&url=${Uri.encodeComponent(_list[i].link)}");
                      },
                      child: Text(
                        _list[i].name,
                        style: TextStyle(color: model.fontColor),
                      ),
                      color: _color,
                      textColor: model.fontColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _color,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                    );
                  }),
                )),
              );
            } else {
              return Container(
                child: Center(
                  child: RefreshProgressIndicator(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
