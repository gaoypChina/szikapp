import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../navigation/navigation.dart';
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
    super.key = const Key('HomeScreen'),
    required this.currentTab,
  });

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
    var authManager = Provider.of<AuthManager>(context, listen: false);
    if (authManager.isSignedIn && !authManager.isUserGuest) {
      Provider.of<SzikAppStateManager>(context, listen: false).loadEarlyData();
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
