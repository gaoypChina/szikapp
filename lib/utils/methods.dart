import 'package:easy_localization/easy_localization.dart';

List<int> boolListToInt(List<bool> boolList) {
  var intList = <int>[];

  for (var i = 0; i < boolList.length; i++) {
    if (boolList[i] == true) {
      intList.add(i);
    }
  }
  return intList;
}

List<bool> intListToBool(List<int> intList, int length) {
  var boolList = List<bool>.filled(length, false);

  for (var index in intList) {
    boolList[index] = true;
  }
  return boolList;
}

extension CustomDateTimeExtension on DateTime {
  DateTime roundDown({Duration delta = const Duration(hours: 1)}) {
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds,
    ).toUtc();
  }

  bool isInInterval(DateTime start, DateTime end) {
    return ((this).isAfter(start) && (this).isBefore(end));
  }

  String readableRemainingTime() {
    var difference = this.difference(DateTime.now());
    var answer = '';
    if (difference.isNegative) {
      answer = 'NO_TIME_LEFT'.tr();
    } else if (difference.inDays > 0) {
      answer = 'DAYS_LEFT'.tr(args: [difference.inDays.toString()]);
    } else if (difference.inHours > 0) {
      answer = 'HOURS_LEFT'.tr(args: [difference.inHours.toString()]);
    } else if (difference.inMinutes > 0) {
      answer = 'MINUTES_LEFT'.tr(args: [difference.inMinutes.toString()]);
    }
    return answer;
  }
}
