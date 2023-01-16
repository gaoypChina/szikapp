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
            const SizedBox(height: kPaddingLarge),
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
  late DateTime _startDate;
  late DateTime _endDate;
  bool _hasOpenPeriod = false;
  late CleaningPeriod _openPeriod;
  late CleaningPeriod _activePeriod;

  @override
  void initState() {
    super.initState();
    _hasOpenPeriod = widget.manager.periods
        .any((element) => element.start.isAfter(DateTime.now()));
    _openPeriod = widget.manager.periods
        .firstWhere((element) => element.start.isAfter(DateTime.now()));
    _startDate = _hasOpenPeriod ? _openPeriod.start : DateTime.now();
    _endDate = _hasOpenPeriod
        ? _openPeriod.end
        : _startDate.add(const Duration(days: 31));
    _activePeriod = widget.manager.periods.firstWhere(
        (element) => DateTime.now().isInInterval(element.start, element.end));
  }

  void _onStartChanged(DateTime? newDate) {
    setState(() {
      _startDate = newDate ?? DateTime.now();
    });
  }

  void _onEndChanged(DateTime? newDate) {
    setState(() {
      _endDate = newDate ?? DateTime.now();
    });
  }

  void _onNewPeriod() {
    var uuid = const Uuid();
    var newPeriod = CleaningPeriod(
      id: uuid.v4().toUpperCase(),
      start: _startDate,
      end: _endDate,
      lastUpdate: DateTime.now(),
    );

    widget.manager.createCleaningPeriod(newPeriod);
    widget.manager.refreshPeriods();
    setState(() {
      _hasOpenPeriod = true;
    });
  }

  void _onEditPeriod() {
    _openPeriod.start = _startDate;
    _openPeriod.end = _endDate;
    _openPeriod.lastUpdate = DateTime.now();
    widget.manager.editCleaningPeriod(_openPeriod);
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
                _hasOpenPeriod
                    ? 'CLEANING_ADMIN_EDIT_PERIOD'.tr()
                    : 'CLEANING_ADMIN_NEW_PERIOD'.tr(),
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
                    initialDate: _startDate,
                    endDate: _endDate,
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
                    initialDate: _endDate,
                    startDate: _startDate,
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
                    '${_endDate.difference(_startDate).inDays * 2}',
                    style: theme.textTheme.headline3,
                  )
                ],
              ),
              const SizedBox(height: kPaddingNormal),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!_hasOpenPeriod)
                    ElevatedButton(
                      onPressed: _onNewPeriod,
                      child: Text(
                        'BUTTON_SAVE'.tr(),
                        style: theme.textTheme.overline!.copyWith(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  if (_hasOpenPeriod) ...[
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
            border: Border.all(color: theme.colorScheme.primaryContainer),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: kPaddingNormal,
            horizontal: kPaddingLarge,
          ),
          child: Column(
            children: [
              Text(
                'CLEANING_ADMIN_ACTIVE_PERIOD'.tr(),
                style: theme.textTheme.headline5,
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_START'.tr(),
                    style: theme.textTheme.headline5,
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd.').format(_activePeriod.start),
                    style: theme.textTheme.button!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
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
                  Text(
                    DateFormat('yyyy.MM.dd.').format(_activePeriod.end),
                    style: theme.textTheme.button!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
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
                    '${_activePeriod.end.difference(_activePeriod.start).inDays * 2}',
                    style: theme.textTheme.headline3,
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
