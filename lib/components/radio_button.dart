import 'package:flutter/material.dart';
import '../ui/themes.dart';

class CustomRadio extends StatefulWidget {
  ///A gombok neveinek listája
  final List<String> titles;

  ///A gombok szövegeinek formázási stílusa
  final TextStyle style;

  ///Annak a gombnak az indexe, ami az oldal generálásakor aktív kell, hogy legyen
  final int initValue;

  const CustomRadio({
    Key? key,
    required this.titles,
    required this.style,
    this.initValue = 0,
  }) : super(key: key);

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  late String radioValue;
  @override
  void initState() {
    radioValue = widget.titles[widget.initValue];
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
                groupValue: radioValue,
                onChanged: (String? value) {
                  setState(() {
                    radioValue = value ?? '';
                  });
                }),
          ),
          contentPadding: EdgeInsets.all(0),
        );
      }).toList(),
    );
  }
}
