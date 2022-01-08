import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

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
          var theme = Theme.of(context);
          return Shimmer.fromColors(
            baseColor: theme.colorScheme.background.withOpacity(0.2),
            highlightColor: theme.colorScheme.background.withOpacity(0.5),
            child: Container(
              height: kIconSizeXLarge,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          );
        } else if (snapshot.hasData) {}
        var birthdayUser = snapshot.data!.first;
        var daysToBirthday = DateTime(
          DateTime.now().year,
          birthdayUser.birthday!.month,
          birthdayUser.birthday!.day,
        ).difference(DateTime.now()).inDays;
        var showName = birthdayUser.nick ?? birthdayUser.name.split(' ')[1];
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
                    showName,
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
      },
    );
  }
}
