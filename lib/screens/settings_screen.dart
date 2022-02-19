import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/app_scaffold.dart';
import '../components/components.dart';
import '../components/slider.dart';
import '../components/switch.dart';
import '../ui/themes.dart';

class SettingsScreen extends StatefulWidget {
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
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _onSearchFieldChanged(String query) {
    /*var newItems = widget.manager.search(query);
    setState(() {
      items = newItems;
    });*/
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  bool _isAutomaticDarkModeEnabled = false;

  void _onAutomaticThemeChanged(bool switchState) {
    setState(() {
      _isAutomaticDarkModeEnabled = !switchState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        withNavigationBar: false,
        appBarTitle: 'SETTINGS_TITLE'.tr(),
        body: Column(
          children: [
            SearchBar(
              onChanged: _onSearchFieldChanged,
              validator: _validateTextField,
              placeholder: 'PLACEHOLDER_SEARCH'.tr(),
            ),
            //Megjelenés
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text('SETTINGS_THEME'.tr(),
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                  CustomSwitch(
                      titleText: Text('SETTINGS_AUTOMATIC'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      onChanged: _onAutomaticThemeChanged),
                  CustomSwitch(
                    titleText: Text('SETTINGS_DARKMODE'.tr(),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: _isAutomaticDarkModeEnabled
                                ? Theme.of(context).colorScheme.primary
                                : szikGunSmoke)),
                    onChanged: (bool value) {},
                    enabled: _isAutomaticDarkModeEnabled,
                  )
                ],
              ),
            ),
            //Nyelv
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text('SETTINGS_LANGUAGE'.tr(),
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),

            //Hangerő
            CustomSlider(
                titleText: Text('SETTINGS_VOLUME'.tr(),
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary))),
            //Értesítések
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Text('SETTINGS_NOTIFICATIONS'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ));
  }
}
