import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../ui/themes.dart';
import 'cleaning_apply_view.dart';
import 'cleaning_exchanges_view.dart';
import 'cleaning_tasks_view.dart';

class CleaningScreen extends StatefulWidget {
  static const String route = '/cleaning';

  final KitchenCleaningManager manager;

  static MaterialPage page({required KitchenCleaningManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: CleaningScreen(manager: manager),
    );
  }

  const CleaningScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  bool isApplyingLive = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    isApplyingLive = widget.manager.periods
        .any((element) => element.start.isAfter(DateTime.now()));
    if (!isApplyingLive) _selectedTab = 1;
  }

  void _onTabChanged(int? newValue) {
    var newTab = newValue ?? 0;
    if (!isApplyingLive) newTab += 1;
    setState(() {
      _selectedTab = newTab;
    });
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 0:
        return const CleaningApplyView();
      case 2:
        return const CleaningExchangesView();
      case 1:
      default:
        return const CleaningTasksView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'CLEANING_TITLE'.tr(),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => widget.manager.adminEdit(),
        typeToCreate: CleaningPeriod,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          kPaddingNormal,
          kPaddingNormal,
          kPaddingNormal,
          0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TabChoice(
              labels: [
                if (isApplyingLive) 'CLEANING_TAB_APPLY'.tr(),
                'CLEANING_TAB_TASKS'.tr(),
                'CLEANING_TAB_EXCHANGES'.tr(),
              ],
              onChanged: _onTabChanged,
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }
}
