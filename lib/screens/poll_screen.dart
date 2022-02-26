import 'package:flutter/material.dart';

import '../business/business.dart';

class PollScreen extends StatefulWidget {
  static const String route = '/poll';

  static MaterialPage page({required PollManager manager}) {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: PollScreen(),
    );
  }

  const PollScreen({Key? key}) : super(key: key);

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
