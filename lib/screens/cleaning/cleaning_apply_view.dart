import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../business/business.dart';
import '../../models/tasks.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';

class CleaningApplyView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningApplyView({Key? key, required this.manager}) : super(key: key);

  @override
  State<CleaningApplyView> createState() => _CleaningApplyViewState();
}

class _CleaningApplyViewState extends State<CleaningApplyView> {
  late List<CleaningTask> _selectedEvents;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = _getEventsForDay(_selectedDay!);
  }

  List<CleaningTask> _getEventsForDay(DateTime day) {
    return widget.manager.tasks
        .where((element) => isSameDay(element.start, day))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kPaddingLarge),
          color: Theme.of(context).colorScheme.background),
      child: Column(
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
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
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
                      Text(_selectedEvents[index].name),
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                        child: Text(
                          _selectedEvents[index].description ?? '',
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('CLEANING_DIALOG_WITH'.tr()),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: _selectedEvents.length,
            ),
          )
        ],
      ),
    );
  }
}
