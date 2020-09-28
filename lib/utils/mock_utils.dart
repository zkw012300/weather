import 'dart:math';

import 'package:weather/view/widget/hours_line_chart.dart';

List<MockHourData> mockHoursData() {
  final List<MockHourData> mockData = List();
  final random = Random();
  final downGap = 20 + random.nextInt(5);
  final upGap = 30 + random.nextInt(5);
  final weatherList = [
    MockHourData.WEATHER_1,
    MockHourData.WEATHER_2,
    MockHourData.WEATHER_3,
    MockHourData.WEATHER_4
  ];
  int next = random.nextInt(24);
  String currentWeather = weatherList[random.nextInt(weatherList.length)];
  for (int i = 1; i <= 24; i++) {
    if (i >= next) {
      if (next >= 20) {
        next = 24;
      } else {
        next = next + random.nextInt(24 - next);
      }
      currentWeather = weatherList[random.nextInt(weatherList.length)];
    }
    final time = i;
    final temperate = random.nextInt(upGap - downGap) + downGap;
    final weather = currentWeather;
    mockData.add(MockHourData(time, temperate, weather));
  }
  return mockData;
}
