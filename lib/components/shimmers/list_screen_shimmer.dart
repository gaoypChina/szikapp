import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components.dart';

enum ShimmerListType {
  card,
  list,
  square,
}

class ListScreenShimmer extends StatelessWidget {
  final ShimmerListType type;

  const ListScreenShimmer({
    Key? key,
    this.type = ShimmerListType.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SzikAppScaffold(
      resizeToAvoidBottomInset: true,
      appBarTitle: 'PLACEHOLDER_LOADING'.tr(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SearchBarShimmer(),
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
      ),
    );
  }
}
