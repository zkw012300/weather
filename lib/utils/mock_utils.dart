import 'dart:math';

import 'package:weather/model/hours_data.dart';
import 'package:weather/view/widget/hours_line_chart.dart';

List<HourData> mockHoursData({int size = 24}) {
  final List<HourData> mockData = List();
  final random = Random();
  final downGap = 20 + random.nextInt(5);
  final upGap = 30 + random.nextInt(5);
  final weatherList = [
    HourData.WEATHER_1,
    HourData.WEATHER_2,
    HourData.WEATHER_3,
    HourData.WEATHER_4
  ];
  int next = random.nextInt(size);
  String currentWeather = weatherList[random.nextInt(weatherList.length)];
  for (int i = 1; i <= size; i++) {
    if (i >= next) {
      if (next >= size * 5 / 6) {
        next = size;
      } else {
        next = next + random.nextInt(size - next);
      }
      currentWeather = weatherList[random.nextInt(weatherList.length)];
    }
    final time = i % 24;
    final temperate = random.nextInt(upGap - downGap) + downGap;
    final weather = currentWeather;
    mockData.add(HourData(time, temperate, weather));
  }
  return mockData;
}
