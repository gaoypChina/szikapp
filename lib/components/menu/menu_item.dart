import 'package:flutter/material.dart';

import '../../ui/themes.dart';
import '../components.dart';

class CustomMenuItem extends StatelessWidget {
  final String name;
  final String picture;
  final VoidCallback? onTap;
  final double height;
  final bool reversed;

  const CustomMenuItem({
    Key? key,
    required this.name,
    required this.picture,
    this.height = kIconSizeXLarge,
    this.onTap,
    this.reversed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var children = <Widget>[
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: height * 0.1),
          child: Text(
            name,
            textAlign: reversed ? TextAlign.left : TextAlign.right,
            style: theme.textTheme.headline3!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          width: height * 0.5,
          height: height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusSmall),
            color: theme.colorScheme.primary,
          ),
          child: Padding(
            padding: EdgeInsets.all(height * 0.05),
            child: CustomIcon(
              picture,
              size: kIconSizeLarge,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(),
      ),
    ];
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: reversed ? children.reversed.toList() : children,
        ),
      ),
    );
  }
}
