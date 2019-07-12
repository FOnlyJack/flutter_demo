import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/routers/app.dart';
import 'package:flutter_demo/routers/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _banner_list = [
    'http://attachments.gfan.com/forum/201708/11/145501mlt9392xwoegamig.jpg',
    'http://img5.duitang.com/uploads/blog/201307/18/20130718172427_3eimK.jpeg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562839413295&di=d6b94f350a5981df32e1a57fac601fb6&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201408%2F24%2F20140824190909_M2MHJ.jpeg'
  ];
  Timer _timer;
  int _countdownTime = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCountdownTimer();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);
    return Material(
      child: Stack(
        children: <Widget>[
          Offstage(
              offstage: false,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: _banner_list[index],
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                },
                itemCount: _banner_list.length,
                pagination: new SwiperPagination(),
              )),
          Offstage(
            offstage: false,
            child: Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  App.router.navigateTo(context, Routers.home, replace: true);
                },
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "跳过 ${_countdownTime == 0 ? "" : _countdownTime}",
                      style: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0x66000000),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(width: 0.33, color: Colors.grey))),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer.cancel();
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (_countdownTime == 0) {
              _timer.cancel();
              App.router.navigateTo(context, Routers.home, replace: true);
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }
}
