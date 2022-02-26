import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  ///A gombok neveinek listája
  final List<String> titles;

  ///A gombok szövegeinek formázási stílusa
  final TextStyle style;

  ///Annak a gombnak az indexe, ami az oldal generálásakor aktív kell, hogy legyen
  final int initValue;

  ///A gombok változásakor visszatér a rendszer aktuális értékével
  final ValueChanged<String> onChanged;

  const CustomRadio({
    Key? key,
    required this.titles,
    required this.style,
    this.initValue = 0,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  late String _radioValue;

  @override
  void initState() {
    _radioValue = widget.titles[widget.initValue];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.titles.map((title) {
        return ListTile(
          title: Text(title, style: widget.style),
          trailing: Transform.scale(
            scale: 1.2,
            child: Radio(
              value: title,
              activeColor: Theme.of(context).colorScheme.primary,
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
