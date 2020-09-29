import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:weather/utils/date_utils.dart';
import 'package:weather/utils/screen_utils.dart';

const _TAG = "SunRiseSetWidget";

class SunRiseSetWidget extends StatefulWidget {
  @override
  State createState() {
    return _SunRiseSetState();
  }
}

class _SunRiseSetState extends State<SunRiseSetWidget> {
  SunRiseSetData _data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (_data == null) {
      widget = Container(
        width: 0,
        height: 0,
      );
    } else {
      final width = double.maxFinite;
      final height = ScreenUtils.setHeight(400);
      widget = Container(
        width: width,
        height: height,
        child: CustomPaint(
          size: Size(width, height),
          painter: _SunRiseSetPainter(_data),
        ),
      );
    }
    return widget;
  }

  void _getData() async {
    _data = SunRiseSetData(1000 * 60 * 60 * 6, 1000 * 60 * 60 * 18);
    setState(() {});
  }
}

class _SunRiseSetPainter extends CustomPainter {
  final SunRiseSetData _data;
  double startEndPadding = ScreenUtils.setWidth(50);
  double topBottomPadding = ScreenUtils.setHeight(50);

  double startX;
  double startY;
  double endX;
  double endY;

  Offset nowOffsetOnCurve;

  _SunRiseSetPainter(this._data);

  bool hasInit = false;
  Path _path;
  Paint _paint;
  Paint _sunPaint;

  @override
  void paint(Canvas canvas, Size size) {
    _init();
    startX = startEndPadding;
    startY = size.height - topBottomPadding;
    endX = size.width - startEndPadding;
    endY = size.height - topBottomPadding;

    _path.reset();
    _path.moveTo(startX, startY);
    _path.quadraticBezierTo(size.width / 2, topBottomPadding, endX, endY);

    _initNowOffsetCurve();
    _drawCurve(canvas, size);
    _drawTimeText(canvas);

    canvas.drawCircle(nowOffsetOnCurve, 4, _sunPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _init() {
    if (hasInit) {
      return;
    }
    _path = Path();
    _paint = Paint();
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2;
    _paint.color = Colors.white;

    _sunPaint = Paint();
    _sunPaint.style = PaintingStyle.fill;
    _sunPaint.color = Colors.yellow;
    hasInit = true;
  }

  void _initNowOffsetCurve() {
    final now = DateTime.now();
    final nowMilliseconds = now.hour * 1000 * 60 * 60 + now.minute * 1000 * 60;
    final endTime = nowMilliseconds <= _data.sunsetTime
        ? nowMilliseconds
        : _data.sunsetTime;
    final ratio = (endTime - _data.sunriseTime) /
        (_data.sunsetTime - _data.sunriseTime);
    final metrics = _path.computeMetrics();
    final pm = metrics.elementAt(0);
    nowOffsetOnCurve = pm.getTangentForOffset(pm.length * ratio).position;
  }

  Paragraph _buildText(String text) {
    final pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 12.0,
    ));
    pb.addText(text);
    return pb.build()..layout(ParagraphConstraints(width: 30));
  }

  void _drawTimeText(Canvas canvas) {
    final now = DateTime.now();
    final nowText = _buildText(
        "${DateUtils.completion(now.hour)}:${DateUtils.completion(now.minute)}");
    canvas.drawParagraph(
      nowText,
      Offset(
        nowOffsetOnCurve.dx - nowText.width / 2,
        nowOffsetOnCurve.dy - 30,
      ),
    );

    final sunriseText =
    _buildText(DateUtils.formatByHHMM(_data.sunriseTime.toString()));
    canvas.drawParagraph(
      sunriseText,
      Offset(startX - sunriseText.width / 2, startY),
    );
    final sunsetText =
    _buildText(DateUtils.formatByHHMM(_data.sunsetTime.toString()));
    canvas.drawParagraph(
      sunsetText,
      Offset(endX - sunsetText.width / 2, startY),
    );
  }
  
  void _drawCurve(Canvas canvas, Size size) {
    canvas.drawPath(dashPath(_path, dashArray: CircularIntervalList<double>([10, 5])), _paint);

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, nowOffsetOnCurve.dx, size.height));
    canvas.drawPath(_path, _paint);
    canvas.restore();
  }
}

class SunRiseSetData {
  int sunriseTime;
  int sunsetTime;

  SunRiseSetData(this.sunriseTime, this.sunsetTime);

  @override
  String toString() {
    return 'SunRiseSetData{sunriseTime: $sunriseTime, sunsetTime: $sunsetTime}';
  }
}
