import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';

class SettingsScreen extends StatefulWidget {
  static const String route = '/settings';

  final bool withNavigationBar;
  final bool withBackButton;

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: SettingsScreen(),
    );
  }

  const SettingsScreen({
    Key key = const Key('SettingsScreen'),
    this.withNavigationBar = true,
    this.withBackButton = true,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isAutomaticDarkModeEnabled;
  late bool _preferDarkMode;
  late Language _preferedLanguage;
  late List<int> _feedShortcuts;

  @override
  void initState() {
    super.initState();
    _isAutomaticDarkModeEnabled = Settings.instance.darkMode == DarkMode.system;
    _preferDarkMode = Settings.instance.darkMode == DarkMode.dark;
    _preferedLanguage = Settings.instance.language;
    _feedShortcuts = Settings.instance.feedShortcuts;
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

  void _onAutomaticThemeChanged(bool newValue) {
    setState(() {
      _isAutomaticDarkModeEnabled = newValue;
    });
    if (newValue) {
      Settings.instance.darkMode = DarkMode.system;
    } else {
      Settings.instance.darkMode =
          _preferDarkMode ? DarkMode.dark : DarkMode.light;
    }
  }

  void _onPreferDarkModeChanged(bool newValue) {
    setState(() {
      _preferDarkMode = newValue;
    });
    if (newValue) {
      Settings.instance.darkMode = DarkMode.dark;
    } else {
      Settings.instance.darkMode = DarkMode.light;
    }
  }

  void _onLanguageChanged(String preferedLanguage) {
    var language = Language.values.firstWhere(
        (element) => element.toCapitalizedString() == preferedLanguage);
    setState(() {
      _preferedLanguage = language;
    });
    Settings.instance.language = language;
  }

  void _onFeedShortcutsChanged(List<bool> boolList) {
    var intList = boolListToInt(boolList);
    setState(() {
      _feedShortcuts = intList;
    });
    Settings.instance.feedShortcuts = intList;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      withNavigationBar: widget.withNavigationBar,
      withBackButton: widget.withBackButton,
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
                  padding: const EdgeInsets.all(kPaddingLarge),
                  margin: const EdgeInsets.symmetric(
                    vertical: kPaddingSmall,
                    horizontal: kPaddingLarge,
                  ),
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
                        enabled: !_isAutomaticDarkModeEnabled,
                        initValue: _preferDarkMode,
                      )
                    ],
                  ),
                ),
                //Nyelv
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(kPaddingLarge),
                  margin: const EdgeInsets.symmetric(
                    vertical: kPaddingSmall,
                    horizontal: kPaddingLarge,
                  ),
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
                        radioLabels: [
                          Language.en.toCapitalizedString(),
                          Language.hu.toCapitalizedString(),
                        ],
                        initValue: _preferedLanguage.toCapitalizedString(),
                        onChanged: _onLanguageChanged,
                      )
                    ],
                  ),
                ),
                //Hangerő
                /*
                CustomSlider(
                  titleText: Text(
                    'SETTINGS_VOLUME'.tr(),
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  onChanged: _onVolumeChanged,
                ),*/
                //Értesítések
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(kPaddingLarge),
                  margin: const EdgeInsets.symmetric(
                    vertical: kPaddingSmall,
                    horizontal: kPaddingLarge,
                  ),
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
                  padding: const EdgeInsets.all(kPaddingLarge),
                  margin: const EdgeInsets.symmetric(
                    vertical: kPaddingSmall,
                    horizontal: kPaddingLarge,
                  ),
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
                    checkboxLabels:
                        shortcutData.entries.map((e) => e.value.name).toList(),
                    maxEnabled: 3,
                    initValues:
                        intListToBool(_feedShortcuts, shortcutData.length),
                    onChanged: _onFeedShortcutsChanged,
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
