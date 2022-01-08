import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:szikapp/ui/themes.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
import '../models/goodtoknow.dart';
import '../utils/utils.dart';
import 'error_screen.dart';

class DocumentsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Provider.of<GoodToKnowManager>(context, listen: false).refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //Shrimmer
          return const Scaffold();
        } else if (snapshot.hasError) {
          if (SZIKAppState.connectionStatus == ConnectivityResult.none) {
            return ErrorScreen(
              errorInset: ErrorHandler.buildInset(
                context,
                errorCode: noConnectionExceptionCode,
              ),
            );
          }
          return ErrorScreen(error: snapshot.error ?? 'ERROR_UNKNOWN'.tr());
        } else {
          return DocumentsList(
            manager: Provider.of<GoodToKnowManager>(context, listen: false),
          );
        }
      },
    );
  }
}

class DocumentsList extends StatefulWidget {
  final GoodToKnowManager manager;

  const DocumentsList({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  _DocumentsListState createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  late List<GoodToKnow> items;
  bool infoWidgetVisible = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    items = widget.manager.items;
  }

  void _onSearchFieldChanged(String query) {
    var newItems = widget.manager.search(query);
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

  void _onTabChanged(int? newValue) {
    List<GoodToKnow> newItems;
    switch (newValue) {
      case 2:
        newItems = widget.manager.filter(GoodToKnowCategory.document);
        break;
      case 1:
        newItems = widget.manager.filter(GoodToKnowCategory.pinned_post);
        break;
      default:
        newItems = widget.manager.items;
        break;
    }
    setState(() {
      items = newItems;
    });
  }

  void _hideInfoWidget() {
    setState(() {
      infoWidgetVisible = false;
      index = 0;
    });
  }

  Widget _buildListItem(BuildContext context, int pindex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          infoWidgetVisible = true;
          index = pindex;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Text(
          items[pindex].title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SzikAppScaffold(
      appBarTitle: 'DOCUMENTS_TITLE'.tr(),
      body: Stack(
        children: [
          Column(
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
                    'DOCUMENTS_ALL.tr'.tr(),
                    'DOCUMENTS_PINNED'.tr(),
                    'DOCUMENTS_OFFICIAL'.tr(),
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

          //Info widget
          Visibility(
            visible: infoWidgetVisible,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _hideInfoWidget,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Color(0xab000000),
                    ),
                  ),
                ),
                //Tényleges infowidget a szürke háttér előtt
                DocumentDetails(
                    document: (items.length <= index) ? null : items[index])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
