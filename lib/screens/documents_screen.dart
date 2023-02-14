import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/business.dart';
import '../components/components.dart';
import '../main.dart';
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
  DocumentsListViewState createState() => DocumentsListViewState();
}

class DocumentsListViewState extends State<DocumentsListView> {
  List<GoodToKnow> items = [];
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

  Widget _buildListItem(BuildContext context, int newIndex) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          index = newIndex;
        });
        showDialog(
          context: context,
          builder: (context) {
            return DocumentDetails(
              document: (items.length <= index) ? null : items[index],
            );
          },
        );
        SzikAppState.analytics.logEvent(name: 'document_open');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kPaddingLarge),
        margin: const EdgeInsets.symmetric(
          vertical: kPaddingSmall,
          horizontal: kPaddingLarge,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          ),
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Text(
          items[newIndex].title,
          style: theme.textTheme.bodyLarge,
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
              /*
              Container(
                margin: const EdgeInsets.all(20, 30, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CustomIcon(
                          CustomIcons.heartFull,
                          color: theme.colorScheme.secondary,
                        ),
                        Text(
                          'LABEL_FAVOURITES'.tr(),
                          style: theme
                              .textTheme
                              .headline3!
                              .copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
              */
              TabChoice(
                choiceColor: theme.colorScheme.secondary,
                wrapColor: theme.colorScheme.background,
                fontColor: theme.colorScheme.background,
                labels: [
                  'DOCUMENTS_ALL'.tr(),
                  'DOCUMENTS_PINNED'.tr(),
                  'DOCUMENTS_OFFICIAL'.tr(),
                ],
                onChanged: _onTabChanged,
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
        ],
      ),
    );
  }
}
