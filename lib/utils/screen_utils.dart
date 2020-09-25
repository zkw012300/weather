import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather/utils/log_utils.dart';

class ScreenUtils {
  static double _width;
  static double _height;

  static get width => _width;
  static get height => _height;

  static init(BuildContext context) {
    ScreenUtil.init(context);
    _width = ScreenUtil.screenWidthPx;
    _height = ScreenUtil.screenHeightPx;
    LogUtils.log("ScreenUtils", "width = $_width, height = $_height");
  }
}
