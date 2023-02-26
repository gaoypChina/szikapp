import 'package:flutter/material.dart';

class CurveShapeBorder extends ContinuousRectangleBorder {
  final double curveHeight;

  const CurveShapeBorder({required this.curveHeight});

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 2,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
