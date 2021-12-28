// Package imports:
import 'package:supercharged/supercharged.dart';

class TimeUtils {
  static String secondsToHumanReadable(int sec) {
    var minutes = (sec ~/ 60).toString();
    var seconds = (sec % 60).toString();
    if (seconds.length == 1) seconds = '0$seconds';
    if (minutes.length == 1) minutes = '0$minutes';
    if (sec > 1.hours.inSeconds) {
      var hours = (int.parse(minutes) ~/ 60).toString();
      minutes = (int.parse(minutes) - (int.parse(hours) * 60)).toString();
      if (hours.length == 1) hours = '0$hours';
      if (minutes.length == 1) minutes = '0$minutes';
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  static String dateTimetoHumanReadable(DateTime dt) {
    var hour = (dt.hour > 12 ? dt.hour - 12 : dt.hour).toString();
    var minutes = dt.minute.toString();
    if (hour.length == 1) hour = '0$hour';
    if (minutes.length == 1) minutes = '0$minutes';
    return '$hour:$minutes';
  }
}
