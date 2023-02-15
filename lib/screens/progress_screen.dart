import 'dart:math';

import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/pictures/logo_white_800.png',
                  width: min(
                    800 / queryData.devicePixelRatio,
                    queryData.size.height / 3,
                  ),
                ),
              ),
              LinearProgressIndicator(
                backgroundColor: theme.colorScheme.primary,
                valueColor: animationController.drive(
                  ColorTween(
                    begin: theme.colorScheme.onPrimary,
                    end: theme.colorScheme.onPrimary.withOpacity(0.25),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
