import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../ui/themes.dart';

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

  final BorderRadius borderRadius;

  final EdgeInsets padding;

  const DatePicker({
    Key? key,
    required this.onChanged,
    this.readonly = false,
    this.initialDate,
    this.startDate,
    this.endDate,
    this.color = szikTarawera,
    this.fontSize = 14,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(kBorderRadiusSmall),
    ),
    this.padding = const EdgeInsets.symmetric(
      vertical: kPaddingNormal,
      horizontal: kPaddingSmall,
    ),
  }) : super(key: key);

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
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
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: widget.borderRadius,
      ),
      padding: widget.padding,
      child: GestureDetector(
        onTap: widget.readonly ? null : _selectDate,
        child: Text(
          DateFormat('yyyy. MM. dd.')
              .format(widget.initialDate ?? DateTime.now()),
          style: theme.textTheme.labelLarge!.copyWith(
            color: widget.readonly
                ? theme.colorScheme.secondaryContainer
                : widget.color,
            fontSize: widget.fontSize,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
