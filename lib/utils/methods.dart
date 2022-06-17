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

extension CustomDateTimeExtension on DateTime {
  DateTime roundDown({Duration delta = const Duration(hours: 1)}) {
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds,
    ).toUtc();
  }

  bool isInInterval(DateTime start, DateTime end) {
    return ((this).isAfter(start) && (this).isBefore(end));
  }
}

Future<void> openUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw NotSupportedBrowserFunctionalityException(url);
  }
}
