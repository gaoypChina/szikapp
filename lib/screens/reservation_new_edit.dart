import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/components.dart';
import '../main.dart';
import '../models/tasks.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';
import '../utils/auth_manager.dart';

class ReservationNewEditScreen extends StatefulWidget {
  static const String route = '/reservation/newedit';

  static MaterialPage page({
    TimetableTask? originalItem,
    required int placeIndex,
    int index = -1,
    required Function(TimetableTask) onCreate,
    required Function(TimetableTask, int) onUpdate,
    required Function(TimetableTask, int) onDelete,
  }) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: ReservationNewEditScreen(
        originalItem: originalItem,
        index: index,
        placeIndex: placeIndex,
        onCreate: onCreate,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  final int placeIndex;
  final bool isEdit;
  final TimetableTask? originalItem;
  final int index;
  final Function(TimetableTask) onCreate;
  final Function(TimetableTask, int) onDelete;
  final Function(TimetableTask, int) onUpdate;

  const ReservationNewEditScreen({
    Key? key,
    this.originalItem,
    this.index = -1,
    required this.placeIndex,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  })  : isEdit = (originalItem != null),
        super(key: key);

  @override
  _ReservationNewEditScreenState createState() =>
      _ReservationNewEditScreenState();
}

class _ReservationNewEditScreenState extends State<ReservationNewEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? description;
  String? title;
  late List<String> organizerIDs;
  late List<String> resourceIDs;
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    super.initState();
    start = widget.isEdit ? widget.originalItem!.start : DateTime.now();
    end = widget.isEdit ? widget.originalItem!.end : DateTime.now();
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
    var placeID = Provider.of<SzikAppStateManager>(context, listen: false)
        .places[widget.placeIndex]
        .id;
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
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .places
                    .firstWhere((element) => element.id == placeID)
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
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? szikTarawera
                                : szikMalibu,
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
                            initialValue: widget.isEdit
                                ? widget.originalItem!.description
                                : null,
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
        involved: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id
        ],
        lastUpdate: DateTime.now(),
        description: description,
        organizerIDs: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id
        ],
        resourceIDs: <String>[
          Provider.of<SzikAppStateManager>(context, listen: false)
              .places[widget.placeIndex]
              .id
        ],
      );
      SZIKAppState.analytics.logEvent(name: 'create_sent_reservation');
      widget.onCreate(task);
    }
  }

  void _onEditSent() {
    if (_formKey.currentState!.validate()) {
      var task = widget.originalItem;
      task!.name = title!;
      task.description = description;
      task.start = start;
      task.end = end;

      SZIKAppState.analytics.logEvent(name: 'edit_sent_reservation');
      widget.onUpdate(task, widget.index);
    }
  }

  void _onAcceptDelete() {
    SZIKAppState.analytics.logEvent(name: 'delete_reservation_task');
    widget.onDelete(widget.originalItem!, widget.index);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
