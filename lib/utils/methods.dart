import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigation/navigation.dart';
import 'utils.dart';

String userIDsToString(BuildContext context, List<String> userIDs) {
  var users = Provider.of<SzikAppStateManager>(context).users;
  return userIDs
      .map((userID) => users.firstWhere((user) => user.id == userID).name)
      .join(', ');
}

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
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

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
