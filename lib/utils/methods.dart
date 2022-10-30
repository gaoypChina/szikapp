import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import 'exceptions.dart';

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

extension StringExtension on String {
  ///Extension function on [String]s to correct [Textoverflow.ellipsis] behaviour
  ///on flexible text widgets.
  String useCorrectEllipsis() {
    return replaceAll('', '\u200b');
  }
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

  String readableRemainingTime({String until = ''}) {
    var difference = this.difference(DateTime.now());
    var answer = '';
    if (difference.isNegative) {
      answer = 'NO_TIME_LEFT'.tr();
    } else {
      if (difference.inDays > 0) {
        answer = 'DAYS_LEFT'.tr(args: [difference.inDays.toString(), until]);
      } else if (difference.inHours > 0) {
        answer = 'HOURS_LEFT'.tr(args: [difference.inHours.toString(), until]);
      } else {
        answer =
            'MINUTES_LEFT'.tr(args: [difference.inMinutes.toString(), until]);
      }
    }
    return answer;
  }
}

Future<void> openUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw NotSupportedBrowserFunctionalityException(url);
  }
}
