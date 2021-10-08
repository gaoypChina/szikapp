import 'package:flutter/material.dart';

///Személyre szabott lapválasztó widget.
///Értékben és dizájnban is visszajelzi a választott lap indexét, de magát
///a lapváltást nem hajtja végre, arról a szülő widgetnek kell gondoskodnia.
///A lehetőségek megjelenítése a [ChoiceChip] widgeten alapul.
///Állapota a privát [_TabChoiceState].
class TabChoice extends StatefulWidget {
  ///Választási lehetőségek feliratai
  final List<String> labels;

  ///A választott lap indexének jelzésére szolgáló callback
  final ValueChanged<int?> onChanged;

  ///A kiválasztott lap chipjének színe
  final Color? choiceColor;

  ///A körülfogó keret színe
  final Color? wrapColor;

  ///Kiválasztott lap nélküli működés engedélyezése
  final bool allowNoneSelected;

  const TabChoice({
    Key? key,
    required this.labels,
    required this.onChanged,
    this.choiceColor,
    this.wrapColor,
    this.allowNoneSelected = false,
  }) : super(key: key);

  @override
  _TabChoiceState createState() => _TabChoiceState();
}

///A [TabChoice] widget állapota.
class _TabChoiceState extends State<TabChoice> {
  ///Kiválasztott lap indexe. Ha a [TabChoice.allowNoneSelected] flag értéke
  ///engedi, az érték `null`-t is felvehet.
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
              labelPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
