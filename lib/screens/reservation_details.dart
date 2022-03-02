import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/reservation_manager.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/tasks.dart';
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

  const ReservationDetails({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              ),
              alignment: Alignment.center,
              margin: const EdgeInsets.all(kPaddingLarge),
              padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
              child: Text(
                'RESERVATION_TITLE_CREATE'.tr(),
                style: theme.textTheme.headline2!.copyWith(
                  color: theme.colorScheme.primaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'RESERVATION_LABEL_DETAILS_DATE'.tr(),
                  style: theme.textTheme.headline3!.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                Divider(
                  color: theme.colorScheme.secondary,
                  thickness: 2,
                  height: 3,
                  indent: 50,
                  endIndent: 75,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: kPaddingNormal),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusNormal),
                  ),
                  child: DatePicker(
                    initialDate: DateTime.now(),
                    onChanged: _onDateChanged,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      _buildRaster(),
                      _buildEvents(widget.manager.reservations),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateTask,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(width: 36, height: 36),
          child: Image.asset('assets/icons/plus_light_72.png'),
        ),
      ),
    );
  }

  void _onDateChanged(DateTime? date) {}
  void _onCreateTask() {
    SZIKAppState.analytics.logEvent(name: 'create_open_reservation_task');
  }

  Widget _buildEvents(List<TimetableTask> reservations) {
    var theme = Theme.of(context);
    reservations.sort((a, b) => a.start.compareTo(b.start));
    return Column(
      children: reservations
          .map(
            (e) => Container(
              height: ((e.end.minute + e.end.hour * 60) -
                      (e.start.minute + e.start.hour * 60)) *
                  30,
              width: 60,
              margin: EdgeInsets.only(top: (e.start.minute) * 30),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Column(
                children: [
                  Text(
                    e.description ?? '',
                    style: theme.textTheme.headline3!.copyWith(
                        fontSize: 15, color: theme.colorScheme.primary),
                  ),
                  Text(
                    e.name,
                    style: theme.textTheme.headline3!.copyWith(
                        fontSize: 10, color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRaster() {
    var theme = Theme.of(context);
    return Column(
      children: hours
          .map(
            (e) => Row(
              children: [
                Text(
                  '${e.hour}:${e.minute} - ${(e.hour + 1)}:${(e.minute)}',
                  style: theme.textTheme.headline3!
                      .copyWith(fontSize: 30, color: theme.colorScheme.primary),
                  textAlign: TextAlign.start,
                ),
                Divider(
                  color: theme.colorScheme.secondary,
                  thickness: 1,
                  indent: 25,
                  endIndent: 25,
                  height: 0.5,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
