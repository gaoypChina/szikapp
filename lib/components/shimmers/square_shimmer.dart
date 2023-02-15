import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class SquareShimmer extends StatelessWidget {
  const SquareShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.secondaryContainer.withOpacity(0.2),
      highlightColor: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(kPaddingNormal),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: theme.colorScheme.background,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(kPaddingNormal),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusNormal),
              color: theme.colorScheme.background,
            ),
          ),
        ],
      ),
    );
  }
}
