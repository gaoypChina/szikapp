import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
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
    var authManager = Provider.of<AuthManager>(context, listen: false);
    if (authManager.isSignedIn && !authManager.isUserGuest) {
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
  }

  void _onClearAllNotificationsPressed() {
    setState(() {
      notifications = [];
    });
    SzikAppState.analytics.logEvent(name: 'notifications_clear_all');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var authManager = Provider.of<AuthManager>(context);
    var user = authManager.user;
    var appStateManager =
        Provider.of<SzikAppStateManager>(context, listen: false);

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
                  appStateManager.selectFeature(SzikAppFeature.profile),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      authManager.isSignedIn
                          ? 'FEED_GREETINGS_SIGNEDIN'
                              .tr(args: [user!.showableName])
                          : 'FEED_GREETINGS'.tr(),
                      style: theme.textTheme.headline1!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  user?.profilePicture != null
                      ? CircleAvatar(
                          foregroundImage: NetworkImage(
                            user!.profilePicture!,
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
          if (authManager.isSignedIn &&
              (user?.hasPermission(Permission.contactsView) ?? false))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
              child: BirthdayBar(),
            ),
          if (authManager.isSignedIn && !authManager.isUserGuest)
            Container(
              margin: const EdgeInsets.all(kBorderRadiusNormal),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: feedShortcuts.map<WrappedIconButton>(
                  (item) {
                    var userCanRouteToLink = (user?.hasPermissionToAccess(
                            SzikAppLink(currentFeature: item)) ??
                        false);
                    return WrappedIconButton(
                      assetPath:
                          shortcutData[item]?.assetPath ?? CustomIcons.bell,
                      color: theme.colorScheme.primaryContainer,
                      backgroundColor: theme.colorScheme.background,
                      onTap: userCanRouteToLink
                          ? () => appStateManager.selectFeature(item)
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
          authManager.isSignedIn
              ? Expanded(
                  child: notifications.isEmpty
                      ? Center(
                          child: Text(
                            'PLACEHOLDER_NOTIFICATIONS_EMPTY'.tr(),
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
                )
              : Expanded(
                  child: Center(
                    child: Text(
                      'PLACEHOLDER_NOTIFICATIONS_SIGNIN'.tr(),
                      style: theme.textTheme.headline2!.copyWith(
                        fontSize: 16,
                        color: theme.colorScheme.background,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
