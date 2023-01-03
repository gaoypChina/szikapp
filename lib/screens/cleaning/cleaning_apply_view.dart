import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../business/business.dart';
import '../../models/tasks.dart';
import '../../navigation/app_state_manager.dart';
import '../../ui/themes.dart';

class CleaningApplyView extends StatefulWidget {
  const CleaningApplyView({Key? key}) : super(key: key);

  @override
  State<CleaningApplyView> createState() => _CleaningApplyViewState();
}

class _CleaningApplyViewState extends State<CleaningApplyView> {
  late List<CleaningTask> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = _getEventsForDay(_selectedDay!);
  }

  List<CleaningTask> _getEventsForDay(DateTime day) {
    // Implementation example
    var events =
        Provider.of<KitchenCleaningManager>(context, listen: false).tasks;

    var selectedEvents =
        events.where((element) => isSameDay(element.start, day)).toList();
    print(selectedEvents.length);
    return selectedEvents;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      print('onDaySelected');
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null) {
      setState(() {
        _selectedEvents = _getEventsForDay(start);
      });
    } else if (end != null) {
      setState(() {
        _selectedEvents = _getEventsForDay(end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kPaddingLarge),
            color: Theme.of(context).colorScheme.background),
        child: Column(
          children: [
            TableCalendar<CleaningTask>(
              locale: context.locale.toString(),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 10, 16),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kPaddingLarge),
                        color: Theme.of(context).colorScheme.background,
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer)),
                    child: Column(
                      children: [
                        Text(_selectedEvents[index].name),
                        Divider(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kPaddingNormal),
                              color: Theme.of(context).colorScheme.background,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer)),
                          child: Text(
                              _selectedEvents[index].description.toString()),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kPaddingNormal),
                              color: Theme.of(context).colorScheme.background,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer)),
                          child: Text(Provider.of<SzikAppStateManager>(context,
                                  listen: false)
                              .users
                              .firstWhere((element) => element.id == 'u066')
                              .name),
                        )
                      ],
                    ));
              },
              itemCount: _selectedEvents.length,
            ))
          ],
        ));
  }
}
