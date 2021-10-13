import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

///A [DatePicker] widgetben kiválasztható legkorábbi és legkésőbbi dátum
///különbsége az aktuális időponttól.
const kDatePickerDifference = Duration(days: 730);

///Személyre szabott dátumválasztó widget.
class DatePicker extends StatefulWidget {
  ///A megváltozott dátum jelzésére szolgáló callback
  final ValueChanged<DateTime> onChanged;

  ///Eredeti dátum
  final DateTime date;

  ///Szöveg színe
  final Color color;

  ///Szöveg mérete
  final double fontSize;

  const DatePicker(
      {Key? key,
      required this.date,
      required this.onChanged,
      this.color = szikTarawera,
      this.fontSize = 14})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  void _selectDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: DateTime.now().subtract(kDatePickerDifference),
      lastDate: DateTime.now().add(kDatePickerDifference),
      confirmText: 'BUTTON_OK'.tr().toUpperCase(),
      cancelText: 'BUTTON_CANCEL'.tr().toUpperCase(),
      helpText: 'DATE_PICKER_HELP'.tr().toUpperCase(),
    );
    if (newDate != null) {
      widget.onChanged(newDate);
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
        onTap: _selectDate,
        child: Text(
          DateFormat("yyyy. mm. dd.").format(widget.date),
          style: Theme.of(context).textTheme.button!.copyWith(
              color: widget.color,
              fontSize: widget.fontSize,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
