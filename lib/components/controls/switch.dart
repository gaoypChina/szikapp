import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  /// A gomb szövege
  final Text titleText;

  /// A kezdeti érték az oldal betöltésekor
  final bool initValue;

  /// A gomb változásakor visszatér a gomb aktuális értékével
  final ValueChanged<bool> onChanged;

  /// A gomb engedélyezése/letiltása (True/False)
  final bool enabled;

  const CustomSwitch({
    super.key,
    required this.titleText,
    this.initValue = true,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _switchState = true;

  @override
  void initState() {
    _switchState = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.titleText,
            Switch(
              value: _switchState,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: widget.enabled
                  ? (bool value) {
                      setState(() {
                        _switchState = !_switchState;
                      });
                      widget.onChanged(_switchState);
                    }
                  : null,
            )
          ],
        ),
      ],
    );
  }
}
