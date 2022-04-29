import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components.dart';

class ListScreenShimmer extends StatelessWidget {
  final ShimmerListType type;
  final bool withSearchbar;

  const ListScreenShimmer({
    Key? key,
    this.type = ShimmerListType.card,
    this.withSearchbar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'PLACEHOLDER_LOADING'.tr(),
      body: ListShimmer(type: type, withSearchbar: withSearchbar),
    );
  }
}
