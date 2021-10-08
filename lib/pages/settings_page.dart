import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String route = '/settings';

  const SettingsPage({Key key = const Key('SettingsPage')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings'),
    );
  }
}
