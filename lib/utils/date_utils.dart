import 'package:weather/utils/log_utils.dart';

const _TAG = "DateUtils";

class DateUtils {

  static get currentMilliseconds => DateTime.now().millisecondsSinceEpoch;

  static String formatByHHMM(String text) {
    try {
      int time = int.parse(text);
      int hour = time / 1000 / 60 ~/ 60;
      int minutes = time % (60 * 60 * 1000) ~/ (60 * 1000);
      return "${completion(hour)}:${completion(minutes)}";
    } catch (e) {
      printLog(_TAG, "error $e");
      return "";
    }
  }

  static String completion(int i) {
    if (i >= 10) {
      return i.toString();
    } else {
      return "0$i";
    }
  }
}