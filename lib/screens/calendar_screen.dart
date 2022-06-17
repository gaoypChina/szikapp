import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../business/calendar_manager.dart';
import '../components/components.dart';
import '../ui/themes.dart';

class CalendarScreen extends StatelessWidget {
  static const String route = '/calendar';

  static MaterialPage page({
    required CalendarManager manager,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: CalendarScreen(
        manager: manager,
      ),
    );
  }

  final CalendarManager manager;

  const CalendarScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
      shimmer: const ListScreenShimmer(),
      child: CustomScaffold(
        appBarTitle: 'CALENDAR_TITLE'.tr(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomIcon(
                CustomIcons.calendar,
                size: kIconSizeXLarge,
                color: theme.colorScheme.primary,
              ),
              Text(
                'CALENDAR_HELP_TEXT'.tr(),
                style: theme.textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Link(
                uri: Uri.parse(
                  'https://calendar.google.com/calendar/u/1/r?cid=c3plbnRpZ25hYy5odV91c3M2YzJldGMzaDExbmRsZmQyMm5oMXBqZ0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t',
                ),
                target: LinkTarget.defaultTarget,
                builder: (context, followLink) {
                  return InkWell(
                    onTap: followLink,
                    child: Text(
                      'CALENDAR_LINK_TEXT'.tr(),
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
