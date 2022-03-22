import 'package:flutter/material.dart';

import '../../ui/themes.dart';

class MenuItem extends StatelessWidget {
  final String name;
  final String picture;
  final VoidCallback? onTap;
  final double height;
  final bool reversed;

  const MenuItem({
    Key? key,
    required this.name,
    required this.picture,
    this.height = kIconSizeXLarge,
    this.onTap,
    this.reversed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Expanded(
        child: Container(
          child: Text(
            name,
            textAlign: reversed ? TextAlign.left : TextAlign.right,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          padding: EdgeInsets.symmetric(horizontal: height * 0.1),
        ),
      ),
      Center(
        child: Container(
          width: height * 0.5,
          height: height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusSmall),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Container(
            margin: EdgeInsets.all(height * 0.05),
            child: ColorFiltered(
              child: Image.asset(
                picture,
                width: kIconSizeNormal,
              ),
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
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
