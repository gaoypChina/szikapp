import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../business/business.dart';
import '../navigation/navigation.dart';
import '../ui/themes.dart';

import 'components.dart';
import 'curve_shape_border.dart';

PreferredSizeWidget buildCustomAppBar({
  required BuildContext context,
  required String appBarTitle,
  required bool withBackButton,
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
      appBarTitle.toUpperCase(),
      style: Theme.of(context).textTheme.headline2!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
          ),
    ),
    leading: withBackButton
        ? IconButton(
            onPressed: _onLeadingPressed,
            icon: const CustomIcon(CustomIcons.arrowLeft),
          )
        : Container(),
    actions: [
      IconButton(
        onPressed: _onTrailingPressed,
        icon: CircleAvatar(
          foregroundImage: NetworkImage(
            Provider.of<AuthManager>(context, listen: false)
                    .user
                    ?.profilePicture
                    .toString() ??
                '../assets/default.png',
          ),
        ),
      ),
    ],
  );
}
