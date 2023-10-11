import 'package:flutter/material.dart';

import '../business/business.dart';
import '../models/models.dart';
import '../ui/themes.dart';
import 'components.dart';

class NotificationCard extends StatelessWidget {
  final CustomNotification data;

  const NotificationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var notificationText =
        data.body != null ? '${data.title} - ${data.body}' : data.title;
    return Card(
      color: theme.colorScheme.background,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(kPaddingSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusNormal),
      ),
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              onPressed: null,
              icon: CustomIcon(
                data.iconPath,
                color: theme.colorScheme.secondary,
              ),
            ),
            title: Text(
              notificationText,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryContainer,
              ),
            ),
            onTap: () {
              if (data.route != null) {
                Router.of(context).routerDelegate.setNewRoutePath(data.route);
              }
            },
            trailing: IconButton(
              icon: CustomIcon(
                CustomIcons.close,
                color: theme.colorScheme.secondary,
              ),
              onPressed: () =>
                  NotificationManager.instance.dismissMessage(data),
            ),
          ),
        ],
      ),
    );
  }
}
