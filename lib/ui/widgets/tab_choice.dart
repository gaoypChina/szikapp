import 'package:flutter/material.dart';

class TabChoice extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int?> onChanged;
  final Color? choiceColor;
  final Color? wrapColor;

  TabChoice({
    Key? key,
    required this.labels,
    required this.onChanged,
    this.choiceColor,
    this.wrapColor,
  }) : super(key: key);

  @override
  _TabChoiceState createState() => _TabChoiceState();
}

class _TabChoiceState extends State<TabChoice> {
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: widget.wrapColor ??
              theme.colorScheme.secondaryVariant.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          3,
          (index) {
            return ChoiceChip(
              label: Text(widget.labels[index]),
              selected: _value == index,
              onSelected: (selected) {
                var newValue = index; //selected ? index : null;
                widget.onChanged(newValue);
                setState(() {
                  _value = newValue;
                });
              },
              labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              selectedColor: widget.choiceColor ??
                  theme.colorScheme.primary.withOpacity(0.3),
              disabledColor: Colors.transparent,
              labelStyle: theme.textTheme.headline3!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryVariant,
              ),
            );
          },
        ),
      ),
    );
  }
}
