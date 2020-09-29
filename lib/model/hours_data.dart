class HourData {
  static const WEATHER_1 = "1";
  static const WEATHER_2 = "2";
  static const WEATHER_3 = "3";
  static const WEATHER_4 = "4";

  HourData(int hour, this.temperate, this.weather) {
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
