import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../utils/utils.dart';

class ArticleScreen extends StatelessWidget {
  static const String route = '/article';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: ArticleScreen(),
    );
  }

  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: IO.instance.getArticles(),
      child: CustomScaffold(
        appBarTitle: 'ARTICLE_TITLE'.tr(),
      ),
    );
  }
}
