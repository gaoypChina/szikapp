import 'package:flutter/material.dart';

import '../models/tasks.dart';
import '../ui/themes.dart';

class InvitationCard extends StatelessWidget {
  final TimetableTask data;

  const InvitationCard({Key? key, required this.data}) : super(key: key);

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
