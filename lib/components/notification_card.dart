import 'package:flutter/material.dart';

import '../models/models.dart';
import '../ui/themes.dart';
import 'components.dart';

class NotificationCard extends StatelessWidget {
  final CustomNotification data;

  const NotificationCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
            leading: Container(
              width: kIconSizeNormal,
              height: kIconSizeNormal,
              margin: const EdgeInsets.only(right: kPaddingSmall),
              child: CustomIcon(
                data.iconPath,
                color: theme.colorScheme.secondary,
              ),
            ),
            title: Text(
              data.title,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryContainer,
              ),
            ),
            onTap: () {
              //Router.of(context).routerDelegate.setNewRoutePath(data.route);
            },
            trailing: IconButton(
              icon: CustomIcon(
                CustomIcons.close,
                color: theme.colorScheme.secondary,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
