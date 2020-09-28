import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static final ScreenUtil _screenInst = ScreenUtil();

  static get width => ScreenUtil.screenWidthPx;

  static get height => ScreenUtil.screenHeightPx;

  static get widthDp => ScreenUtil.screenWidth;

  static get heightDp => ScreenUtil.screenHeight;

  static double setWidth(double value) {
    return _screenInst.setWidth(value);
  }

  static double setHeight(double value) {
    return _screenInst.setHeight(value);
  }

  static double setSp(double sp) {
    return _screenInst.setSp(sp);
  }

  static void init(BuildContext context) {
    ScreenUtil.init(context);
  }
}
