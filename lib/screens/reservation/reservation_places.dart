import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../business/business.dart';
import '../../components/components.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

class ReservationPlacesScreen extends StatelessWidget {
  static const String route = '/reservation/places';
  final ReservationManager manager;

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationPlacesScreen(manager: manager),
    );
  }

  const ReservationPlacesScreen({
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: manager.refresh(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now().add(const Duration(days: 15)),
      ),
      shimmer: const ListScreenShimmer(),
      child: ReservationPlacesCalendar(
        manager: manager,
      ),
    );
  }
}

class ReservationPlacesCalendar extends StatefulWidget {
  final ReservationManager manager;

  const ReservationPlacesCalendar({super.key, required this.manager});

  @override
  State<ReservationPlacesCalendar> createState() =>
      _ReservationPlacesCalendarState();
}

class _ReservationPlacesCalendarState extends State<ReservationPlacesCalendar> {
  late List<Place> _allPlaces;
  late List<Place> _publicPlaces;
  late Place _selectedPlace;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _allPlaces =
        Provider.of<SzikAppStateManager>(context, listen: false).places;
    _publicPlaces = Provider.of<SzikAppStateManager>(context, listen: false)
        .places
        .where((place) => place.type == PlaceType.public)
        .toList();
    _focusedDay = widget.manager.selectedDate ?? DateTime.now();
    _selectedDay = _focusedDay;
    _selectedPlace = widget.manager.lastSelectedPlaceIndex == -1
        ? _publicPlaces.first
        : _allPlaces[widget.manager.lastSelectedPlaceIndex];
  }

  List<TimetableTask> _getReservationsForDay(DateTime pickedDay) {
    return widget.manager.reservations
        .where((reservation) =>
            reservation.start.isSameDate(pickedDay) &&
            reservation.resourceIDs.contains(_selectedPlace.id))
        .toList();
  }

  void _onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!_selectedDay.isSameDate(newSelectedDay)) {
      setState(() {
        _selectedDay = newSelectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onPlaceChanged(Place? newPlace) {
    if (_selectedPlace.id != newPlace?.id) {
      setState(() {
        _selectedPlace = newPlace!;
      });
    }
  }

  void _showReservationDatePicker() {
    widget.manager
        .selectLastSelectedPlace(index: _allPlaces.indexOf(_selectedPlace));
    widget.manager.selectDate(date: _selectedDay);
    widget.manager.selectPlace(index: _allPlaces.indexOf(_selectedPlace));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
        appBarTitle: 'RESERVATION_MAP_TITLE'.tr(),
        body: Padding(
          padding: const EdgeInsets.all(kPaddingNormal),
          child: Container(
            padding: const EdgeInsets.all(kPaddingNormal),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(
                Radius.circular(kBorderRadiusNormal),
              ),
              border: Border.all(color: theme.colorScheme.primary),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                SearchableOptions<Place>(
                  items: _publicPlaces,
                  selectedItem: _selectedPlace,
                  onItemChanged: _onPlaceChanged,
                  compare: (i, s) => i!.isEqual(s),
                ),
                TableCalendar<TimetableTask>(
                  locale: context.locale.toString(),
                  firstDay: DateTime.now().subtract(const Duration(days: 120)),
                  lastDay: DateTime.now().add(const Duration(days: 90)),
                  focusedDay: _focusedDay,
                  eventLoader: _getReservationsForDay,
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
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
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
                    },
                    singleMarkerBuilder: (context, day, event) {
                      var markerColor = theme.colorScheme.primaryContainer;
                      if (DateTime.now().isInInterval(event.start, event.end)) {
                        markerColor = statusRed;
                      }
                      return Container(
                        height: kCalendarMarkerSize,
                        width: kCalendarMarkerSize,
                        decoration: BoxDecoration(
                          color: markerColor,
                          borderRadius:
                              BorderRadius.circular(kBorderRadiusLarge),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: _showReservationDatePicker,
          typeToCreate: TimetableTask,
          icon: CustomIcons.doubleArrowRight,
        ));
  }
}
