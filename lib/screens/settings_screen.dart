import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

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
    super.key = const Key('SettingsScreen'),
    this.withNavigationBar = true,
    this.withBackButton = true,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isAutomaticDarkModeEnabled;
  late bool _preferDarkMode;
  late Language _preferredLanguage;
  late List<int> _feedShortcuts;
  late List<NotificationTopic> _notifications;

  @override
  void initState() {
    super.initState();
    _isAutomaticDarkModeEnabled = Settings.instance.darkMode == DarkMode.system;
    _preferDarkMode = Settings.instance.darkMode == DarkMode.dark;
    _preferredLanguage = Settings.instance.language;
    _feedShortcuts = Settings.instance.feedShortcuts;
    _notifications = Settings.instance.notificationSettings;
  }

  List<bool> _getNotificationSwitchValues(List<NotificationTopic> topics) {
    var result = <bool>[];
    for (var item in notificationSettings.keys) {
      if (topics.contains(item)) {
        result.add(true);
      } else {
        result.add(false);
      }
    }
    return result;
  }

  List<NotificationTopic> _getNotificationEnumValues(List<bool> newValues) {
    var result = <NotificationTopic>[];
    for (var index in List.generate(newValues.length, (index) => index)) {
      if (newValues[index]) {
        result.add(List.from(notificationSettings.keys)[index]);
      }
    }
    return result;
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
    Settings.instance.savePreferences();
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
    if (!Provider.of<AuthManager>(context, listen: false).isUserGuest) {
      Settings.instance.savePreferences();
    }
  }

  void _onLanguageChanged(String preferedLanguage) {
    var language = Language.values.firstWhere(
        (enumValue) => enumValue.toCapitalizedString() == preferedLanguage);
    setState(() {
      _preferredLanguage = language;
      if (language == Language.hu) {
        context.setLocale(const Locale('hu'));
      } else {
        context.setLocale(const Locale('en'));
      }
    });
    Settings.instance.language = language;
    if (!Provider.of<AuthManager>(context, listen: false).isUserGuest) {
      Settings.instance.savePreferences();
    }
  }

  void _onFeedShortcutsChanged(List<bool> newValues) {
    var intList = boolListToInt(newValues);
    setState(() {
      _feedShortcuts = intList;
    });
    Settings.instance.feedShortcuts = intList;
    Settings.instance.savePreferences();
  }

  void _onNotificationsChanged(List<bool> newValues) {
    var newEnumValues = _getNotificationEnumValues(newValues);
    var positiveDifference =
        newEnumValues.toSet().difference(_notifications.toSet()).toList();
    if (positiveDifference.isNotEmpty) {
      NotificationManager.instance.subscribeToTopics(positiveDifference);
    }
    var negativeDifference =
        _notifications.toSet().difference(newEnumValues.toSet()).toList();
    if (negativeDifference.isNotEmpty) {
      NotificationManager.instance.unsubscribeFromTopics(negativeDifference);
    }
    setState(() {
      _notifications = newEnumValues;
    });
    Settings.instance.notificationSettings = newEnumValues;
    Settings.instance.savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var userCanModify = Provider.of<AuthManager>(context)
            .user
            ?.hasPermission(permission: Permission.profileEdit) ??
        false;
    return CustomScaffold(
      withNavigationBar: widget.withNavigationBar,
      withBackButton: widget.withBackButton,
      appBarTitle: 'SETTINGS_TITLE'.tr(),
      body: Padding(
        padding: const EdgeInsets.only(top: kPaddingNormal),
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
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'SETTINGS_THEME'.tr(),
                      style: theme.textTheme.displaySmall!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomSwitch(
                    titleText: Text(
                      'SETTINGS_AUTOMATIC'.tr(),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onChanged: _onAutomaticThemeChanged,
                    initValue: _isAutomaticDarkModeEnabled,
                  ),
                  CustomSwitch(
                    titleText: Text(
                      'SETTINGS_DARKMODE'.tr(),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: _isAutomaticDarkModeEnabled
                            ? theme.colorScheme.secondaryContainer
                            : theme.colorScheme.primary,
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
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'SETTINGS_LANGUAGE'.tr(),
                      style: theme.textTheme.displaySmall!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomRadioList(
                    radioLabels: [
                      Language.en.toCapitalizedString(),
                      Language.hu.toCapitalizedString(),
                    ],
                    initValue: _preferredLanguage.toCapitalizedString(),
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
                style: theme.textTheme.headline3!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
              ),
              onChanged: _onVolumeChanged,
            ),*/
            //Értesítések
            if (userCanModify)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kPaddingLarge),
                margin: const EdgeInsets.symmetric(
                  vertical: kPaddingSmall,
                  horizontal: kPaddingLarge,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kBorderRadiusNormal),
                  ),
                  border: Border.all(color: theme.colorScheme.primary),
                ),
                child: CustomSwitchList(
                  title: Text(
                    'SETTINGS_NOTIFICATIONS'.tr(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  switchLabels: notificationSettings.entries
                      .map((e) => e.value.label)
                      .toList(),
                  enabled: notificationSettings.entries
                      .map((e) => e.value.enabled)
                      .toList(),
                  initValues: _getNotificationSwitchValues(_notifications),
                  onChanged: _onNotificationsChanged,
                ),
              ),
            //Shortcutok
            if (userCanModify)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kPaddingLarge),
                margin: const EdgeInsets.symmetric(
                  vertical: kPaddingSmall,
                  horizontal: kPaddingLarge,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kBorderRadiusNormal),
                  ),
                  border: Border.all(color: theme.colorScheme.primary),
                ),
                child: CustomCheckboxList(
                  title: Text(
                    'SETTINGS_SHORTCUTS'.tr(),
                    style: theme.textTheme.displaySmall!
                        .copyWith(color: theme.colorScheme.primary),
                  ),
                  checkboxLabels: shortcutData.entries
                      .map((shortcut) => shortcut.value.name)
                      .toList(),
                  maxEnabled: 3,
                  initValues:
                      intListToBool(_feedShortcuts, shortcutData.length),
                  onChanged: _onFeedShortcutsChanged,
                ),
              ),
            //Contributors
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(kPaddingLarge),
              margin: const EdgeInsets.symmetric(
                vertical: kPaddingSmall,
                horizontal: kPaddingLarge,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'SETTINGS_CONTRIBUTORS'.tr(),
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  tilePadding: const EdgeInsets.all(0),
                  children: contributors.map<Widget>((contributor) {
                    if (contributor.message.isEmpty) {
                      return _buildContributorTile(contributor);
                    } else {
                      return EasterEgg(
                        message: contributor.message,
                        link: contributor.url,
                        child: _buildContributorTile(contributor),
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(kPaddingLarge),
              margin: const EdgeInsets.symmetric(
                vertical: kPaddingSmall,
                horizontal: kPaddingLarge,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(kBorderRadiusNormal),
                ),
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'SETTINGS_FEEDBACK'.tr(),
                      style: theme.textTheme.displaySmall!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Link(
                      uri: Uri.parse('mailto:szikapp@gmail.com'),
                      target: LinkTarget.defaultTarget,
                      builder: (context, followLink) {
                        return InkWell(
                          onTap: followLink,
                          child: Text(
                            'SETTINGS_FEEDBACK_EMAIL'.tr(),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Link(
                      uri: Uri.parse('https://forms.gle/N1UrjXHg4S38wC3NA'),
                      target: LinkTarget.defaultTarget,
                      builder: (context, followLink) {
                        return InkWell(
                          onTap: followLink,
                          child: Text(
                            'SETTINGS_NORMAL_FEEDBACK'.tr(),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Link(
                      uri: Uri.parse('https://forms.gle/GJNgJzTW8b5Ec6Zv6'),
                      target: LinkTarget.defaultTarget,
                      builder: (context, followLink) {
                        return InkWell(
                          onTap: followLink,
                          child: Text(
                            'SETTINGS_BUGREPORT'.tr(),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributorTile(
      ({String name, String message, String url}) contributor) {
    return ListTile(
      title: Text(contributor.name),
    );
  }
}
