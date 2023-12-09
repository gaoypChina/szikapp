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

const int defaultParticipantsPerTask = 2;

class CleaningAdminPeriodView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningAdminPeriodView({super.key, required this.manager});

  @override
  State<CleaningAdminPeriodView> createState() =>
      _CleaningAdminPeriodViewState();
}

class _CleaningAdminPeriodViewState extends State<CleaningAdminPeriodView> {
  late DateTime _startDate;
  late DateTime _endDate;
  bool _hasOpenPeriod = false;
  bool _hasCurrentPeriod = false;
  late CleaningPeriod _openPeriod;
  late CleaningPeriod _currentPeriod;
  int _participantCount = 0;
  int _participantsPerTask = defaultParticipantsPerTask;

  @override
  void initState() {
    super.initState();
    _hasOpenPeriod = widget.manager.hasOpenPeriod();
    if (widget.manager.periods.isNotEmpty) {
      if (_hasOpenPeriod) _openPeriod = widget.manager.getOpenPeriod();
      _startDate = _hasOpenPeriod
          ? _openPeriod.start
          : widget.manager.periods.last.end.add(const Duration(days: 1));
      _endDate = _hasOpenPeriod
          ? _openPeriod.end
          : _startDate.add(const Duration(days: 31));
      _participantsPerTask = _hasOpenPeriod
          ? _openPeriod.participantsPerTask
          : defaultParticipantsPerTask;
      _hasCurrentPeriod = widget.manager.hasCurrentPeriod();
      if (_hasCurrentPeriod) _currentPeriod = widget.manager.getCurrentPeriod();
    } else {
      _startDate = DateTime.now().add(const Duration(days: 1));
      _endDate = _startDate.add(const Duration(days: 31));
    }

    var groups =
        Provider.of<SzikAppStateManager>(context, listen: false).groups;
    var participantIDs = widget.manager.getParticipantIDs(groups);
    _participantCount = participantIDs.length;
  }

  void _onStartChanged(DateTime newDate) {
    setState(() {
      _startDate = newDate;
    });
  }

  void _onEndChanged(DateTime newDate) {
    setState(() {
      _endDate = newDate;
    });
  }

  void _onParticipantsPerTaskChanged(String newValue) {
    var newParticipantsPerTask =
        int.tryParse(newValue) ?? defaultParticipantsPerTask;
    setState(() {
      _participantsPerTask = newParticipantsPerTask > _participantCount
          ? defaultParticipantsPerTask
          : newParticipantsPerTask;
    });
  }

