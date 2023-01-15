import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../ui/themes.dart';

class CleaningAdminScreen extends StatefulWidget {
  static const String route = '/cleaning/admin';
  final KitchenCleaningManager manager;

  static MaterialPage page({required KitchenCleaningManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: CleaningAdminScreen(manager: manager),
    );
  }

  const CleaningAdminScreen({
    super.key,
    required this.manager,
  });

  @override
  State<CleaningAdminScreen> createState() => _CleaningAdminScreenState();
}

class _CleaningAdminScreenState extends State<CleaningAdminScreen> {
  int _selectedTab = 0;

  void _onTabChanged(int? newTab) {
    setState(() {
      _selectedTab = newTab ?? 0;
    });
  }

  Widget _buildPeriodView() {
    return const Text('Periods');
  }

  Widget _buildPunishmentView() {
    return const Text('Punishments');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      appBarTitle: 'CLEANING_ADMIN_TITLE'.tr(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(
          kPaddingNormal,
          kPaddingSmall,
          kPaddingNormal,
          kPaddingSmall,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TabChoice(
              labels: [
                'CLEANING_TAB_PERIOD'.tr(),
                'CLEANING_TAB_PUNISHMENT'.tr(),
              ],
              wrapColor: theme.colorScheme.background,
              onChanged: _onTabChanged,
            ),
            Expanded(
              child: _selectedTab == 0
                  ? _buildPeriodView()
                  : _buildPunishmentView(),
            )
          ],
        ),
      ),
    );
  }
}
