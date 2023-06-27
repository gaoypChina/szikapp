import 'package:flutter/material.dart';

import '../../business/business.dart';

class CleaningParticipantsView extends StatefulWidget {
  final KitchenCleaningManager manager;

  const CleaningParticipantsView({super.key, required this.manager});

  @override
  State<CleaningParticipantsView> createState() =>
      _CleaningParticipantsViewState();
}

class _CleaningParticipantsViewState extends State<CleaningParticipantsView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container();
  }
}
