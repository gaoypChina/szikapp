import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class SearchBarShimmer extends StatelessWidget {
  const SearchBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.secondaryContainer.withOpacity(0.2),
      highlightColor: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        margin: const EdgeInsets.all(kPaddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: kIconSizeLarge,
              height: kIconSizeLarge,
              margin: const EdgeInsets.symmetric(
                horizontal: kPaddingLarge,
                vertical: kPaddingNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
