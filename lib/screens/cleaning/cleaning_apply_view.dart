import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../business/business.dart';
import '../../components/custom_icon.dart';
import '../../models/tasks.dart';
import '../../models/user.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

const double kCalendarMarkerSize = 5.0;

class CleaningApplyView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningApplyView({Key? key, required this.manager}) : super(key: key);

  @override
  State<CleaningApplyView> createState() => _CleaningApplyViewState();
}

class _CleaningApplyViewState extends State<CleaningApplyView> {
  late CleaningTask _selectedEvent;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late User _user;
  bool _userAppliedSelectedEvent = false;
  bool _userAlreadyApplied = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvent = _getEventsForDay(_selectedDay).first;
    _user = Provider.of<AuthManager>(context, listen: false).user!;
    _userAppliedSelectedEvent =
        _selectedEvent.participantIDs.contains(_user.id);
    _userAlreadyApplied = widget.manager.tasks
        .any((element) => element.participantIDs.contains(_user.id));
  }

  List<CleaningTask> _getEventsForDay(DateTime day) {
    return widget.manager.tasks
        .where((element) => isSameDay(element.start, day))
        .toList();
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, newSelectedDay)) {
      setState(() {
        _selectedDay = newSelectedDay;
        _focusedDay = focusedDay;
        _selectedEvent = _getEventsForDay(newSelectedDay).first;
        _userAppliedSelectedEvent =
            _selectedEvent.participantIDs.contains(_user.id);
      });
    }
  }

  Widget _buildCleaningMate() {
    var mate = _selectedEvent.participantIDs.firstWhere(
      (element) => element != _user.id,
      orElse: () => '',
    );
    if (mate != '') {
      return Text(Provider.of<SzikAppStateManager>(context, listen: false)
          .users
          .firstWhere((element) => element.id == mate)
          .showableName);
    } else {
      return Text('CLEANING_DIALOG_NO_MATE'.tr());
    }
  }

  Future<void> _onApplyPressed() async {
    try {
      _selectedEvent.participantIDs.add(_user.id);
      setState(() {
        _userAppliedSelectedEvent = true;
        _userAlreadyApplied = true;
      });
      await widget.manager.editCleaningTask(_selectedEvent);
      await widget.manager.refreshTasks();
    } on IOException catch (e) {
      var snackbar = ErrorHandler.buildSnackbar(context, exception: e);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _onWithdrawPressed() async {
    try {
      _selectedEvent.participantIDs.remove(_user.id);
      setState(() {
        _userAppliedSelectedEvent = false;
        _userAlreadyApplied = false;
      });
      await widget.manager.editCleaningTask(_selectedEvent);
      await widget.manager.refreshTasks();
    } on IOException catch (e) {
      var snackbar = ErrorHandler.buildSnackbar(context, exception: e);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kPaddingLarge),
          color: Theme.of(context).colorScheme.background),
      child: ListView(
        children: [
          TableCalendar<CleaningTask>(
            locale: context.locale.toString(),
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.month,
            rangeSelectionMode: RangeSelectionMode.disabled,
            daysOfWeekHeight: 20,
            availableGestures: AvailableGestures.horizontalSwipe,
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
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
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, event) {
                var participantCount = event.participantIDs.length;
                var markerColor = const Color(0xffa00a34);
                if (participantCount == 1) {
                  markerColor = const Color(0xffffbf1b);
                } else if (participantCount == 2) {
                  markerColor = const Color(0xff278230);
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
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(kPaddingSmall),
                padding: const EdgeInsets.all(kPaddingNormal),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                  color: Theme.of(context).colorScheme.background,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _selectedEvent.name,
                      style: theme.textTheme.bodyText1,
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
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'CLEANING_LABEL_EXTENSION'.tr(),
                            style: theme.textTheme.headline5,
                          ),
                          Text(
                            _selectedEvent.description ?? '',
                            textAlign: TextAlign.center,
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
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CLEANING_DIALOG_WITH'.tr(),
                            style: theme.textTheme.headline5,
                          ),
                          _buildCleaningMate(),
                        ],
                      ),
                    ),
                    if (!_userAlreadyApplied &&
                        !_userAppliedSelectedEvent &&
                        _selectedEvent.participantIDs.length < 2)
                      IconButton(
                        onPressed: _onApplyPressed,
                        icon: CustomIcon(
                          CustomIcons.done,
                          color: theme.colorScheme.primary,
                          size: kIconSizeLarge,
                        ),
                      ),
                    if (_userAppliedSelectedEvent)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('CLEANING_DIALOG_APPLIED'.tr()),
                          IconButton(
                            onPressed: _onWithdrawPressed,
                            icon: CustomIcon(
                              CustomIcons.closeOutlined,
                              color: theme.colorScheme.primary,
                              size: kIconSizeLarge,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
