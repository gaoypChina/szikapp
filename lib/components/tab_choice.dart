import 'package:flutter/material.dart';

import '../ui/themes.dart';

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

  ///A címek betűinek színe
  final Color? fontColor;

  ///Kiválasztott lap nélküli működés engedélyezése
  final bool allowNoneSelected;

  const TabChoice({
    Key? key,
    required this.labels,
    required this.onChanged,
    this.choiceColor,
    this.wrapColor,
    this.fontColor,
    this.allowNoneSelected = false,
  }) : super(key: key);

  @override
  TabChoiceState createState() => TabChoiceState();
}

///A [TabChoice] widget állapota.
class TabChoiceState extends State<TabChoice> {
  ///Kiválasztott lap indexe. Ha a [TabChoice.allowNoneSelected] flag értéke
  ///engedi, az érték `null`-t is felvehet.
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: widget.wrapColor ??
            theme.colorScheme.secondaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          widget.labels.length,
          (index) {
            return ChoiceChip(
              label: Text(widget.labels[index],
                  style: TextStyle(color: widget.fontColor)),
              selected: _value == index,
              onSelected: (selected) {
                var newValue = index; //selected ? index : null;
                widget.onChanged(newValue);
                setState(() {
                  _value = newValue;
                });
              },
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: kPaddingLarge),
              selectedColor: widget.choiceColor ??
                  theme.colorScheme.primary.withOpacity(0.3),
              disabledColor: Colors.transparent,
              labelStyle: theme.textTheme.displaySmall!.copyWith(
                fontSize: 14,
                color: theme.colorScheme.primaryContainer,
              ),
            );
          },
        ),
      ),
    );
  }
}
