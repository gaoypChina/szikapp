import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/models.dart';
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
  late bool _isAutomaticDarkModeEnabled;
  late bool _preferDarkMode;

  @override
  void initState() {
    super.initState();
    _isAutomaticDarkModeEnabled = Settings.instance.darkMode == DarkMode.system;
    _preferDarkMode = Settings.instance.darkMode == DarkMode.dark;
  }

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

  void _onAutomaticThemeChanged(bool switchState) {
    setState(() {
      _isAutomaticDarkModeEnabled = !switchState;
    });
    if (switchState) {
      Settings.instance.darkMode = DarkMode.system;
    } else {
      Settings.instance.darkMode =
          _preferDarkMode ? DarkMode.dark : DarkMode.light;
    }
  }

  void _onPreferDarkModeChanged(bool preferDarkMode) {
    setState(() {
      _preferDarkMode = preferDarkMode;
    });
    if (preferDarkMode) {
      Settings.instance.darkMode = DarkMode.dark;
    } else {
      Settings.instance.darkMode = DarkMode.light;
    }
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
          Expanded(
            child: ListView(
              children: [
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'SETTINGS_THEME'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomSwitch(
                        titleText: Text(
                          'SETTINGS_AUTOMATIC'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        onChanged: _onAutomaticThemeChanged,
                        initValue: _isAutomaticDarkModeEnabled,
                      ),
                      CustomSwitch(
                        titleText: Text(
                          'SETTINGS_DARKMODE'.tr(),
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: _isAutomaticDarkModeEnabled
                                        ? Theme.of(context).colorScheme.primary
                                        : szikGunSmoke,
                                  ),
                        ),
                        onChanged: _onPreferDarkModeChanged,
                        enabled: _isAutomaticDarkModeEnabled,
                        initValue: _preferDarkMode,
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'SETTINGS_LANGUAGE'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomRadioList(
                        labels: [
                          Language.en.toCapitalizedString(),
                          Language.hu.toCapitalizedString(),
                        ],
                        onChanged: (String value) {},
                      )
                    ],
                  ),
                ),
                //Hangerő
                CustomSlider(
                  titleText: Text(
                    'SETTINGS_VOLUME'.tr(),
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  onChanged: (double value) {},
                ),
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
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'SETTINGS_NOTIFICATIONS'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      CustomSwitch(
                        titleText: Text(
                          'SETTINGS_APP_NOTIFICATIONS'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        onChanged: (bool switchState) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                //Shortcutok
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
                  child: CustomCheckboxList(
                    title: Text(
                      'SETTINGS_SHORTCUTS'.tr(),
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    checkboxLabels: const [
                      'Alfa',
                      'Béta',
                      'Gamma',
                      'Delta',
                      'Epszilon',
                      'Théta',
                      'Ordó',
                      'Omega'
                    ],
                    maxEnabled: 3,
                    onChanged: (List<bool> value) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
