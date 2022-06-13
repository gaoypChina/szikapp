import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';

class FeedScreen extends StatefulWidget {
  static const String route = '/feed';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: FeedScreen(),
    );
  }

  const FeedScreen({Key key = const Key('FeedScreen')}) : super(key: key);

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  List<CustomNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    notifications = [
      CustomNotification(
        title: 'Belló konyhatakát cserélne veled',
        route: SzikAppLink(),
      ),
      CustomNotification(
        title: 'Sikeresen lefoglaltad a Catant',
        route: SzikAppLink(),
      ),
      CustomNotification(
        title: 'Gyuri kicserélte az égőt a szobádban',
        route: SzikAppLink(),
      ),
    ];
  }

  void _onClearAllNotificationsPressed() {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var user = Provider.of<AuthManager>(context, listen: false).user!;

    var feedShortcuts = context.select(
      (Settings settings) => settings.feedShortcuts,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(
        kPaddingLarge,
        kPaddingLarge,
        kPaddingLarge,
        0,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/pictures/background_1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(kPaddingLarge),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
            ),
            child: GestureDetector(
              onTap: () =>
                  Provider.of<SzikAppStateManager>(context, listen: false)
                      .selectFeature(SzikAppFeature.profile),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'FEED_GREETINGS'.tr(args: [user.showableName]),
                      style: theme.textTheme.headline1!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  user.profilePicture != null
                      ? CircleAvatar(
                          foregroundImage: NetworkImage(
                            user.profilePicture!,
                          ),
                        )
                      : CustomIcon(
                          CustomIcons.user,
                          size: kIconSizeGiant,
                          color: theme.colorScheme.primary,
                        ),
                ],
              ),
            ),
          ),
          user.hasPermission(Permission.contactsView)
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
                  child: BirthdayBar(),
                )
              : Container(),
          Container(
            margin: const EdgeInsets.all(kBorderRadiusNormal),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: feedShortcuts.map<WrappedIconButton>(
                (item) {
                  var userCanRouteToLink = user
                      .hasPermissionToAccess(SzikAppLink(currentFeature: item));
                  return WrappedIconButton(
                    assetPath:
                        shortcutData[item]?.assetPath ?? CustomIcons.bell,
                    color: theme.colorScheme.primaryContainer,
                    backgroundColor: theme.colorScheme.background,
                    onTap: userCanRouteToLink
                        ? () => Provider.of<SzikAppStateManager>(context,
                                listen: false)
                            .selectFeature(item)
                        : null,
                  );
                },
              ).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kPaddingNormal),
            padding: const EdgeInsets.only(left: kPaddingNormal),
            child: Row(
              children: [
                Text(
                  'FEED_NOTIFICATIONS'.tr(),
                  style: theme.textTheme.headline2!.copyWith(
                    fontSize: 20,
                    color: theme.colorScheme.background,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: _onClearAllNotificationsPressed,
                    icon: CustomIcon(
                      CustomIcons.closeOutlined,
                      color: theme.colorScheme.background,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      'PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr(),
                      style: theme.textTheme.headline2!.copyWith(
                        fontSize: 16,
                        color: theme.colorScheme.background,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {},
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: notifications.map<NotificationCard>(
                        (item) {
                          return NotificationCard(data: item);
                        },
                      ).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
