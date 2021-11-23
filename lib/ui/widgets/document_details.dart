import 'package:flutter/material.dart';
import '../../models/goodtoknow.dart';

class DocumentDetails extends StatefulWidget {
  final GoodToKnow? document;

  const DocumentDetails({
    Key? key,
    this.document,
  }) : super(key: key);

  @override
  _DocumentDetailsState createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
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
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.document?.title ?? '',
                    style: theme.textTheme.headline5),
              ),
              Divider(
                thickness: 2,
                color: theme.colorScheme.secondary,
              ),
              Text(widget.document?.description ?? '',
                  style: theme.textTheme.headline6),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Utolsó módosítás: ${widget.document?.lastUpdate}',
                  style: theme.textTheme.headline6,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
