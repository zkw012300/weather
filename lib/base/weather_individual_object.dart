
import 'package:flutter/cupertino.dart';

/// 天气可绘制对象
/// 如雨滴、雪花或是雷电
abstract class WeatherIndividualObject {

  void draw(Canvas canvas, Paint paint);
}