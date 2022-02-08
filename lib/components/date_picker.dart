import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../ui/themes.dart';

///A [DatePicker] widgetben kiválasztható legkorábbi és legkésőbbi dátum
///különbsége az aktuális időponttól.
const kDatePickerDifference = Duration(days: 730);

///Személyre szabott dátumválasztó widget.
class DatePicker extends StatefulWidget {
  ///Dátum szerkesztés engedélyezés
  final bool readonly;

  ///A megváltozott dátum jelzésére szolgáló callback
  final ValueChanged<DateTime> onChanged;

  ///Eredeti dátum
  final DateTime? initialDate;

  ///Választható dátumintervallum eleje
  final DateTime? startDate;

  ///Választható dátumintervallum vége
  final DateTime? endDate;

  ///Szöveg színe
  final Color color;

  ///Szöveg mérete
  final double fontSize;

  const DatePicker(
      {Key? key,
      required this.onChanged,
      this.readonly = false,
      this.initialDate,
      this.startDate,
      this.endDate,
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
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate:
          widget.startDate ?? DateTime.now().subtract(kDatePickerDifference),
      lastDate: widget.endDate ?? DateTime.now().add(kDatePickerDifference),
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
        onTap: widget.readonly ? null : _selectDate,
        child: Text(
          DateFormat('yyyy. MM. dd.')
              .format(widget.initialDate ?? DateTime.now()),
          style: Theme.of(context).textTheme.button!.copyWith(
              color: widget.readonly
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : widget.color,
              fontSize: widget.fontSize,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
