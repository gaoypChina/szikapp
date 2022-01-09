import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class RoundedBoxShimmer extends StatelessWidget {
  const RoundedBoxShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.background.withOpacity(0.2),
      highlightColor: theme.colorScheme.background.withOpacity(0.5),
      child: Container(
        height: kIconSizeXLarge,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
