import 'package:flutter/widgets.dart';
import 'package:flutter_demo/provider/bottom_cat_model.dart';

class PerfectArcView extends SingleChildRenderObjectWidget {
  final mHeight;
  final mArcHeight; // 圆弧高度
  BottomCatModel model;

  PerfectArcView({this.model, this.mHeight = 260.0, this.mArcHeight = 25});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCircle(mArcHeight: mArcHeight, mHeight: mHeight, model: model);
  }
}

class RenderCircle extends RenderBox {
  Paint mPaint;
  Path mPath = Path();
  var mStartPointX = 0.0;
  var mStartPointY = 0.0;
  var mEndPointX = 0.0;
  var mEndPointY = 0.0;
  var mControlPointX = 0.0;
  var mControlPointY = 0.0;
  var mWidth;
  var mHeight;
  var mArcHeight; // 圆弧高度
  BottomCatModel model;

  RenderCircle({this.mHeight, this.mArcHeight, this.model}) {
    mPaint = new Paint();
    mPaint.isAntiAlias = true;
    mPaint.strokeWidth = 10;
    mPaint.style = PaintingStyle.fill;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    mWidth = size.width;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    mPaint.color = model.dark ? model.cardBackgroundColor : model.imageColor;

    mPath.reset();

    mPath.moveTo(0, 0);
    mPath.addRect(Rect.fromLTRB(0, 0, mWidth, mHeight - mArcHeight));

    mStartPointX = 0;
    mStartPointY = mHeight - mArcHeight;

    mEndPointX = mWidth;
    mEndPointY = mHeight - mArcHeight;

    mControlPointX = mWidth / 2 + 5;
    mControlPointY = mHeight + 5;

    mPath.moveTo(mStartPointX, mStartPointY);

    mPath.quadraticBezierTo(
        mControlPointX, mControlPointY, mEndPointX, mEndPointY);

    canvas.drawPath(mPath, mPaint);
  }
}
