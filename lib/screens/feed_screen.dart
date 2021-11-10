import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'profile_screen.dart';

class FeedListItem {
  String title;
  String route;
  String iconPath;

  FeedListItem({
    required this.title,
    required this.route,
    required this.iconPath,
  });
}

class FeedScreen extends StatefulWidget {
  static const String route = '/feed';

  const FeedScreen({Key key = const Key('FeedScreen')}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<FeedListItem> feedItems;

  @override
  void initState() {
    super.initState();
    feedItems = <FeedListItem>[
      FeedListItem(
        title: 'Notification',
        route: ProfileScreen.route,
        iconPath: 'assets/icons/profile_light_72.png',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var showName = SZIKAppState.authManager.user!.nick ??
        SZIKAppState.authManager.user!.name.split(' ').last;
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
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.background.withOpacity(0.65),
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(ProfileScreen.route),
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
                      SZIKAppState.authManager.user!.profilePicture.toString(),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'FEED_NOTIFICATIONS'.tr(),
              style: theme.textTheme.headline2!.copyWith(
                fontSize: 20,
                color: theme.colorScheme.background,
              ),
            ),
          ),
          Column(
            children: feedItems.map<Container>((item) {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background.withOpacity(0.65),
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
