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
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var devicePixelRatio = queryData.devicePixelRatio;
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        color: Color(0xff59a3b0),
      )),
      Container(
        child: Center(
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
                backgroundColor: Color(0xff59a3b0),
                valueColor: animationController.drive(
                    ColorTween(begin: Colors.white, end: Colors.white24)),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