  Future<void> _onNewPeriod() async {
    try {
      var uuid = const Uuid();
      var newPeriod = CleaningPeriod(
        id: uuid.v4().toUpperCase(),
        start: _startDate.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
        ),
        end: _endDate.copyWith(
          hour: 23,
          minute: 59,
          second: 59,
        ),
        participantsPerTask: _participantsPerTask,
        lastUpdate: DateTime.now(),
        isLive: true,
      );

      await widget.manager.createCleaningPeriod(period: newPeriod);
      await widget.manager.refreshPeriods();
      SzikAppState.analytics.logEvent(name: 'cleaning_add_period');
      setState(() {
        _hasOpenPeriod = true;
        _openPeriod = widget.manager.getOpenPeriod();
      });
    } on IOException catch (exception) {
      var snackbar =
          ErrorHandler.buildSnackbar(context: context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onEditPeriod() async {
    try {
      _openPeriod.start = _startDate.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
      );
      _openPeriod.end = _endDate.copyWith(
        hour: 23,
        minute: 59,
        second: 59,
      );
      _openPeriod.lastUpdate = DateTime.now();
      _openPeriod.participantsPerTask = _participantsPerTask;
      await widget.manager.editCleaningPeriod(period: _openPeriod);
      await widget.manager.refreshPeriods();
      SzikAppState.analytics.logEvent(name: 'cleaning_edit_period');
      setState(() {
        _hasOpenPeriod = true;
        _openPeriod = widget.manager.getOpenPeriod();
      });
    } on IOException catch (exception) {
      var snackbar =
          ErrorHandler.buildSnackbar(context: context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onAutoAssign() async {
    try {
      await widget.manager.autoAssignTasks();
      SzikAppState.analytics.logEvent(name: 'cleaning_assign_automatically');
    } on InformationException catch (exception) {
      var snackbar = ErrorHandler.buildSnackbar(
          context: context, errorCode: exception.code);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
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
                  style: theme.textTheme.displaySmall!
                      .copyWith(color: theme.colorScheme.primaryContainer),
                ),
                const SizedBox(height: kPaddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CLEANING_PERIOD_START'.tr(),
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    DatePicker(
                      onChanged: _onStartChanged,
                      initialDate: _startDate,
                      startDate: DateTime.now()
                          .copyWith(hour: 0, minute: 0, second: 0)
                          .add(const Duration(days: 1)),
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
                      style: theme.textTheme.titleMedium!.copyWith(
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
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '${(_endDate.difference(_startDate).inDays + 1) * _participantsPerTask}',
                      style: theme.textTheme.displaySmall,
                    )
                  ],
                ),
                const SizedBox(height: kPaddingNormal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ClEANING_ADMIN_NUMOFPARTICIPANTS'.tr(),
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      _participantCount.toString(),
                      style: theme.textTheme.displaySmall,
                    )
                  ],
                ),
                const SizedBox(height: kPaddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CLEANING_ADMIN_PARTICIPANTS_PER_TASK'.tr(),
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        initialValue: _participantsPerTask.toString(),
                        onChanged: _onParticipantsPerTaskChanged,
                        style: theme.textTheme.displaySmall,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: theme.colorScheme.primary),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusSmall),
                          ),
                          contentPadding: const EdgeInsets.all(kPaddingSmall),
                        ),
                      ),
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
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                    if (_hasOpenPeriod) ...[
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog.confirmation(
                              title: 'CLEANING_ADMIN_EDIT_PERIOD'.tr(),
                              bodytext:
                                  'CLEANING_ADMIN_EDIT_PERIOD_DESCRIPTION'.tr(),
                              onWeakButtonClick: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              onStrongButtonClick: () {
                                _onEditPeriod();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'BUTTON_EDIT'.tr(),
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog.confirmation(
                              title: 'CLEANING_ADMIN_AUTO_ASSIGN'.tr(),
                              bodytext:
                                  'CLEANING_ADMIN_AUTO_ASSIGN_DESCRIPTION'.tr(),
                              onWeakButtonClick: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              onStrongButtonClick: () {
                                _onAutoAssign();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'CLEANING_ADMIN_AUTO_ASSIGN'.tr(),
                          style: theme.textTheme.labelSmall!.copyWith(
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
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: kPaddingSmall),
                ..._buildCurrentPeriodBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCurrentPeriodBody() {
    var theme = Theme.of(context);
    if (!_hasCurrentPeriod) {
      return [
        Text(
          'CLEANING_ADMIN_NO_ACTIVE_PERIOD_INFO'.tr(),
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.primaryContainer,
            fontWeight: FontWeight.bold,
          ),
        )
      ];
    }
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CLEANING_PERIOD_START'.tr(),
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primaryContainer,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            DateFormat('yyyy. MM. dd.').format(_currentPeriod.start),
            style: theme.textTheme.labelLarge!.copyWith(
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
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primaryContainer,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            DateFormat('yyyy. MM. dd.').format(_currentPeriod.end),
            style: theme.textTheme.labelLarge!.copyWith(
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
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primaryContainer,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            '${_currentPeriod.end.difference(_currentPeriod.start).inDays * _currentPeriod.participantsPerTask}',
            style: theme.textTheme.displaySmall,
          )
        ],
      ),
      const SizedBox(height: kPaddingNormal),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CLEANING_ADMIN_PARTICIPANTS_PER_TASK'.tr(),
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primaryContainer,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            _currentPeriod.participantsPerTask.toString(),
            style: theme.textTheme.displaySmall,
          )
        ],
      ),
    ];
  }
}
