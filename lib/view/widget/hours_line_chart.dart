import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/utils/mock_utils.dart';
import 'package:weather/utils/screen_utils.dart';
import 'package:weather/view/widget/blur_rect.dart';

class HoursLineChart extends StatefulWidget {
  @override
  State createState() {
    return _HourLineChartState();
  }
}

class _HourLineChartState extends State<HoursLineChart> {
  List<MockHourData> _data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: BlurRectWidget(
        child: _scrollablePainter(),
      ),
    );
  }

  Widget _scrollablePainter() {
    final width = 200.0;
    final height = 480.0;
    return SingleChildScrollView(
      child: Container(
        width: ScreenUtils.setWidth(width) * 24,
        height: ScreenUtils.setHeight(height),
        child: CustomPaint(
          painter: _HoursLineChartPainter(_data != null ? _data : List()),
          size: Size(
            ScreenUtils.setWidth(width) * 24,
            ScreenUtils.setHeight(height),
          ),
        ),
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  void _getData() async {
    _data = mockHoursData();
    setState(() {});
  }
}

class _HoursLineChartPainter extends CustomPainter {
  final List<MockHourData> _data;

  bool hasInit = false;
  double _temperateGap = -1;
  double _timeGap = -1;
  int maxTemperate = -100000;
  int minTemperate = 100000;

  double startEndPadding = ScreenUtils.setWidth(50);
  double topBottomPadding = ScreenUtils.setHeight(100);

  Path _lineChartPath;
  Paint _lineChartPaint;
  Paint _pointPaint;

  List<Offset> linePoints;
  List<Offset> timePoints;

  _HoursLineChartPainter(this._data);

  @override
  void paint(Canvas canvas, Size size) {
    if (_data.isEmpty) {
      return;
    }
    _init(size);
    _lineChartPath.reset();
    for (int i = 0; i < _data.length; i++) {
      final element = _data[i];
      final index = i;
      Offset linePoint = linePoints[index];
      if (index == 0) {
        _lineChartPath.moveTo(linePoint.dx, linePoint.dy);
      } else {
        _lineChartPath.lineTo(linePoint.dx, linePoint.dy);
      }
      canvas.drawCircle(linePoint, ScreenUtils.setWidth(10), _pointPaint);
      canvas.drawParagraph(
        _buildText(element.time, _timeGap),
        timePoints[index],
      );
    }
    canvas.drawPath(_lineChartPath, _lineChartPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _init(Size size) {
    if (hasInit) {
      return;
    }
    _initGap(size);

    _lineChartPaint = Paint();
    _lineChartPaint.color = Colors.white;
    _lineChartPaint.isAntiAlias = true;
    _lineChartPaint.style = PaintingStyle.stroke;
    _lineChartPaint.strokeWidth = 2;
    _lineChartPaint.strokeCap = StrokeCap.round;
    _lineChartPaint.strokeJoin = StrokeJoin.round;

    _pointPaint = Paint();
    _pointPaint.style = PaintingStyle.fill;
    _pointPaint.color = Color(0x80FFFFFF);

    _lineChartPath = Path();

    _initLinePoints(size);

    hasInit = true;
  }

  void _initGap(Size size) {
    _data.forEach((element) {
      if (element.temperate > maxTemperate) {
        maxTemperate = element.temperate;
      }
      if (element.temperate < minTemperate) {
        minTemperate = element.temperate;
      }
    });
    final delta = maxTemperate - minTemperate;
    _temperateGap = (size.height - topBottomPadding * 2) / delta;
    _timeGap = (size.width - startEndPadding * 2) / 24;
  }

  void _initLinePoints(Size size) {
    linePoints = List();
    timePoints = List();
    for (int i = 0; i < _data.length; i++) {
      final element = _data[i];
      final index = i;
      Offset linePoint = Offset(
        (startEndPadding + _timeGap * index) * 1.0,
        (topBottomPadding * 1.0 +
            (element.temperate - minTemperate) * _temperateGap),
      );
      Offset timePoint = Offset(
        (startEndPadding + _timeGap * index) * 1.0,
        size.height - topBottomPadding * 1.0,
      );
      linePoints.add(linePoint);
      timePoints.add(timePoint);
    }
  }

  Paragraph _buildText(String text, double itemWidth) {
    var pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center, //居中
      fontSize: 12.0, //大小
    ));
    pb.addText(text);
    return pb.build()..layout(ParagraphConstraints(width: itemWidth));
  }
}

class MockHourData {
  static const WEATHER_1 = "1";
  static const WEATHER_2 = "2";
  static const WEATHER_3 = "3";
  static const WEATHER_4 = "4";

  MockHourData(int hour, this.temperate, this.weather) {
    this.time = _time(hour);
  }

  String time;
  int temperate;
  String weather;

  String _time(int hour) {
    if (hour < 10) {
      return "0$hour:00";
    } else {
      return "$hour:00";
    }
  }

  @override
  String toString() {
    return 'MockHourData{time: $time, temperate: $temperate, weather: $weather}';
  }
}
