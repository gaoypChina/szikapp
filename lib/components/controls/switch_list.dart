import 'package:flutter/material.dart';

class CustomSwitchList extends StatefulWidget {
  ///A widget címe
  final Text title;

  ///A switchek neveinek listája
  final List<String> switchLabels;

  /// Azonos méretű a [switchLabels] listával. A switchek állapotát tárolja
  final List<bool> initValues;

  ///Az egyes switchek állíthatóságának jelzése
  final List<bool> enabled;

  ///A switchek változásakor visszatér a gomb aktuális értékével
  final ValueChanged<List<bool>> onChanged;

  CustomSwitchList({
    Key? key,
    required this.title,
    required this.switchLabels,
    required this.onChanged,
    List<bool>? initValues,
    List<bool>? enabled,
  })  : initValues = initValues ??
            List.generate(
              switchLabels.length,
              (index) => false,
            ),
        enabled = enabled ??
            List.generate(
              switchLabels.length,
              (index) => true,
            ),
        super(key: key);

  @override
  State<CustomSwitchList> createState() => _CustomSwitchListState();
}

class _CustomSwitchListState extends State<CustomSwitchList> {
  late List<bool> _switchValues = [];

  @override
  void initState() {
    _switchValues = widget.initValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: widget.title,
        tilePadding: const EdgeInsets.all(0),
        children: widget.switchLabels.map((title) {
          var index = widget.switchLabels.indexOf(title);
          return SwitchListTile(
            title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
            value: _switchValues[widget.switchLabels.indexOf(title)],
            onChanged: widget.enabled[index]
                ? (bool? value) {
                    setState(() {
                      _switchValues[index] = value ?? false;
                    });
                    widget.onChanged(_switchValues);
                  }
                : null,
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.all(0),
          );
        }).toList(),
      ),
    );
  }
}
