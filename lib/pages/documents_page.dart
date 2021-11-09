import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../business/good_to_know_manager.dart';
import '../main.dart';
import '../models/goodtoknow.dart';
import '../ui/screens/error_screen.dart';
import '../ui/widgets/search_bar.dart';
import '../ui/widgets/tab_choice.dart';

class DocumentsPage extends StatefulWidget {
  static const String route = '/documents';

  const DocumentsPage({Key? key}) : super(key: key);

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  late final GoodToKnowManager goodToKnowManager;
  late List<GoodToKnow> items;

  @override
  void initState() {
    super.initState();
    goodToKnowManager = GoodToKnowManager();
    items = goodToKnowManager.posts;
  }

  void _onSearchFieldChanged(String query) {
    var newItems = goodToKnowManager.search(query);
    setState(() {
      items = newItems;
    });
  }

  String? _validateTextField(value) {
    if (value == null || value.isEmpty) {
      return 'ERROR_EMPTY_FIELD'.tr();
    }
    return null;
  }

  void _onTabChanged(int? newValue) {}

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 2.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Text(
        items[index].title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: goodToKnowManager.refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //Shrimmer
          return const Scaffold();
        } else if (snapshot.hasError) {
          Object? message;
          if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
            message = 'ERROR_NO_INTERNET'.tr();
          } else {
            message = snapshot.error;
          }
          return ErrorScreen(error: message ?? 'ERROR_UNKNOWN'.tr());
        } else {
          var theme = Theme.of(context);
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                //keresősáv
                SearchBar(
                  onChanged: _onSearchFieldChanged,
                  validator: _validateTextField,
                  placeholder: 'PLACEHOLDER_SEARCH'.tr(),
                ),
                //kedvencek
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: theme.colorScheme.secondary,
                            ),
                            Text(
                              'LABEL_FAVOURITES'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: theme.colorScheme.secondary,
                      )
                    ],
                  ),
                ),
                //kedvenc doksik felsorolása
                //lapválasztó
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: TabChoice(
                    choiceColor: theme.colorScheme.secondary,
                    wrapColor: theme.colorScheme.background,
                    fontColor: theme.colorScheme.background,
                    labels: [
                      'DOCUMENTS_OFFICIAL'.tr(),
                      'DOCUMENTS_PINNED'.tr(),
                    ],
                    onChanged: _onTabChanged,
                  ),
                ),
                //lapok listája
                Expanded(
                  child: ListView.builder(
                    itemBuilder: _buildListItem,
                    itemCount: items.length,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
