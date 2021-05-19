import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  static const String route = '/feed';

  const FeedPage({Key key = const Key('FeedPage')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Feed'),
      ),
    );
  }
}
