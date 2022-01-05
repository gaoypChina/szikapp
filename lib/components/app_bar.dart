import 'package:flutter/material.dart';
import '../ui/themes.dart';

import 'curve_shape_border.dart';

PreferredSizeWidget buildAppBar({
  required BuildContext context,
  required String appBarTitle,
  double elevation = 0.0,
  void Function()? onPressed,
}) {
  return AppBar(
    elevation: elevation,
    centerTitle: true,
    shape: const CurveShapeBorder(kCurveHeight),
    title: Text(
      appBarTitle,
      style: Theme.of(context).textTheme.headline2!.copyWith(
            color: Theme.of(context).colorScheme.background,
            fontSize: 14,
          ),
    ),
    leading: IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.background,
      ),
    ),
  );
}
