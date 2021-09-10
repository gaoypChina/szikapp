import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/reservation.dart';
import '../../main.dart';
import '../../models/tasks.dart';
import '../widgets/alert_dialog.dart';

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
  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    super.initState();
    reservation = Reservation();
  }

  void _onAcceptDelete() {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var leftColumnWidth = width * 0.3;
    final confirmDialog = CustomAlertDialog(
      title: 'DIALOG_TITLE_CONFIRM_DELETE'.tr(),
      onAcceptText: 'BUTTON_YES'.tr(),
      onAccept: _onAcceptDelete,
      onCancelText: 'BUTTON_NO'.tr(),
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
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                'JANITOR_TITLE_EDIT_ADMIN'.tr(),
                style: theme.textTheme.headline2!.copyWith(
                  color: theme.colorScheme.primaryVariant,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
