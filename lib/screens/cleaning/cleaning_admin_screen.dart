import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../ui/themes.dart';
import 'cleaning_admin_participants_view.dart';
import 'cleaning_admin_period_view.dart';
import 'cleaning_admin_supervision_view.dart';

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

  const CleaningAdminScreen({super.key, required this.manager});

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

  Widget _buildBody() {
    switch (_selectedTab) {
      case 1:
        return CleaningParticipantsView(manager: widget.manager);
      case 2:
        return CleaningAdminSupervisionView(manager: widget.manager);
      case 0:
      default:
        return CleaningAdminPeriodView(manager: widget.manager);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      appBarTitle: 'CLEANING_ADMIN_TITLE'.tr(),
      body: Container(
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TabChoice(
                labels: [
                  'CLEANING_TAB_PERIOD'.tr(),
                  'CLEANING_TAB_PARTICIPANTS'.tr(),
                  'CLEANING_TAB_SUPERVISION'.tr(),
                ],
                wrapColor: Colors.transparent,
                onChanged: _onTabChanged,
              ),
            ),
            const SizedBox(height: kPaddingSmall),
            Expanded(
              child: _buildBody(),
            )
          ],
        ),
      ),
    );
  }
}
