import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../business/reservation.dart';
import '../../main.dart';
import '../../models/tasks.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/date_picker.dart';
import '../widgets/time_picker.dart';

class ReservationNewEditArguments {
  TimetableTask? task;
  bool isEdit;
  String placeID;

  ReservationNewEditArguments({
    this.task,
    this.isEdit = false,
    required this.placeID,
  });
}

class ReservationNewEditScreen extends StatefulWidget {
  static const String route = '/reservation/newedit';

  final TimetableTask? task;
  final String placeID;
  final bool isEdit;

  const ReservationNewEditScreen({
    Key? key,
    this.task,
    this.isEdit = false,
    required this.placeID,
  }) : super(key: key);

  @override
  _ReservationNewEditScreenState createState() =>
      _ReservationNewEditScreenState();
}

class _ReservationNewEditScreenState extends State<ReservationNewEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Reservation reservation;
  String? description;
  String? title;
  late List<String> organizerIDs;
  late List<String> resourceIDs;
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    super.initState();
    reservation = Reservation();
    start = widget.isEdit ? widget.task!.start : DateTime.now();
    end = widget.isEdit ? widget.task!.end : DateTime.now();
  }

  void _onAcceptDelete() {
    reservation.deleteReservation(widget.task!);
    SZIKAppState.analytics.logEvent(name: 'delete_reservation_task');
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    final confirmDialog = CustomAlertDialog(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onAcceptText: 'BUTTON_YES'.tr().toLowerCase(),
      onAccept: _onAcceptDelete,
      onCancelText: 'BUTTON_NO'.tr().toLowerCase(),
      onCancel: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    if (SZIKAppState.places.isEmpty) SZIKAppState.loadEarlyData();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            //Title
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                SZIKAppState.places
                    .firstWhere((element) => element.id == widget.placeID)
                    .name,
                style: theme.textTheme.headline2!.copyWith(
                  color: theme.colorScheme.primaryVariant,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                'RESERVATION_TITLE_CREATE'.tr(),
                style: theme.textTheme.headline1!.copyWith(
                  color: theme.colorScheme.secondary,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Divider(
              color: theme.colorScheme.secondary,
              thickness: 2,
              indent: 25,
              endIndent: 25,
              height: 1,
            ),
            Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'RESERVATION_LABEL_DATE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: DatePicker(
                            date: start,
                            onChanged: _onDateChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'RESERVATION_LABEL_TIME_FROM'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TimePicker(
                            time: TimeOfDay.fromDateTime(start),
                            onChanged: _onStartingTimeChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'RESERVATION_LABEL_TIME_TO'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TimePicker(
                            time: TimeOfDay.fromDateTime(end),
                            onChanged: _onFinishingTimeChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            'RESERVATION_LABEL_DESCRIPTION'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            validator: _validateTextField,
                            initialValue:
                                widget.isEdit ? widget.task!.description : null,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_DESCRIPTION'.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(5),
                            ),
                            onChanged: _onDescriptionChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: 10),
                          child: widget.isEdit
                              ? IconButton(
                                  icon: ColorFiltered(
                                    child: Image.asset(
                                        'assets/icons/trash_light_72.png'),
                                    colorFilter: ColorFilter.mode(
                                        theme.colorScheme.secondaryVariant
                                            .withOpacity(0.7),
                                        BlendMode.srcIn),
                                  ),
                                  onPressed: () {
                                    showDialog<void>(
                                        context: context,
                                        builder: (context) => confirmDialog);
                                  },
                                )
                              : Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: widget.isEdit ? _onEditSent : _onNewSent,
                            child: Text(widget.isEdit
                                ? 'BUTTON_SAVE'.tr()
                                : 'BUTTON_SEND'.tr()),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kBottomNavigationBarHeight,
            )
          ],
        ),
      ),
    );
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
  }

  void _onDateChanged(DateTime? date) {
    setState(() {
      start =
          DateTime(date!.year, date.month, date.day, start.hour, start.minute);
      end = DateTime(date.year, date.month, date.day, end.hour, end.minute);
    });
  }

  void _onStartingTimeChanged(TimeOfDay? startingTime) {
    setState(() {
      start = DateTime(start.year, start.month, start.day, startingTime!.hour,
          startingTime.minute);
    });
  }

  void _onFinishingTimeChanged(TimeOfDay? endingTime) {
    setState(() {
      end = DateTime(
          end.year, end.month, end.day, endingTime!.hour, endingTime.minute);
    });
  }

  void _onDescriptionChanged(String? description) {
    description = description;
  }

  void _onNewSent() {
    if (_formKey.currentState!.validate()) {
      var uuid = const Uuid();
      var task = TimetableTask(
        uid: uuid.v4(),
        name: title!,
        start: start,
        end: end,
        type: TaskType.timetable,
        involved: <String>[SZIKAppState.authManager.user!.id],
        lastUpdate: DateTime.now(),
        description: description,
        organizerIDs: <String>[SZIKAppState.authManager.user!.id],
        resourceIDs: <String>[widget.placeID],
      );
      reservation.addReservation(task);
      SZIKAppState.analytics.logEvent(name: 'create_sent_reservation');
      Navigator.of(context).pop(true);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.task;
      task!.name = title!;
      task.description = description;
      task.start = start;
      task.end = end;
      reservation.editReservation(task);
      SZIKAppState.analytics.logEvent(name: 'edit_sent_reservation');
      Navigator.of(context).pop(true);
    }
  }
}
