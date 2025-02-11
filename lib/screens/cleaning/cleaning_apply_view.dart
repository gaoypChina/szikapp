import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class CleaningApplyView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningApplyView({super.key, required this.manager});

  @override
  State<CleaningApplyView> createState() => _CleaningApplyViewState();
}

class _CleaningApplyViewState extends State<CleaningApplyView> {
  CleaningTask? _selectedEvent;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late CleaningPeriod _openPeriod;
  late User _user;
  bool _userAppliedSelectedEvent = false;
  bool _userAlreadyApplied = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.manager.getOpenPeriod().start;
    _selectedDay = _focusedDay;
    var eventsForDay = _getEventsForDay(_selectedDay);
    if (eventsForDay.isNotEmpty) _selectedEvent = eventsForDay.first;
    _openPeriod = widget.manager.getOpenPeriod();
    _user = Provider.of<AuthManager>(context, listen: false).user!;
    _userAppliedSelectedEvent =
        _selectedEvent?.participantIDs.contains(_user.id) ?? false;
    _userAlreadyApplied =
        widget.manager.userHasAppliedOpenTask(userID: _user.id);
  }

  List<CleaningTask> _getEventsForDay(DateTime pickedDay) {
    return widget.manager
        .getOpenTasks()
        .where((task) => task.start.isSameDate(pickedDay))
        .toList();
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!_selectedDay.isSameDate(newSelectedDay)) {
      var eventsForDay = _getEventsForDay(focusedDay);
      setState(() {
        _selectedDay = newSelectedDay;
        _focusedDay = focusedDay;
        if (eventsForDay.isNotEmpty) {
          _selectedEvent = eventsForDay.first;
        } else {
          _selectedEvent = null;
        }
        _userAppliedSelectedEvent =
            _selectedEvent?.participantIDs.contains(_user.id) ?? false;
      });
    }
  }

  Widget _buildCleaningMates() {
    var theme = Theme.of(context);
    var mateIDs = _selectedEvent?.participantIDs
            .where((participantID) => participantID != _user.id)
            .toList() ??
        [];
    return Flexible(
      child: Text(
        mateIDs.isEmpty
            ? 'CLEANING_DIALOG_NO_MATE'.tr()
            : userIDsToString(context, mateIDs),
        style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.primary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Future<void> _onApplyPressed() async {
    if (_selectedEvent!.participantIDs.length >
        _openPeriod.participantsPerTask - 1) return;
    try {
      _selectedEvent!.participantIDs.add(_user.id);
      await widget.manager.editCleaningTask(task: _selectedEvent!);
      await widget.manager.refreshTasks();
      SzikAppState.analytics.logEvent(name: 'cleaning_apply_task');
      setState(() {
        _userAppliedSelectedEvent = true;
        _userAlreadyApplied = true;
      });
    } on IOException catch (exception) {
      var snackbar =
          ErrorHandler.buildSnackbar(context: context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onWithdrawPressed() async {
    try {
      _selectedEvent!.participantIDs.remove(_user.id);
      await widget.manager.editCleaningTask(task: _selectedEvent!);
      await widget.manager.refreshTasks();
      SzikAppState.analytics.logEvent(name: 'cleaning_withdraw_task');
      setState(() {
        _userAppliedSelectedEvent = false;
        _userAlreadyApplied = false;
      });
    } on IOException catch (exception) {
      var snackbar =
          ErrorHandler.buildSnackbar(context: context, exception: exception);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: kPaddingSmall),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          ),
          border: Border.all(color: theme.colorScheme.primaryContainer),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            TableCalendar<CleaningTask>(
              locale: context.locale.toString(),
              firstDay: DateTime.now().subtract(const Duration(days: 90)),
              lastDay: DateTime.now().add(const Duration(days: 90)),
              focusedDay: _focusedDay,
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) => _selectedDay.isSameDate(day),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: CalendarFormat.month,
              rangeSelectionMode: RangeSelectionMode.disabled,
              daysOfWeekHeight: kDaysOfWeekSize,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: theme.textTheme.titleMedium!,
                  weekendStyle: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              availableGestures: AvailableGestures.horizontalSwipe,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: theme.textTheme.displaySmall!.copyWith(
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: theme.textTheme.titleMedium!,
                weekendTextStyle: theme.textTheme.titleMedium!,
              ),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                var eventsForDay = _getEventsForDay(focusedDay);
                if (eventsForDay.isNotEmpty) {
                  setState(() => _selectedEvent = eventsForDay.first);
                } else {
                  setState(() => _selectedEvent = null);
                }
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (_userAlreadyApplied &&
                      widget.manager
                          .getUserOpenTask(userID: _user.id)
                          .start
                          .isSameDate(day)) {
                    return Center(
                      child: Text(
                        DateFormat('d').format(day),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  return null;
                },
                singleMarkerBuilder: (context, day, event) {
                  var participantCount = event.participantIDs.length;
                  var markerColor = statusGreen;
                  if (participantCount > 0) {
                    markerColor = statusYellow;
                  }
                  if (participantCount >= _openPeriod.participantsPerTask) {
                    markerColor = statusRed;
                  }
                  return Container(
                    height: kCalendarMarkerSize,
                    width: kCalendarMarkerSize,
                    decoration: BoxDecoration(
                      color: markerColor,
                      borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: kPaddingNormal),
            Container(
              margin: const EdgeInsets.all(kPaddingSmall),
              padding: const EdgeInsets.all(kPaddingNormal),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                color: Theme.of(context).colorScheme.background,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: _selectedEvent != null
                  ? Column(
                      children: [
                        Text(
                          _selectedEvent!.name,
                          style: theme.textTheme.displaySmall!.copyWith(
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Container(
                          margin: const EdgeInsets.all(kPaddingSmall),
                          padding: const EdgeInsets.all(kPaddingNormal),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                            color: Theme.of(context).colorScheme.background,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'CLEANING_LABEL_EXTENSION'.tr(),
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.primaryContainer,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _selectedEvent?.description ?? '',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(kPaddingSmall),
                          padding: const EdgeInsets.all(kPaddingNormal),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                            color: Theme.of(context).colorScheme.background,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CLEANING_DIALOG_WITH'.tr(),
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.primaryContainer,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildCleaningMates(),
                            ],
                          ),
                        ),
                        if (!_userAlreadyApplied &&
                            !_userAppliedSelectedEvent &&
                            _selectedEvent!.participantIDs.length <
                                _openPeriod.participantsPerTask)
                          ElevatedButton.icon(
                            onPressed: _onApplyPressed,
                            label: Text('BUTTON_APPLY'.tr()),
                            icon: const CustomIcon(
                              CustomIcons.done,
                              size: kIconSizeLarge,
                            ),
                          ),
                        if (_userAppliedSelectedEvent)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('CLEANING_DIALOG_APPLIED'.tr()),
                              ElevatedButton.icon(
                                onPressed: _onWithdrawPressed,
                                label: Text('BUTTON_DELETE'.tr()),
                                icon: const CustomIcon(
                                  CustomIcons.closeOutlined,
                                  size: kIconSizeLarge,
                                ),
                              ),
                            ],
                          ),
                      ],
                    )
                  : Text(
                      'CLEANING_EXCHANGE_TODAYEMPTY'.tr(),
                      style: theme.textTheme.displaySmall,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
