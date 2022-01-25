import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';
import 'shimmers/card_shimmer.dart';

class BirthdayBar extends StatelessWidget {
  final IO io;

  final Map<int, String> dayToIdiom = {
    0: 'CALENDAR_TODAY'.tr(),
    1: 'CALENDAR_TOMORROW'.tr(),
    2: 'CALENDAR_DAY_AFTER_TOMORROW'.tr(),
  };

  BirthdayBar({Key? key})
      : io = IO(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: io.getBirthdays(),
      builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CardShimmer();
        } else if (snapshot.hasData) {
          var birthdayUsers = <UserData>[];
          birthdayUsers.add(snapshot.data!.first);
          var birthdayNames = birthdayUsers.first.showableName;
          var daysToBirthday = DateTime(
            DateTime.now().year,
            birthdayUsers.first.birthday!.month,
            birthdayUsers.first.birthday!.day,
          ).difference(DateTime.now()).inDays;
          for (var element in snapshot.data!) {
            if (element.id != birthdayUsers.first.id) {
              var daysToBirthdayElement = DateTime(
                DateTime.now().year,
                element.birthday!.month,
                element.birthday!.day,
              ).difference(DateTime.now()).inDays;
              if (daysToBirthdayElement == daysToBirthday) {
                birthdayUsers.add(element);
                birthdayNames += ',${element.showableName}';
              }
            }
          }

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.cake_outlined),
                Text(
                  'FEED_BIRTHDAY'.tr(
                    args: [
                      birthdayNames,
                      dayToIdiom[daysToBirthday] ??
                          'FEED_BIRTHDAY_DAYS'.tr(
                            args: [
                              daysToBirthday.toString(),
                            ],
                          ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Text('BIRTHDAY_BAR_ERROR'.tr()),
          );
        }
      },
    );
  }
}
