import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/models.dart';
import '../navigation/app_state_manager.dart';
import '../ui/themes.dart';

class ReservationNewEditScreen extends StatefulWidget {
  static const String route = '/reservation/newedit';

  static MaterialPage page({
    TimetableTask? originalItem,
    required ReservationManager manager,
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
        manager: manager,
        onCreate: onCreate,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  final ReservationManager manager;
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
    required this.manager,
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
  List<String> organizerIDs = [];
  List<String> resourceIDs = [];
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
    Place? selectedPlace;
    final confirmDialog = CustomAlertDialog(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onAcceptText: 'BUTTON_YES'.tr().toLowerCase(),
      onAccept: _onAcceptDelete,
      onCancelText: 'BUTTON_NO'.tr().toLowerCase(),
      onCancel: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    if (widget.manager.selectedMode == ReservationMode.place) {
      selectedPlace = Provider.of<SzikAppStateManager>(context, listen: false)
          .places[widget.manager.selectedPlaceIndex];
      resourceIDs.add(selectedPlace.id);
    } else if (widget.manager.selectedMode == ReservationMode.boardgame) {
      resourceIDs.add(widget.manager.selectedGame!.id);
    }
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.all(kPaddingLarge),
        child: ListView(
          children: [
            //Title
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
              margin: const EdgeInsets.only(bottom: kPaddingLarge),
              child: Text(
                Provider.of<SzikAppStateManager>(context, listen: false)
                    .places
                    .firstWhere((element) => element.id == selectedPlace!.id)
                    .name,
                style: theme.textTheme.headline2!.copyWith(
                  color: theme.colorScheme.primaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: kPaddingLarge),
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
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'RESERVATION_LABEL_DATE'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: DatePicker(
                            initialDate: start,
                            startDate: DateTime.now(),
                            onChanged: _onDateChanged,
                            readonly:
                                widget.isEdit & start.isBefore(DateTime.now()),
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
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
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
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
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
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: Text(
                            'RESERVATION_LABEL_DESCRIPTION'.tr(),
                            style: theme.textTheme.headline3!.copyWith(
                                fontSize: 14, color: theme.colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: _validateTextField,
                            initialValue: widget.isEdit
                                ? widget.originalItem!.description
                                : null,
                            style: theme.textTheme.headline3!.copyWith(
                              fontSize: 14,
                              color: theme.colorScheme.primaryContainer,
                              fontStyle: FontStyle.italic,
                            ),
                            decoration: InputDecoration(
                              hintText: 'PLACEHOLDER_DESCRIPTION'.tr(),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadiusSmall),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.all(kPaddingSmall),
                            ),
                            onChanged: _onDescriptionChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: kPaddingLarge),
                    child: Row(
                      children: [
                        Container(
                          width: leftColumnWidth,
                          margin: const EdgeInsets.only(right: kPaddingNormal),
                          child: widget.isEdit
                              ? IconButton(
                                  icon: ColorFiltered(
                                    child: Image.asset(
                                        'assets/icons/trash_light_72.png'),
                                    colorFilter: ColorFilter.mode(
                                        theme.colorScheme.secondaryContainer
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
    return null;
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
        id: uuid.v4().toUpperCase(),
        name: title!,
        start: start,
        end: end,
        type: TaskType.timetable,
        participantIDs: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id
        ],
        lastUpdate: DateTime.now(),
        description: description,
        organizerIDs: <String>[
          Provider.of<AuthManager>(context, listen: false).user!.id
        ],
        resourceIDs: resourceIDs,
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
