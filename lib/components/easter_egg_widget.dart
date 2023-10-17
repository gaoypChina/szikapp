import 'package:flutter/material.dart';
import 'components.dart';

class EasterEgg extends StatefulWidget {
  final Widget child;
  final String message;
  final String link;
  final int numberOfTaps;

  const EasterEgg({
    super.key,
    required this.child,
    required this.message,
    required this.link,
    this.numberOfTaps = 10,
  });

  @override
  State<EasterEgg> createState() => _EasterEggState();
}

class _EasterEggState extends State<EasterEgg> {
  int taps = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: widget.child,
    );
  }

  void onTap() {
    setState(() => taps++);
    if (taps >= widget.numberOfTaps) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog.easteregg(
            text: widget.message,
            linkUrl: widget.link,
            onWeakButtonClick: () =>
                Navigator.of(context, rootNavigator: true).pop(),
          );
        },
      );
      setState(() => taps = 0);
    }
  }
}
