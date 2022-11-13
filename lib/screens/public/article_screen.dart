import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../main.dart';
import '../../models/resource.dart';
import '../../utils/utils.dart';
import '../screens.dart';

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
    return FutureBuilder<List<Article>>(
      future: IO.instance.getArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListScreenShimmer();
        } else if (snapshot.hasError) {
          if (SzikAppState.connectionStatus == ConnectivityResult.none) {
            return ErrorScreen(
              errorInset: ErrorHandler.buildInset(
                context,
                errorCode: noConnectionExceptionCode,
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          var articles = snapshot.data!;
          return CustomScaffold(
            appBarTitle: 'ARTICLE_TITLE'.tr(),
            body: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) =>
                  ArticleCard(data: articles[index]),
            ),
          );
        }
      },
    );
  }
}
