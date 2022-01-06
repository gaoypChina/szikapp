import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/app_scaffold.dart';

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
    return Center(
      child: SzikAppScaffold(
        withNavigationBar: false,
        appBarTitle: 'SETTINGS_TITLE'.tr(),
      ),
    );
  }
}
