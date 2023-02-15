import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class TileShimmer extends StatelessWidget {
  const TileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: theme.colorScheme.secondaryContainer.withOpacity(0.2),
            highlightColor:
                theme.colorScheme.secondaryContainer.withOpacity(0.5),
            child: CircleAvatar(
              radius: theme.textTheme.displaySmall!.fontSize! * 1.5,
              backgroundColor: theme.colorScheme.primaryContainer,
            ),
          ),
          Shimmer.fromColors(
            baseColor: theme.colorScheme.secondaryContainer.withOpacity(0.2),
            highlightColor:
                theme.colorScheme.secondaryContainer.withOpacity(0.5),
            child: Container(
              margin: const EdgeInsets.all(kPaddingLarge),
              height: theme.textTheme.displaySmall!.fontSize! * 1.5,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              ),
            ),
          )
        ],
      ),
    );
  }
}
