import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/themes.dart';

class TileShimmer extends StatelessWidget {
  const TileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: theme.colorScheme.secondaryVariant.withOpacity(0.2),
            highlightColor: theme.colorScheme.secondaryVariant.withOpacity(0.5),
            child: CircleAvatar(
              radius: theme.textTheme.headline3!.fontSize! * 1.5,
              backgroundColor: theme.colorScheme.primaryVariant,
            ),
          ),
          Shimmer.fromColors(
            baseColor: theme.colorScheme.secondaryVariant.withOpacity(0.2),
            highlightColor: theme.colorScheme.secondaryVariant.withOpacity(0.5),
            child: Container(
              margin: const EdgeInsets.all(20),
              height: theme.textTheme.headline3!.fontSize! * 1.5,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryVariant,
                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              ),
            ),
          )
        ],
      ),
    );
  }
}
