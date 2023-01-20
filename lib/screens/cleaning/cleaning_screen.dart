import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../ui/themes.dart';
import 'cleaning_apply_view.dart';
import 'cleaning_exchanges_view.dart';
import 'cleaning_tasks_view.dart';

class CleaningScreen extends StatelessWidget {
  static const String route = '/cleaning';

  static MaterialPage page({required KitchenCleaningManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: CleaningScreen(manager: manager),
    );
  }

  final KitchenCleaningManager manager;

  const CleaningScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: _allRefresh(),
      shimmer: const ListScreenShimmer(),
      child: CleaningScreenView(manager: manager),
    );
  }

  Future<void> _allRefresh() async {
    await manager.refreshPeriods();
    await manager.refreshTasks();
    await manager.refreshExchanges();
  }
}

class CleaningScreenView extends StatefulWidget {
  const CleaningScreenView({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final KitchenCleaningManager manager;

  @override
  State<CleaningScreenView> createState() => _CleaningScreenViewState();
}

class _CleaningScreenViewState extends State<CleaningScreenView> {
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
        return CleaningApplyView(manager: widget.manager);
      case 2:
        return CleaningExchangesView(manager: widget.manager);
      case 1:
      default:
        return CleaningTasksView(manager: widget.manager);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'CLEANING_TITLE'.tr(),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => widget.manager.adminEdit(),
        typeToCreate: CleaningPeriod,
        icon: CustomIcons.wrench,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(
          kPaddingNormal,
          kPaddingSmall,
          kPaddingNormal,
          0,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pictures/background_1.jpg'),
            fit: BoxFit.cover,
          ),
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
              wrapColor: Colors.transparent,
              onChanged: _onTabChanged,
            ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }
}
