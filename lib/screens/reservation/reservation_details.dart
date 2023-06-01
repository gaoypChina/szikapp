import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business/business.dart';
import '../../components/components.dart';
import '../../main.dart';
import '../../models/models.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';
import '../../utils/utils.dart';

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
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
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
    super.key,
    required this.manager,
  });

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  var _selectedMode = ReservationMode.none;
  var _resourceID = '';
  late DateTime _currentDate;

  DateTime get _currentDateStart =>
      _currentDate.copyWith(hour: 0, minute: 0, second: 0);
  DateTime get _currentDateEnd => _currentDate.copyWith(hour: 23, minute: 59);

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.manager.selectedMode;
    if (_selectedMode == ReservationMode.place) {
      _resourceID = Provider.of<SzikAppStateManager>(context, listen: false)
          .places[widget.manager.selectedPlaceIndex]
          .id;
    } else if (_selectedMode == ReservationMode.boardgame) {
      _resourceID = Provider.of<ReservationManager>(context, listen: false)
          .games[widget.manager.selectedGameIndex]
          .id;
    } else {
      _resourceID = Provider.of<ReservationManager>(context, listen: false)
          .accounts[widget.manager.selectedAccountIndex]
          .id;
    }
    _currentDate =
        widget.manager.selectedDate?.toLocal() ?? DateTime.now().toLocal();
  }

  void _onDateChanged(DateTime date) {
    widget.manager.selectDate(date: date);
    setState(() {
      _currentDate = date;
    });
  }

  void _onCreateTask() {
    SzikAppState.analytics.logEvent(name: 'reservation_open_create');
    if (_selectedMode == ReservationMode.place) {
      widget.manager.createNewPlaceReservation(
        placeIndex: widget.manager.selectedPlaceIndex,
      );
    } else if (_selectedMode == ReservationMode.boardgame) {
      widget.manager.createNewGameReservation(
        gameIndex: widget.manager.selectedGameIndex,
      );
    } else {
      widget.manager.createNewAccountReservation(
        accountIndex: widget.manager.selectedAccountIndex,
      );
    }
  }

  void _onEditTask(int reservationIndex) {
    SzikAppState.analytics.logEvent(name: 'reservation_open_edit');
    widget.manager.setSelectedReservationTask(
      id: widget.manager.reservations[reservationIndex].id,
    );
    if (_selectedMode == ReservationMode.place) {
      widget.manager.editPlaceReservation(
        index: widget.manager.selectedIndex,
        placeIndex: widget.manager.selectedPlaceIndex,
      );
    } else if (_selectedMode == ReservationMode.boardgame) {
      widget.manager.editGameReservation(
        index: widget.manager.selectedIndex,
        gameIndex: widget.manager.selectedGameIndex,
      );
    } else {
      widget.manager.editAccountReservation(
        index: widget.manager.selectedIndex,
        accountIndex: widget.manager.selectedAccountIndex,
      );
    }
  }

  Widget _buildEvents() {
    var theme = Theme.of(context);
    return Positioned.fill(
      child: Stack(
        children: widget.manager
            .filter(
              start: _currentDateStart,
              end: _currentDateEnd,
              resourceIDs: [_resourceID],
            )
            .map(
              (reservation) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: widget.leftColumnWidth),
                  Column(
                    children: [
                      SizedBox(
                        height: (reservation.start.hour * 60 +
                                reservation.start.minute) *
                            widget.pixelsPerMinute,
                      ),
                      InkWell(
                        onTap: () =>
                            Provider.of<AuthManager>(context, listen: false)
                                    .user!
                                    .hasPermissionToModify(task: reservation)
                                ? _onEditTask(
                                    Provider.of<ReservationManager>(
                                      context,
                                      listen: false,
                                    ).reservations.indexOf(reservation),
                                  )
                                : null,
                        child: Container(
                          height: (((reservation.end.minute +
                                      reservation.end.hour * 60) -
                                  (reservation.start.minute +
                                      reservation.start.hour * 60)) *
                              widget.pixelsPerMinute),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusNormal),
                            color: Color(reservation.color),
                          ),
                          padding: const EdgeInsets.all(kPaddingLarge),
                          child: Column(
                            children: [
                              Text(
                                reservation.name.useCorrectEllipsis(),
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.surface,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  Provider.of<SzikAppStateManager>(context,
                                          listen: false)
                                      .users
                                      .where((user) => reservation.managerIDs
                                          .contains(user.id))
                                      .map((user) => user.showableName)
                                      .toList()
                                      .join(', '),
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.surface,
                                  ),
                                  overflow: TextOverflow.fade,
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
            (hour) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: widget.leftColumnWidth,
                  height: widget.pixelsPerMinute * 60 - widget.dividerThickness,
                  child: Center(
                    child: Text(
                      hour.format(context),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ),
                if (hours.last != hour)
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    String appBarTitle;
    Resource resource;
    if (_selectedMode == ReservationMode.place) {
      appBarTitle = 'RESERVATION_MODE_PLACE'.tr();
      resource = Provider.of<SzikAppStateManager>(context, listen: false)
          .places[widget.manager.selectedPlaceIndex];
    } else if (_selectedMode == ReservationMode.boardgame) {
      appBarTitle = 'RESERVATION_MODE_BOARDGAME'.tr();
      resource = widget.manager.games[widget.manager.selectedGameIndex];
    } else {
      appBarTitle = 'RESERVATION_MODE_ACCOUNT'.tr();
      resource = widget.manager.accounts[widget.manager.selectedAccountIndex];
    }
    return CustomScaffold(
      appBarTitle: appBarTitle,
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
                  resource.name.toUpperCase(),
                  style: theme.textTheme.displayLarge!.copyWith(
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
                    style: theme.textTheme.displaySmall!.copyWith(
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
                    initialDate: _currentDate,
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
              child: FutureBuilder(
                future: widget.manager
                    .refresh(start: _currentDateStart, end: _currentDateEnd),
                builder: (context, snapshot) {
                  return RefreshIndicator(
                    onRefresh: () => widget.manager.refresh(
                        start: _currentDateStart, end: _currentDateEnd),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _onCreateTask,
        typeToCreate: TimetableTask,
      ),
    );
  }
}
