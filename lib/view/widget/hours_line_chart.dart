import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:weather/model/hours_data.dart';
import 'package:weather/model/text_with_point.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:weather/utils/mock_utils.dart';
import 'package:weather/utils/screen_utils.dart';

const _TAG = "HoursLineChart";

class HoursLineChart extends StatefulWidget {
  @override
  State createState() {
    return _HourLineChartState();
  }
}

class _HourLineChartState extends State<HoursLineChart> {
  List<HourData> _data = List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (_data.isEmpty) {
      widget = Container(width: 0, height: 0,);
    } else {
      widget = _scrollablePainter();
    }
    return widget;
  }

  Widget _scrollablePainter() {
    final width = 200.0 * _data.length;
    final height = 480.0;
    final Size size = Size(
      ScreenUtils.setWidth(width),
      ScreenUtils.setHeight(height),
    );
    final _painter = _HoursLineChartPainter(
      _data != null ? _data : List(),
      size,
    );
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        child: CustomPaint(
          painter: _painter,
          size: size,
        ),
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  void _getData() async {
    _data = mockHoursData(size: 47);
    setState(() {});
  }
}

class _HoursLineChartPainter extends CustomPainter {
  final List<HourData> _data;

  bool hasInit = false;
  double _temperateGap;
  double _timeGap;
  int maxTemperate;
  int minTemperate;

  double startEndPadding = ScreenUtils.setWidth(80);
  double topBottomPadding = ScreenUtils.setHeight(100);

  Path _lineChartPath;
  Paint _lineChartPaint;
  Paint _pointPaint;

  List<Offset> _linePoints;
  List<TextWithPoint> _timePoints;
  List<TextWithPoint> _temperatePoints;

  _HoursLineChartPainter(this._data, Size size) {
    _init(size);
  }

  @override
  void paint(Canvas canvas, Size size) {_lineChartPath.reset();
    for (int i = 0; i < _data.length; i++) {
      final index = i;
      Offset linePoint = _linePoints[index];
      if (index == 0) {
        _lineChartPath.moveTo(linePoint.dx, linePoint.dy);
      } else {
        _lineChartPath.lineTo(linePoint.dx, linePoint.dy);
      }
      canvas.drawCircle(linePoint, ScreenUtils.setWidth(10), _pointPaint);
      canvas.drawParagraph(
        _timePoints[index].text,
        _timePoints[index].point,
      );
      canvas.drawParagraph(
        _temperatePoints[index].text,
        _temperatePoints[index].point,
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
    _initDraw();
    _initOffsets(size);
    hasInit = true;
  }

  void _initGap(Size size) {
    maxTemperate = minTemperate = _data[0].temperate;
    _data.forEach((element) {
      if (element.temperate > maxTemperate) {
        maxTemperate = element.temperate;
      }
      if (element.temperate < minTemperate) {
        minTemperate = element.temperate;
      }
    });
    final delta = maxTemperate - minTemperate;
    printLog(
      _TAG,
      "maxTemperate = $maxTemperate, minTemperate = $minTemperate",
    );
    _temperateGap = (size.height - topBottomPadding * 2) / delta;
    _timeGap = (size.width - startEndPadding * 2) / (_data.length - 1);
  }

  void _initDraw() {
    _lineChartPaint = Paint();
    _lineChartPaint.color = Colors.white;
    _lineChartPaint.isAntiAlias = true;
    _lineChartPaint.style = PaintingStyle.stroke;
    _lineChartPaint.strokeWidth = 2;
    _lineChartPaint.strokeCap = StrokeCap.round;
    _lineChartPaint.strokeJoin = StrokeJoin.round;

    _pointPaint = Paint();
    _pointPaint.style = PaintingStyle.fill;
    _pointPaint.color = Color(0xA0FFFFFF);

    _lineChartPath = Path();
  }

  void _initOffsets(Size size) {
    _linePoints = List();
    _timePoints = List();
    _temperatePoints = List();

    for (int i = 0; i < _data.length; i++) {
      final element = _data[i];
      final index = i;
      // 温度点坐标
      double temperateX = startEndPadding + _timeGap * index.toDouble();
      double temperateY = size.height -
          topBottomPadding -
          (element.temperate - minTemperate) * _temperateGap;
      Offset linePoint = Offset(
        temperateX,
        temperateY,
      );
      _linePoints.add(linePoint);

      // 时间文本坐标
      ui.Paragraph timeText = _buildText(
        element.time,
        _timeGap,
      );
      final double timeX = temperateX - timeText.width / 2;
      final double timeY = size.height - topBottomPadding / 2;
      Offset timePoint = Offset(
        timeX,
        timeY,
      );
      _timePoints.add(TextWithPoint(timeText, timePoint));

      // 温度文本坐标
      ui.Paragraph temperateText = _buildText(
        "${element.temperate}℃",
        _timeGap,
      );
      final double temperateTextX = temperateX - temperateText.width / 2;
      final double temperateTextY = temperateY - topBottomPadding * 2 / 3;
      Offset temperateTextOffset = Offset(
        temperateTextX,
        temperateTextY,
      );
      _temperatePoints.add(TextWithPoint(temperateText, temperateTextOffset));
    }
  }

  ui.Paragraph _buildText(String text, double itemWidth,
      {double fontSize = 12.0}) {
    var pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center, //居中
      fontSize: fontSize, //大小
    ));
    pb.addText(text);
    return pb.build()..layout(ui.ParagraphConstraints(width: itemWidth));
  }
}