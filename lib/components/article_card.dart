import 'package:flutter/material.dart';

import '../models/resource.dart';
import '../ui/themes.dart';

class ArticleCard extends StatelessWidget {
  final Article data;

  const ArticleCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.background,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(kPaddingSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusNormal),
      ),
      child: Text(data.name),
    );
  }
}
