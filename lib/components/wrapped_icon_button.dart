import 'package:flutter/material.dart';
import '../ui/themes.dart';
import 'wrapped_icon.dart';

class WrappedIconButton extends StatelessWidget {
  final double iconSize;
  final double padding;
  final double radius;
  final String assetPath;
  final Color? color;
  final Color? backgroundColor;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const WrappedIconButton({
    super.key,
    this.iconSize = kIconSizeXLarge,
    this.padding = kPaddingNormal,
    this.radius = kBorderRadiusNormal,
    required this.assetPath,
    this.color,
    this.backgroundColor,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: WrappedIcon(
        assetPath: assetPath,
        iconSize: iconSize,
        padding: padding,
        radius: radius,
        color: color,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
