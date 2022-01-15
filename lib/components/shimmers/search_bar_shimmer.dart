import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class SearchBarShimmer extends StatelessWidget {
  const SearchBarShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.secondaryVariant.withOpacity(0.2),
      highlightColor: theme.colorScheme.secondaryVariant.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: kIconSizeLarge,
              height: kIconSizeLarge,
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            ),
          ],
        ),
      ),
    );
  }
}
