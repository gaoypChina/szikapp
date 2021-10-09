import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

///Személyre szabott időpontválasztó widget.
class TimePicker extends StatefulWidget {
  ///A megváltozott időpont jelzésére szolgáló callback
  final ValueChanged<TimeOfDay> onChanged;

  ///Eredeti időpont
  final TimeOfDay time;

  ///Szöveg színe
  final Color color;

  ///Szöveg mérete
  final double fontSize;

  const TimePicker(
      {Key? key,
      required this.time,
      required this.onChanged,
      this.color = szikTarawera,
      this.fontSize = 14})
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
      confirmText: 'BUTTON_OK'.tr().toUpperCase(),
      cancelText: 'BUTTON_CANCEL'.tr().toUpperCase(),
      helpText: 'TIME_PICKER_HELP'.tr().toUpperCase(),
    );
    if (newTime != null) {
      widget.onChanged(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: GestureDetector(
        onTap: _selectTime,
        child: Text(
          widget.time.format(context),
          style: Theme.of(context).textTheme.button!.copyWith(
              color: widget.color,
              fontSize: widget.fontSize,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
