import 'package:flutter/material.dart';

class CustomCheckboxList extends StatefulWidget {
  /// A widget címe
  final Text title;

  /// A checkboxok neveinek listája
  final List<String> checkboxLabels;

  /// Azonos méretű a [checkboxLabels] listával. A checkboxok állapotát tárolja
  final List<bool>? initValues;

  /// maximum hány checkbox lehet bejelölve egyszerre
  final int maxEnabled;

  /// A checkboxok változásakor visszatér a gomb aktuális értékével
  final ValueChanged<List<bool>> onChanged;

  const CustomCheckboxList({
    Key? key,
    required this.title,
    required this.checkboxLabels,
    this.initValues,
    required this.maxEnabled,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckboxList> createState() => _CustomCheckboxListState();
}

class _CustomCheckboxListState extends State<CustomCheckboxList> {
  late List<bool> _checkboxValues;

  @override
  void initState() {
    _checkboxValues = widget.initValues ??
        List.generate(widget.checkboxLabels.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: widget.title,
        tilePadding: const EdgeInsets.all(0),
        children: widget.checkboxLabels.map((title) {
          var index = widget.checkboxLabels.indexOf(title);
          var disabled = _checkboxValues.where((item) => item == true).length >=
                  widget.maxEnabled &&
              _checkboxValues[index] == false;
          return ListTile(
            title: Text(
              title,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: disabled
                    ? theme.colorScheme.secondaryContainer
                    : theme.colorScheme.primary,
              ),
            ),
            trailing: Checkbox(
              tristate: false,
              activeColor: theme.colorScheme.primary,
              value: _checkboxValues[widget.checkboxLabels.indexOf(title)],
              onChanged: disabled
                  ? null
                  : (bool? value) {
                      setState(() {
                        _checkboxValues[index] = value ?? false;
                      });
                      widget.onChanged(_checkboxValues);
                    },
            ),
            contentPadding: const EdgeInsets.all(0),
          );
        }).toList(),
      ),
    );
  }
}
