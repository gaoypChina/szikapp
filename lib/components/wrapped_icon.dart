import 'package:flutter/material.dart';
import '../ui/themes.dart';
import 'components.dart';

class WrappedIcon extends StatelessWidget {
  final double iconSize;
  final double padding;
  final double radius;
  final String assetPath;
  final Color? color;
  final Color? backgroundColor;

  const WrappedIcon({
    super.key,
    this.iconSize = kIconSizeXLarge,
    this.padding = kPaddingNormal,
    this.radius = kBorderRadiusNormal,
    required this.assetPath,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      child: Container(
        width: iconSize + padding * 2,
        height: iconSize + padding * 2,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroundColor ?? theme.colorScheme.primary,
        ),
        child: CustomIcon(
          assetPath,
          size: iconSize,
          color: color ?? theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
