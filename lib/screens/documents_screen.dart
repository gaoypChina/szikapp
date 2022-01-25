import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../models/goodtoknow.dart';
import '../ui/themes.dart';

class DocumentsScreen extends StatelessWidget {
  static const String route = '/documents';

  final GoodToKnowManager manager;

  static MaterialPage page({required GoodToKnowManager manager}) {
    return MaterialPage(
      name: route,
      key: const ValueKey(route),
      child: DocumentsScreen(manager: manager),
    );
  }

  const DocumentsScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder<void>(
      future: manager.refresh(),
      shimmer: const ListScreenShimmer(),
      child: DocumentsListView(manager: manager),
    );
  }
}

class DocumentsListView extends StatefulWidget {
  final GoodToKnowManager manager;

  const DocumentsListView({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  _DocumentsListViewState createState() => _DocumentsListViewState();
}

class _DocumentsListViewState extends State<DocumentsListView> {
  List<GoodToKnow> items = [];
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
        newItems = widget.manager.filter(GoodToKnowCategory.pinnedPost);
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondaryVariant,
              offset: const Offset(0.0, 2.0),
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
    return CustomScaffold(
      appBarTitle: 'DOCUMENTS_TITLE'.tr(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchBar(
                onChanged: _onSearchFieldChanged,
                validator: _validateTextField,
                placeholder: 'PLACEHOLDER_SEARCH'.tr(),
              ),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
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
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text('PLACEHOLDER_EMPTY_SEARCH_RESULTS'.tr()),
                      )
                    : RefreshIndicator(
                        onRefresh: () => widget.manager.refresh(),
                        child: ListView.builder(
                          itemBuilder: _buildListItem,
                          itemCount: items.length,
                        ),
                      ),
              ),
            ],
          ),
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
                DocumentDetails(
                  document: (items.length <= index) ? null : items[index],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
