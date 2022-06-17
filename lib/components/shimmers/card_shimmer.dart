import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.secondaryContainer.withOpacity(0.2),
      highlightColor: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      child: Container(
        margin: const EdgeInsets.all(kPaddingLarge),
        height: 72,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusNormal),
          color: theme.colorScheme.background,
        ),
      ),
    );
  }
}
