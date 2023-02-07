import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

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
    _hasOpenPeriod = widget.manager.hasOpenPeriod();
    if (_hasOpenPeriod) _openPeriod = widget.manager.getOpenPeriod();
    _startDate =
        _hasOpenPeriod ? _openPeriod.start : widget.manager.periods.last.end;
    _endDate = _hasOpenPeriod
        ? _openPeriod.end
        : _startDate.add(const Duration(days: 31));
    _activePeriod = widget.manager.getCurrentPeriod();
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

  Future<void> _onNewPeriod() async {
    try {
      var uuid = const Uuid();
      var newPeriod = CleaningPeriod(
        id: uuid.v4().toUpperCase(),
        start: _startDate,
        end: _endDate,
        lastUpdate: DateTime.now(),
        isLive: true,
      );

      await widget.manager.createCleaningPeriod(newPeriod);
      await widget.manager.refreshPeriods();
      SzikAppState.analytics.logEvent(name: 'cleaning_add_period');
      setState(() {
        _hasOpenPeriod = true;
        _openPeriod = widget.manager.getOpenPeriod();
      });
    } on IOException catch (e) {
      var snackbar = ErrorHandler.buildSnackbar(context, exception: e);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onEditPeriod() async {
    try {
      _openPeriod.start = _startDate;
      _openPeriod.end = _endDate;
      _openPeriod.lastUpdate = DateTime.now();
      await widget.manager.editCleaningPeriod(_openPeriod);
      await widget.manager.refreshPeriods();
      SzikAppState.analytics.logEvent(name: 'cleaning_edit_period');
      setState(() {
        _hasOpenPeriod = true;
        _openPeriod = widget.manager.getOpenPeriod();
      });
    } on IOException catch (e) {
      var snackbar = ErrorHandler.buildSnackbar(context, exception: e);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onAutoAssign() async {
    try {
      await widget.manager.autoAssignTasks();
      SzikAppState.analytics.logEvent(name: 'cleaning_assign_automatically');
    } on IOServerException catch (e) {
      var banner = ErrorHandler.buildBanner(context,
          information: ErrorInformation.fromCode(e.code));
      ScaffoldMessenger.of(context).showMaterialBanner(banner);
    }
  }

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
                style: theme.textTheme.headline3!
                    .copyWith(color: theme.colorScheme.primaryContainer),
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_START'.tr(),
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
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
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
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
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
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
                  Text(
                    'ClEANING_ADMIN_NUMOFPARTICIPANTS'.tr(),
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    Provider.of<SzikAppStateManager>(context, listen: false)
                        .groups
                        .firstWhere(
                            (element) => element.email == 'lakok@szentignac.hu')
                        .memberIDs
                        .length
                        .toString(),
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
                style: theme.textTheme.headline3,
              ),
              const SizedBox(height: kPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLEANING_PERIOD_START'.tr(),
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy. MM. dd.').format(_activePeriod.start),
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
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy. MM. dd.').format(_activePeriod.end),
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
                    style: theme.textTheme.subtitle1!.copyWith(
                      color: theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
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
