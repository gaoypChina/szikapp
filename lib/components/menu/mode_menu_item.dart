import 'package:flutter/material.dart';
import '../../ui/themes.dart';
import '../components.dart';

class ModeMenuItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String leadingAssetPath;
  final String title;
  final Color? color;

  const ModeMenuItem({
    Key? key,
    this.onTap,
    required this.leadingAssetPath,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kPaddingXLarge),
        height: 90,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(kPaddingXLarge),
              child: CustomIcon(
                leadingAssetPath,
                size: kIconSizeLarge,
                color: color ?? theme.colorScheme.secondary,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(
                  0, kPaddingLarge, kPaddingLarge, kPaddingLarge),
              child: Center(
                child: Text(
                  title,
                  style: szikTextTheme.headline2!.copyWith(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                    color: color ?? theme.colorScheme.secondary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
