import 'package:flutter/material.dart';

import '../components.dart';

enum ShimmerListType {
  card,
  list,
  square,
}

class ListShimmer extends StatelessWidget {
  final ShimmerListType type;
  final bool withSearchbar;

  const ListShimmer({
    Key? key,
    this.type = ShimmerListType.card,
    this.withSearchbar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withSearchbar) const SearchBarShimmer(),
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              10,
              (index) {
                switch (type) {
                  case ShimmerListType.card:
                    return const CardShimmer();
                  case ShimmerListType.list:
                    return const TileShimmer();
                  case ShimmerListType.square:
                    return const SquareShimmer();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
