import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onChanged;
  final TimeOfDay time;

  const TimePicker({Key? key, required this.time, required this.onChanged})
      : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  void _selectTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: widget.time,
      initialEntryMode: TimePickerEntryMode.dial,
      confirmText: 'BUTTON_OK'.tr(),
      cancelText: 'BUTTON_CANCEL'.tr(),
      helpText: 'TIME_PICKER_HELP'.tr(),
    );
    if (newTime != null) {
      widget.onChanged(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(child: Text(widget.time.format(context))),
    );
  }
}
