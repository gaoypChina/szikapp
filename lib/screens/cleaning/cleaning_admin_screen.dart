import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

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
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingNormal,
          vertical: kPaddingSmall,
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
  bool hasOpenPeriod = false;
  late CleaningPeriod openPeriod;
  late CleaningPeriod activePeriod;

  @override
  void initState() {
    super.initState();
    hasOpenPeriod = widget.manager.periods
        .any((element) => element.start.isAfter(DateTime.now()));
    openPeriod = widget.manager.periods
        .firstWhere((element) => element.start.isAfter(DateTime.now()));
    startDate = hasOpenPeriod ? openPeriod.start : DateTime.now();
    endDate = hasOpenPeriod
        ? openPeriod.end
        : startDate.add(const Duration(days: 31));
    activePeriod = widget.manager.periods.firstWhere(
        (element) => DateTime.now().isInInterval(element.start, element.end));
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

  void _onNewPeriod() {
    var uuid = const Uuid();
    var newPeriod = CleaningPeriod(
      id: uuid.v4().toUpperCase(),
      start: startDate,
      end: endDate,
      lastUpdate: DateTime.now(),
    );

    widget.manager.createCleaningPeriod(newPeriod);
    widget.manager.refreshPeriods();
    setState(() {
      hasOpenPeriod = true;
    });
  }

  void _onEditPeriod() {
    openPeriod.start = startDate;
    openPeriod.end = endDate;
    openPeriod.lastUpdate = DateTime.now();
    widget.manager.editCleaningPeriod(openPeriod);
    widget.manager.refreshPeriods();
  }

  void _onAutoAssign() {}

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
                    '${endDate.difference(startDate).inDays * 2}',
                    style: theme.textTheme.headline3,
                  )
                ],
              ),
              const SizedBox(height: kPaddingNormal),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!hasOpenPeriod)
                    ElevatedButton(
                      onPressed: _onNewPeriod,
                      child: Text(
                        'BUTTON_SAVE'.tr(),
                        style: theme.textTheme.overline!.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  if (hasOpenPeriod) ...[
                    ElevatedButton(
                      onPressed: _onEditPeriod,
                      child: Text(
                        'BUTTON_EDIT'.tr(),
                        style: theme.textTheme.overline!.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onAutoAssign,
                      child: Text(
                        'CLEANING_ADMIN_AUTO_ASSIGN'.tr(),
                        style: theme.textTheme.overline!.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ],
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
                  Text(DateFormat('yyyy.MM.dd.').format(activePeriod.start)),
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
                  Text(DateFormat('yyyy.MM.dd.').format(activePeriod.end)),
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
                  Text(
                    '${activePeriod.end.difference(activePeriod.start).inDays * 2}',
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
