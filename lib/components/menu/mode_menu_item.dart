import 'package:flutter/material.dart';
import '../../ui/themes.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(kPaddingXLarge, 0, kPaddingXLarge, 0),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(kPaddingXLarge),
              height: kIconSizeLarge,
              width: kIconSizeLarge,
              child: Image.asset(
                leadingAssetPath,
                color: color ?? Theme.of(context).colorScheme.secondary,
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
                    color: color ?? Theme.of(context).colorScheme.secondary,
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
