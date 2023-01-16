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
                  ? CleaningAdminPeriodView(manager: widget.manager)
                  : _buildPunishmentView(),
            )
          ],
        ),
      ),
    );
  }
}

class CleaningAdminPeriodView extends StatefulWidget {
  final KitchenCleaningManager manager;
  const CleaningAdminPeriodView({Key? key, required this.manager})
      : super(key: key);

  @override
  State<CleaningAdminPeriodView> createState() =>
      _CleaningAdminPeriodViewState();
}

class _CleaningAdminPeriodViewState extends State<CleaningAdminPeriodView> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = startDate.add(const Duration(days: 31));
  }

  void _onStartChanged(DateTime? newDate) {
    setState(() {
      startDate = newDate ?? DateTime.now();
    });
  }

  void _onEndChanged(DateTime? newDate) {
    setState(() {
      endDate = newDate ?? DateTime.now();
    });
  }

  void _onNewPeriod() {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusNormal),
            ),
            border: Border.all(color: theme.colorScheme.primary),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: kPaddingNormal,
            horizontal: kPaddingLarge,
          ),
          child: Column(
            children: [
              Text(
                'CLEANING_ADMIN_NEW_PERIOD'.tr(),
                style: theme.textTheme.headline6,
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_START'.tr(),
                    style: theme.textTheme.headline3!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  DatePicker(
                    onChanged: _onStartChanged,
                    initialDate: startDate,
                    endDate: endDate,
                  )
                ],
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_END'.tr(),
                    style: theme.textTheme.headline3!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  DatePicker(
                    onChanged: _onEndChanged,
                    initialDate: endDate,
                    startDate: startDate,
                  )
                ],
              ),
              const SizedBox(height: kPaddingNormal),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_ADMIN_NUMOFDAYS'.tr(),
                    style: theme.textTheme.headline3!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${endDate.difference(startDate).inDays * 2 + 2}',
                    style: theme.textTheme.headline3,
                  )
                ],
              ),
              const SizedBox(height: kPaddingNormal),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _onNewPeriod,
                    child: Text('BUTTON_SAVE'.tr()),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: kPaddingLarge),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusNormal),
            ),
            border: Border.all(color: theme.colorScheme.primary),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: kPaddingNormal,
            horizontal: kPaddingLarge,
          ),
          child: Column(
            children: [
              Text(
                'CLEANING_ADMIN_ACTIVE_PERIOD'.tr(),
                style: theme.textTheme.headline6!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_START'.tr(),
                    style: theme.textTheme.headline5,
                  ),
                  Text('xx.xx.xxxx'),
                ],
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_END'.tr(),
                    style: theme.textTheme.headline5,
                  ),
                  Text('yy.yy.yyyy'),
                ],
              ),
              const SizedBox(height: kPaddingNormal),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_ADMIN_NUMOFDAYS'.tr(),
                    style: theme.textTheme.headline5,
                  ),
                  Text('diff')
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
