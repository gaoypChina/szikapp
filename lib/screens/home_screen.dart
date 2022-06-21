import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/bottom_navigation_bar.dart';
import '../navigation/app_state_manager.dart';
import '../screens/screens.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  final int currentTab;

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: HomeScreen(
        currentTab: currentTab,
      ),
    );
  }

  const HomeScreen({
    Key key = const Key('HomeScreen'),
    required this.currentTab,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static List<Widget> pages = [
    const FeedScreen(),
    const MenuScreen(),
    const SettingsScreen(
      withNavigationBar: false,
      withBackButton: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (Provider.of<AuthManager>(context, listen: false).isSignedIn) {
      Provider.of<SzikAppStateManager>(context, listen: false).loadEarlyData();
      Settings.instance.loadPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SzikAppStateManager>(
      builder: (context, appStateManager, child) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: widget.currentTab,
              children: pages,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedTab: widget.currentTab,
          ),
        );
      },
    );
  }
}
