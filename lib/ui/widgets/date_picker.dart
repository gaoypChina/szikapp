import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onChanged;
  final DateTime date;

  DatePicker({Key? key, required this.date, required this.onChanged})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  void _selectDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      confirmText: 'BUTTON_OK'.tr(),
      cancelText: 'BUTTON_CANCEL'.tr(),
      helpText: 'DATE_PICKER_HELP'.tr(),
    );
    if (newDate != null) {
      widget.onChanged(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(child: Text(widget.date.toLocal().toString())),
    );
  }
}
