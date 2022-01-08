import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/auth_manager.dart';
import '../components/components.dart';
import '../models/notification.dart';
import '../navigation/navigation.dart';

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
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<SzikAppNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    notifications = [
      SzikAppNotification(
        title: 'Belló konyhatakát cserélne veled',
        route: SzikAppLink(),
      ),
      SzikAppNotification(
        title: 'Sikeresen lefoglaltad a Catant',
        route: SzikAppLink(),
      ),
      SzikAppNotification(
        title: 'Gyuri kicserélte az égőt a szobádban',
        route: SzikAppLink(),
      ),
    ];
  }

  void _onClearAllNotificationsPressed() {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var showName =
        Provider.of<AuthManager>(context, listen: false).user!.nick ??
            Provider.of<AuthManager>(context, listen: false)
                .user!
                .name
                .split(' ')[1];
    return Container(
      padding:
          const EdgeInsets.fromLTRB(20, 30, 20, kBottomNavigationBarHeight),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/pictures/background_1.jpg'),
            fit: BoxFit.cover),
      ),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () =>
                  Provider.of<SzikAppStateManager>(context, listen: false)
                      .selectFeature(SzikAppFeature.profile),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'FEED_GREETINGS'.tr(args: [showName]),
                      style: theme.textTheme.headline1!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    foregroundImage: NetworkImage(
                      Provider.of<AuthManager>(context, listen: false)
                          .user!
                          .profilePicture
                          .toString(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: BirthdayBar(),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WrappedIconButton(
                  assetPath: 'assets/icons/bell_light_72.png',
                  color: theme.colorScheme.primaryVariant,
                  backgroundColor: theme.colorScheme.background,
                ),
                WrappedIconButton(
                  assetPath: 'assets/icons/bell_light_72.png',
                  color: theme.colorScheme.primaryVariant,
                  backgroundColor: theme.colorScheme.background,
                ),
                WrappedIconButton(
                  assetPath: 'assets/icons/bell_light_72.png',
                  color: theme.colorScheme.primaryVariant,
                  backgroundColor: theme.colorScheme.background,
                ),
                WrappedIconButton(
                  assetPath: 'assets/icons/bell_light_72.png',
                  color: theme.colorScheme.primaryVariant,
                  backgroundColor: theme.colorScheme.background,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: const EdgeInsets.only(left: 10),
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
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: theme.colorScheme.background,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: notifications.map<Container>((item) {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 5),
                      child: ColorFiltered(
                        child: Image.asset(item.iconPath),
                        colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary, BlendMode.srcIn),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: Text(
                        item.title,
                        style: theme.textTheme.bodyText1!.copyWith(
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
