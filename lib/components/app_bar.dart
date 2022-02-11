import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/business.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';

import 'curve_shape_border.dart';

PreferredSizeWidget buildCustomAppBar({
  required BuildContext context,
  required String appBarTitle,
  double elevation = 0.0,
}) {
  void _onLeadingPressed() {
    Router.of(context).routerDelegate.popRoute();
  }

  void _onTrailingPressed() {
    Provider.of<SzikAppStateManager>(context, listen: false)
        .selectFeature(SzikAppFeature.profile);
  }

  return AppBar(
    elevation: elevation,
    centerTitle: true,
    shape: const CurveShapeBorder(kCurveHeight),
    backgroundColor: Theme.of(context).colorScheme.primary,
    title: Text(
      appBarTitle,
      style: Theme.of(context).textTheme.headline2!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
          ),
    ),
    leading: IconButton(
      onPressed: _onLeadingPressed,
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ),
    actions: [
      IconButton(
        onPressed: _onTrailingPressed,
        icon: CircleAvatar(
          foregroundImage: NetworkImage(
            Provider.of<AuthManager>(context, listen: false)
                .user!
                .profilePicture
                .toString(),
          ),
        ),
      ),
    ],
  );
}
