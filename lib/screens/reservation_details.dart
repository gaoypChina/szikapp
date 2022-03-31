import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/tasks.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';

const List<TimeOfDay> hours = [
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 1, minute: 0),
  TimeOfDay(hour: 2, minute: 0),
  TimeOfDay(hour: 3, minute: 0),
  TimeOfDay(hour: 4, minute: 0),
  TimeOfDay(hour: 5, minute: 0),
  TimeOfDay(hour: 6, minute: 0),
  TimeOfDay(hour: 7, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 9, minute: 0),
  TimeOfDay(hour: 10, minute: 0),
  TimeOfDay(hour: 11, minute: 0),
  TimeOfDay(hour: 12, minute: 0),
  TimeOfDay(hour: 13, minute: 0),
  TimeOfDay(hour: 14, minute: 0),
  TimeOfDay(hour: 15, minute: 0),
  TimeOfDay(hour: 16, minute: 0),
  TimeOfDay(hour: 17, minute: 0),
  TimeOfDay(hour: 18, minute: 0),
  TimeOfDay(hour: 19, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 21, minute: 0),
  TimeOfDay(hour: 22, minute: 0),
  TimeOfDay(hour: 23, minute: 0),
];

class ReservationDetailsScreen extends StatelessWidget {
  static const String route = '/reservation/details';

  static MaterialPage page({required ReservationManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationDetailsScreen(manager: manager),
    );
  }

  final ReservationManager manager;

  const ReservationDetailsScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: Provider.of<ReservationManager>(context, listen: false).refresh(),
      shimmer: const ListScreenShimmer(),
      child: ReservationDetails(
        manager: manager,
      ),
    );
  }
}

class ReservationDetails extends StatefulWidget {
  final ReservationManager manager;

  final pixelsPerMinute = 1.5;
  final dividerThickness = 1.0;
  final leftColumnWidth = 80.0;

  const ReservationDetails({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  List<TimetableTask> _reservations = [];

  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now().toLocal();
    _reservations = widget.manager.filter(
      DateTime(currentDate.year, currentDate.month, currentDate.day),
      DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59),
      [
        Provider.of<SzikAppStateManager>(context, listen: false)
            .places[widget.manager.selectedPlaceIndex]
            .id
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      appBarTitle: 'RESERVATION_MODE_PLACE'.tr(),
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingNormal),
              child: Center(
                child: Text(
                  Provider.of<SzikAppStateManager>(context)
                      .places[widget.manager.selectedPlaceIndex]
                      .name
                      .toUpperCase(),
                  style: theme.textTheme.headline1!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: widget.dividerThickness,
              color: theme.colorScheme.secondary,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CONTROL_FILTER'.tr(),
                    style: theme.textTheme.headline3!.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 1,
                    child: Container(
                      color: theme.colorScheme.primary,
                      margin: const EdgeInsets.only(left: kPaddingNormal),
                    ),
                  ),
                  DatePicker(
                    initialDate: currentDate,
                    onChanged: _onDateChanged,
                    borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                    color: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: kPaddingNormal,
                      horizontal: kPaddingXLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      _buildRaster(),
                      _buildEvents(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => _onCreateTask(widget.manager.selectedPlaceIndex),
        typeToCreate: TimetableTask,
      ),
    );
  }

  void _onDateChanged(DateTime? date) {
    setState(() {
      currentDate = date ?? DateTime.now().toLocal();
      _reservations = widget.manager.filter(
        DateTime(currentDate.year, currentDate.month, currentDate.day),
        DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59),
        [
          Provider.of<SzikAppStateManager>(context, listen: false)
              .places[widget.manager.selectedPlaceIndex]
              .id
        ],
      );
    });
  }

  void _onCreateTask(index) {
    SZIKAppState.analytics.logEvent(name: 'create_open_reservation_task');
    widget.manager.createNewPlaceReservation(index);
  }

  void _onEditTask(int index, int placeIndex) {
    SZIKAppState.analytics.logEvent(name: 'edit_reservation_task');
    widget.manager.editPlaceReservation(index, placeIndex);
  }

  Widget _buildEvents() {
    var theme = Theme.of(context);
    return Positioned.fill(
      child: Stack(
        children: _reservations
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: widget.leftColumnWidth),
                  Column(
                    children: [
                      SizedBox(
                        height: (e.start.hour * 60 + e.start.minute) *
                            widget.pixelsPerMinute,
                      ),
                      InkWell(
                        onTap: () =>
                            Provider.of<AuthManager>(context, listen: false)
                                    .user!
                                    .hasPermissionToModify(e)
                                ? _onEditTask(
                                    Provider.of<ReservationManager>(
                                      context,
                                      listen: false,
                                    ).reservations.indexOf(e),
                                    widget.manager.selectedPlaceIndex,
                                  )
                                : null,
                        child: Container(
                          height: (((e.end.minute + e.end.hour * 60) -
                                  (e.start.minute + e.start.hour * 60)) *
                              widget.pixelsPerMinute),
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: theme.colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(
                              kBorderRadiusNormal,
                            ),
                            color: theme.colorScheme.background,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPaddingLarge,
                          ),
                          child: Column(
                            children: [
                              Text(
                                e.name,
                                style: theme.textTheme.caption!.copyWith(
                                  color: theme.colorScheme.primaryContainer,
                                ),
                              ),
                              Text(
                                e.description ?? '',
                                style: theme.textTheme.bodyText1!.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRaster() {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: hours
          .map(
            (e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: widget.leftColumnWidth,
                  height: widget.pixelsPerMinute * 60 - widget.dividerThickness,
                  child: Center(
                    child: Text(
                      e.format(context),
                      style: theme.textTheme.bodyText1!.copyWith(
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ),
                if (hours.last != e)
                  Divider(
                    thickness: widget.dividerThickness,
                    height: widget.dividerThickness,
                    color: theme.colorScheme.secondary,
                  ),
              ],
            ),
          )
          .toList(),
    );
  }
}
