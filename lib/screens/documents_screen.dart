import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/good_to_know_manager.dart';
import '../components/search_bar.dart';
import '../components/tab_choice.dart';
import '../main.dart';
import '../models/goodtoknow.dart';
import 'error_screen.dart';

class DocumentsScreen extends StatefulWidget {
  static const String route = '/documents';

  static MaterialPage page() {
    return const MaterialPage(
      name: route,
      key: ValueKey(route),
      child: DocumentsScreen(),
    );
  }

  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late List<GoodToKnow> items;

  @override
  void initState() {
    super.initState();
    items = Provider.of<GoodToKnowManager>(context, listen: false).items;
  }

  void _onSearchFieldChanged(String query) {
    var newItems =
        Provider.of<GoodToKnowManager>(context, listen: false).search(query);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Provider.of<GoodToKnowManager>(context, listen: false).refresh(),
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
                              'LABEL_FAVORITES'.tr(),
                              style:
                                  TextStyle(color: theme.colorScheme.secondary),
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
                ...items
                    .map(
                      (item) => Container(
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
                        child: Text(item.title),
                      ),
                    )
                    .toList()
              ],
            ),
          );
        }
      },
    );
  }
}
