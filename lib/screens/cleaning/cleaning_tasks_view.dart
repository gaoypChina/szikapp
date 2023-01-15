import 'package:flutter/material.dart';

import '../../business/kitchen_cleaning_manager.dart';

class CleaningTasksView extends StatelessWidget {
  final KitchenCleaningManager manager;

  const CleaningTasksView({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        return Container();
      }),
      itemCount: manager.tasks.length,
    );
  }
}
