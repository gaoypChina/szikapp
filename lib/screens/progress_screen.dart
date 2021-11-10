import 'dart:math';

import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var devicePixelRatio = queryData.devicePixelRatio;
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        )),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/pictures/logo_white_800.png',
                  width: min(800 / devicePixelRatio, queryData.size.height / 3),
                ),
              ),
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primary,
                valueColor: animationController.drive(ColorTween(
                    begin: Theme.of(context).colorScheme.onPrimary,
                    end: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.25))),
              )
            ],
          ),
        ),
      ],
    );
  }
}
