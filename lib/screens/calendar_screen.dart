import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';

class CalendarScreen extends StatelessWidget {
  static const String route = '/calendar';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: CalendarScreen(),
    );
  }

  const CalendarScreen({super.key = const Key('CalendarScreen')});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
        appBarTitle: 'CALENDAR_TITLE'.tr(),
        body: FeatureLinkPage(
          icon: CustomIcons.calendar,
          description: Text(
            'CALENDAR_HELP_TEXT'.tr(),
            style: theme.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          urls: const [
            'https://calendar.google.com/calendar/u/1/r?cid=c3plbnRpZ25hYy5odV91c3M2YzJldGMzaDExbmRsZmQyMm5oMXBqZ0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t'
          ],
          urlTexts: ['CALENDAR_LINK_TEXT'.tr()],
        ));
  }
}
