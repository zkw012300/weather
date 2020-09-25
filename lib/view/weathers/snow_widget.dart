import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/base/weather_individual_object.dart';
import 'package:weather/utils/image_utils.dart';
import 'package:weather/utils/log_utils.dart';
import 'package:weather/utils/screen_utils.dart';

class SnowWeather extends StatefulWidget {
  @override
  State createState() {
    return _SnowWeatherState();
  }
}

class _SnowWeatherState extends State<SnowWeather>
    with SingleTickerProviderStateMixin {
  final List<SnowFlake> _snowFlakes = List();
  final List<ui.Image> _snowFlakeImages = List();

  AnimationController _controller;

  void _initAssets() async {
    _snowFlakes.clear();
    _snowFlakeImages.clear();

    final image = await ImageUtils.getImage("images/snow.webp");
    _snowFlakeImages.add(image);

    for (int i = 0; i < 50; i++) {
      _snowFlakes.add(SnowFlake.generate(_snowFlakeImages.first));
    }

    setState(() {});
  }

  void _initController() {
    _controller =
        AnimationController(duration: Duration(minutes: 1), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      _move();
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
    _controller.forward();
  }

  void _move() {
    _snowFlakes.forEach((element) {
      element.y = element.y + element.speed;
      element.x = element.x + element.kazeSpeed;
    });
  }

  @override
  void initState() {
    super.initState();
    _initAssets();
    _initController();
    // _test();
  }

  void _test() async {
    final permission = await requestPermission();
    LogUtils.log("Location", "permission = $permission");
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      Position position = await getCurrentPosition();
      LogUtils.log("Location", "position = $position");
      final coordinates = new Coordinates(position.latitude, position.longitude);
      final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      LogUtils.log("Location", "addresses ${addresses.first.subLocality}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _background(),
        _painter(),
      ],
    );
  }

  Widget _background() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6989BA), Color(0xFF9DB0CE)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _painter() {
    return CustomPaint(
      painter: _SnowWeatherPainter(
        DrawParameter(_snowFlakes, _snowFlakeImages),
      ),
    );
  }
}

class _SnowWeatherPainter extends CustomPainter {
  static const TAG = "SnowWeatherPainter";

  final _paint = Paint();

  DrawParameter _parameter;

  _SnowWeatherPainter(this._parameter);

  @override
  void paint(Canvas canvas, Size size) {
    if (_parameter.snowFlakes.isEmpty) {
      return;
    }
    _parameter.snowFlakes.forEach((element) {
      element.draw(canvas, _paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DrawParameter {
  List<SnowFlake> snowFlakes;
  List<ui.Image> snowFlakeImages = List();

  DrawParameter(this.snowFlakes, this.snowFlakeImages);
}

class SnowFlake extends WeatherIndividualObject {
  static SnowFlake generate(ui.Image snowFlakeImage) {
    SnowFlake snowFlake = SnowFlake();
    snowFlake.snowFlakeImage = snowFlakeImage;
    snowFlake._init();
    return snowFlake;
  }

  ui.Image snowFlakeImage;

  /// 雪花颗粒飘落速度
  double speed;

  /// 横向风速
  double kazeSpeed;

  /// 雪花颗粒坐标x
  double x;

  /// 雪花颗粒坐标y
  double y;

  /// 雪花颗粒透明度
  double alpha;

  /// 雪花颗粒的缩放
  double scale;

  void _init() {
    final random = Random();
    final scaleThreshold = 0.4;
    final alphaThreshold = 0.3;
    x = random.nextDouble() * ScreenUtils.width;
    y = random.nextDouble() * ScreenUtils.height * 0.1;
    speed = random.nextDouble() * 3 + 2;
    int kazeDirection;
    if (random.nextDouble() < 0.5) {
      kazeDirection = -1;
    } else {
      kazeDirection = 1;
    }
    kazeSpeed = (random.nextDouble() * 0.5) * kazeDirection;
    scale = random.nextDouble() * (1 - scaleThreshold) + scaleThreshold;
    alpha = random.nextDouble() * (1 - alphaThreshold) + alphaThreshold;
  }

  @override
  void draw(Canvas canvas, Paint paint) {
    if (y >= ScreenUtils.height || x >= ScreenUtils.width || x <= 0) {
      _init();
    }
    final _identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      alpha,
      0,
    ]);
    paint.colorFilter = _identity;
    ui.Offset offset = ui.Offset(x, y);
    canvas.save();
    canvas.scale(scale, scale);
    canvas.drawImage(snowFlakeImage, offset, paint);
    canvas.restore();
  }
}
