import 'package:flutter/material.dart';

class CustomRadioList extends StatefulWidget {
  ///A gombok neveinek listája
  final List<String> radioLabels;

  ///Annak a gombnak a neve, ami az oldal generálásakor aktív kell, hogy legyen
  final String? initValue;

  ///A gombok változásakor visszatér a rendszer aktuális értékével
  final ValueChanged<String> onChanged;

  const CustomRadioList({
    Key? key,
    required this.radioLabels,
    this.initValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomRadioList> createState() => _CustomRadioListState();
}

class _CustomRadioListState extends State<CustomRadioList> {
  late String _radioValue;

  @override
  void initState() {
    _radioValue = widget.radioLabels.contains(widget.initValue)
        ? widget.initValue!
        : widget.radioLabels.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: widget.radioLabels.map((title) {
        return ListTile(
          title: Text(title,
              style: theme.textTheme.headline6!
                  .copyWith(color: theme.colorScheme.primary)),
          trailing: Transform.scale(
            scale: 1.2,
            child: Radio(
              value: title,
              activeColor: theme.colorScheme.primary,
              groupValue: _radioValue,
              onChanged: (String? value) {
                setState(() {
                  _radioValue = value ?? '';
                });
                widget.onChanged(_radioValue);
              },
            ),
          ),
          contentPadding: const EdgeInsets.all(0),
        );
      }).toList(),
    );
  }
}
