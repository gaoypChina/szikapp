import 'package:flutter/material.dart';
import '../ui/themes.dart';

import 'curve_shape_border.dart';

PreferredSizeWidget buildAppBar({
  required BuildContext context,
  required String appBarTitle,
  void Function()? onPressed,
}) {
  return AppBar(
    shape: const CurveShapeBorder(kCurveHeight),
    title: Text(
      appBarTitle,
      style: Theme.of(context)
          .textTheme
          .headline2!
          .copyWith(color: Theme.of(context).colorScheme.background),
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
