import 'package:flutter/material.dart';
import '../ui/themes.dart';

class CustomCheckbox extends StatefulWidget {
  ///A widget címe
  final Text title;

  ///A checkboxok neveinek listája
  final List<String> titles;

  ///A checkboxok szövegeinek formázási stílusa
  final TextStyle style;

  ///Azonos méretű a [titles] listával. A checkboxok állapotát tárolja
  final List<bool>? initValues;

  ///A checkboxok változásakor visszatér a gomb aktuális értékével
  final ValueChanged<List<bool>> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.title,
    required this.titles,
    required this.style,
    this.initValues,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late List<bool> _CheckboxValues;

  @override
  void initState() {
    _CheckboxValues = widget.initValues ??
        List.generate(widget.titles.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: widget.title,
        tilePadding: EdgeInsets.all(0),
        children: widget.titles.map((title) {
          return ListTile(
            title: Text(title, style: widget.style),
            trailing: Checkbox(
                tristate: false,
                activeColor: Theme.of(context).colorScheme.primary,
                value: _CheckboxValues[widget.titles.indexOf(title)],
                onChanged:
                    _CheckboxValues.where((item) => item == true).length >= 3 &&
                            _CheckboxValues[widget.titles.indexOf(title)] ==
                                false
                        ? null
                        : (bool? value) {
                            setState(() {
                              _CheckboxValues[widget.titles.indexOf(title)] =
                                  value ?? false;
                            });
                            widget.onChanged(_CheckboxValues);
                          }),
            contentPadding: EdgeInsets.all(0),
          );
        }).toList(),
      ),
    );
  }
}
