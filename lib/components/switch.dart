import 'package:flutter/material.dart';
import '../ui/themes.dart';

class CustomSwitch extends StatefulWidget {
  final Text titleText;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const CustomSwitch(
      {Key? key,
      required this.titleText,
      required this.onChanged,
      this.enabled = true})
      : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _switchState;
  @override
  void initState() {
    _switchState = false;
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
                    : null)
          ],
        )
      ],
    );
  }
}
