import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/tasks.dart';
import '../ui/themes.dart';
import '../utils/methods.dart';

class InvitationCard extends StatelessWidget {
  final TimetableTask data;

  const InvitationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.background,
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(kPaddingNormal),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusNormal),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingNormal),
        child: Column(
          children: [
            Text(
              data.name,
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: kPaddingNormal),
            Text(
              data.description ?? '',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: kPaddingNormal),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy.MM.dd.').format(data.lastUpdate),
                  style: theme.textTheme.bodySmall,
                ),
                OutlinedButton(
                  onPressed: () {
                    SzikAppState.analytics.logEvent(name: 'invitation_open');
                    openUrl(data.url ?? '');
                  },
                  child: Text(
                    'BUTTON_DETAILS'.tr(),
                    style: theme.textTheme.labelLarge!.copyWith(fontSize: 12),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
