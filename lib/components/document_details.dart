import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/goodtoknow.dart';
import '../ui/themes.dart';
import '../utils/utils.dart';
import 'components.dart';

class DocumentDetails extends StatelessWidget {
  final GoodToKnow? document;

  const DocumentDetails({
    Key? key,
    this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius:
              const BorderRadius.all(Radius.circular(kBorderRadiusNormal)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    document?.title ?? '',
                    style: theme.textTheme.headline5,
                  ),
                  CustomIcon(
                    CustomIcons.heartFull,
                    color: theme.colorScheme.secondary,
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                color: theme.colorScheme.secondary,
              ),
              SelectableText(
                document?.description ?? '',
                style: theme.textTheme.bodyText1,
              ),
              const Spacer(),
              Text(
                'LABEL_LAST_MODIFIED'.tr(
                  args: [
                    DateFormat('yyyy.MM.dd. hh:mm:ss')
                        .format(document?.lastUpdate ?? DateTime.now())
                  ],
                ),
                style: theme.textTheme.caption,
              ),
              if (document!.category == GoodToKnowCategory.document)
                Center(
                  child: ElevatedButton(
                    onPressed: () => openUrl(
                      document!.keyValuePairs![GoodToKnow.urlKey] ?? '',
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kBorderRadiusNormal),
                        ),
                        elevation: 0),
                    child: Text('BUTTON_OPEN'.tr()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
