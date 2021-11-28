import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String route = '/settings';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: SettingsScreen(),
    );
  }

  const SettingsScreen({Key key = const Key('SettingsScreen')})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings'),
    );
  }
}
