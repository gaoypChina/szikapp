import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/business.dart';
import '../../navigation/navigation.dart';
import '../../ui/themes.dart';

import '../components.dart';
import 'curve_shape_border.dart';

PreferredSizeWidget buildCustomAppBar({
  required BuildContext context,
  required String appBarTitle,
  required bool withBackButton,
  double elevation = 0.0,
}) {
  void onLeadingPressed() {
    Router.of(context).routerDelegate.popRoute();
  }

  void onTrailingPressed() {
    Provider.of<SzikAppStateManager>(context, listen: false)
        .selectFeature(SzikAppFeature.profile);
  }

  var profilePicture =
      Provider.of<AuthManager>(context, listen: false).user?.profilePicture;
  var theme = Theme.of(context);
  return AppBar(
    elevation: elevation,
    centerTitle: true,
    shape: const CurveShapeBorder(kCurveHeight),
    backgroundColor: theme.colorScheme.primary,
    title: Text(
      appBarTitle.toUpperCase(),
      style: theme.textTheme.headline2!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 14,
      ),
    ),
    leading: withBackButton
        ? IconButton(
            onPressed: onLeadingPressed,
            icon: const CustomIcon(CustomIcons.arrowLeft),
          )
        : Container(),
    actions: [
      IconButton(
        onPressed: onTrailingPressed,
        icon: profilePicture != null
            ? CircleAvatar(
                foregroundImage: NetworkImage(
                  profilePicture,
                ),
              )
            : const CustomIcon(CustomIcons.user),
      ),
    ],
  );
}
