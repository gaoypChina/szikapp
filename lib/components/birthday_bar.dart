import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';
import 'components.dart';

class BirthdayBar extends StatelessWidget {
  final IO io;

  final Map<int, String> dayToIdiom = {
    0: 'CALENDAR_TODAY'.tr(),
    1: 'CALENDAR_TOMORROW'.tr(),
    2: 'CALENDAR_DAY_AFTER_TOMORROW'.tr(),
  };

  BirthdayBar({super.key}) : io = IO();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: io.getBirthdays(),
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        var theme = Theme.of(context);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CardShimmer();
        } else if (snapshot.hasData) {
          var birthdayUsers = <User>[];
          birthdayUsers.add(snapshot.data!.first);
          var birthdayNames = birthdayUsers.first.showableName;
          var now = DateTime.now();
          var daysToBirthday = now
              .copyWith(
                month: birthdayUsers.first.birthday!.month,
                day: birthdayUsers.first.birthday!.day,
                hour: 0,
                minute: 0,
                second: 0,
              )
              .difference(
                now.copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                ),
              )
              .inDays;
          for (var user in snapshot.data!) {
            if (user.id != birthdayUsers.first.id) {
              var daysToBirthdayElement = now
                  .copyWith(
                    month: user.birthday!.month,
                    day: user.birthday!.day,
                    hour: 0,
                    minute: 0,
                    second: 0,
                  )
                  .difference(
                    now.copyWith(
                      hour: 0,
                      minute: 0,
                      second: 0,
                    ),
                  )
                  .inDays;
              if (daysToBirthdayElement == daysToBirthday) {
                birthdayUsers.add(user);
                birthdayNames += ', ${user.showableName}';
              }
            }
          }

          return Container(
            padding: const EdgeInsets.all(kPaddingNormal),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: theme.colorScheme.background,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(kPaddingNormal),
                  child: CustomIcon(
                    CustomIcons.gift,
                    size: kIconSizeLarge,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                Expanded(
                  child: Text(
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
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(kPaddingNormal),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: theme.colorScheme.background,
            ),
            child: Text(
              'BIRTHDAY_BAR_ERROR'.tr(),
              style: theme.textTheme.bodySmall,
            ),
          );
        }
      },
    );
  }
}
