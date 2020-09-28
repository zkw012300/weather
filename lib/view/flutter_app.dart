import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/utils/screen_utils.dart';
import 'package:weather/view/weathers/snow_widget.dart';
import 'package:weather/view/widget/hours_line_chart.dart';

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  State createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          _scrollView(),
        ],
      ),
    );
  }

  Widget _scrollView() {
    final List<Widget> _widgets = [HoursLineChart()];
    final _scrollerController = ScrollController();
    _scrollerController.addListener(() {});
    return CustomScrollView(
      controller: _scrollerController,
      physics: AlwaysScrollableScrollPhysics().applyTo(BouncingScrollPhysics()),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
            return _widgets[i];
          }, childCount: _widgets.length),
        )
      ],
    );
  }

  Widget _background() {
    return SnowWeather();
  }
}
